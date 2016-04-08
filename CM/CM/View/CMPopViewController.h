//
//  CMPopViewController.h
//  CM
//
//  Created by Duke on 1/26/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMPopViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *dontButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewCenterYConstraint;
@property (weak, nonatomic) IBOutlet UIView *popView;


@end
