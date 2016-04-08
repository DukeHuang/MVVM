//
//  AppDelegate.h
//  CM
//
//  Created by Duke on 1/6/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Reachability.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, assign, readonly) NetworkStatus networkStatus;

@end

