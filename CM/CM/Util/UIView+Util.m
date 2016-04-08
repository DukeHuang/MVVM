//
//  UIView+Util.m
//  CM
//
//  Created by Duke on 1/26/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "UIView+Util.h"

@implementation UIView (Util)

-(void) setCornerRadius {
    self.layer.cornerRadius = 1.5;
    self.layer.masksToBounds = YES;
}
@end
