//
//  AppDelegate.m
//  CM
//
//  Created by Duke on 1/6/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark- UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self configureKeyboardManager];
    [self configureReachability];
    [self configureApperance];
    [NSThread sleepForTimeInterval:2.0];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Application configuraiton 

-(void)configureKeyboardManager {
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)configureReachability {
    self.reachability = [Reachability reachabilityForInternetConnection];
    RAC(self,networkStatus) = [[[[[NSNotificationCenter defaultCenter]
        rac_addObserverForName:kReachabilityChangedNotification object:nil]
        map:^(NSNotification *notification) {
        return @([notification.object currentReachabilityStatus]);
    }]
        startWith:@(self.reachability.currentReachabilityStatus)]
        distinctUntilChanged];
    
    @weakify(self)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @strongify(self)
        [self.reachability startNotifier];
    });
    [[RACObserve(CMAppDelegate, networkStatus)
      deliverOnMainThread]
     subscribeNext:^(NSNumber *networkStatus) {
         if (networkStatus.integerValue == NotReachable)
         {
             [TSMessage showNotificationWithTitle:@"提示" subtitle:@"没有网络连接" type:TSMessageNotificationTypeWarning];
         }
     }];
    
}

- (void)configureApperance {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [UITabBar appearance].tintColor = CM_COLOR_NAV;
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
//                                                         forBarMetrics:UIBarMetricsDefault];
}

@end
