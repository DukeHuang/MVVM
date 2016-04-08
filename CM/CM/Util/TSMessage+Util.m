//
//  TSMessage+Util.m
//  CM
//
//  Created by Duke on 1/14/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "TSMessage+Util.h"

@implementation TSMessage (Util)
+(void)showNotificationInViewController:(UIViewController *)viewController
                               subtitle:(NSString *)subtitle
                                   type:(TSMessageNotificationType)type
{
    [self showNotificationInViewController:viewController
                                     title:@"提示"
                                  subtitle:subtitle
                                     image:nil
                                      type:type
                                  duration:1.0
                                  callback:nil
                               buttonTitle:nil
                            buttonCallback:nil
                                atPosition:TSMessageNotificationPositionNavBarOverlay
                      canBeDismissedByUser:YES];
    
}
@end
