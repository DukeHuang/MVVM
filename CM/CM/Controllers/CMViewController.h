//
//  CMBaseViewController.h
//  CM
//
//  Created by Duke on 1/12/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMViewController : UIViewController

@property(nonatomic,strong,readonly)CMViewModel *viewModel;

-(instancetype)initWithViewModel:(CMViewModel *)viewModel;

-(void)bindViewModel;

@end
