//
//  TSMessage+Util.h
//  CM
//
//  Created by Duke on 1/14/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <TSMessage.h>

@interface TSMessage (Util)
+(void)showNotificationInViewController:(UIViewController *)viewController
                               subtitle:(NSString *)title
                                   type:(TSMessageNotificationType)type;

@end
