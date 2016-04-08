//
//  MainMenuViewController.h
//  CityManage
//
//  Created by Duke on 1/5/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMenuViewController : UIViewController

//btn
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UIView *menuBackgroudView;

//constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuBackgroudWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuBackgroudHeight;

//action
- (IBAction)menuBtnTouchUpInside:(id)sender;

@end
