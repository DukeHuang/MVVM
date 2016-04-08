//
//  CMLoginViewController.m
//  CM
//
//  Created by Duke on 1/12/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMLoginViewController.h"
#import "CMLoginViewModel.h"
#import "CMLoginModel.h"
#import "CMViewModelServicesImpl.h"
#import <AFNetworking.h>
#import "CMGetUpload.h"

@interface CMLoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property(nonatomic,strong,readwrite)CMLoginViewModel *viewModel;


@end

@implementation CMLoginViewController

@dynamic viewModel;

- (void)awakeFromNib {
    self.viewModel  = [[CMLoginViewModel alloc] initWithServices:nil params:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *dic = @{
                          NSFontAttributeName:[UIFont systemFontOfSize:17.0],
                          NSForegroundColorAttributeName:CM_COLOR_NAV,
                          NSUnderlineStyleAttributeName:@1
                          };
    NSAttributedString *registerButtonString = [[NSAttributedString alloc] initWithString:@"注册" attributes:dic];
    [self.registerButton setAttributedTitle:registerButtonString forState:UIControlStateNormal];
    
    NSAttributedString *forgetButtonString = [[NSAttributedString alloc] initWithString:@"忘记密码?" attributes:dic];
    [self.forgetButton setAttributedTitle:forgetButtonString forState:UIControlStateNormal];
    
    self.usernameTextField.text = [SSKeychain username];
    self.passwordTextField.text = [SSKeychain password];
}

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self)
    
    RAC(self.viewModel,username) = self.usernameTextField.rac_textSignal;
    RAC(self.viewModel,password) = self.passwordTextField.rac_textSignal;
    
    //登陆中...
    [self.viewModel.loginCommand.executing
          subscribeNext:^(NSNumber *executing) {
        @strongify(self)
        if (executing.boolValue) {
            [self.view endEditing:YES];
            [SVProgressHUD showWithStatus:@"登录中..."];
        } else {
            [SVProgressHUD dismiss];
        }
    }];
   
    //登陆信号返回
    [[self.viewModel.loginCommand.executionSignals switchToLatest]
     subscribeNext:^(CMLoginModel *model) {
         if (model.success) {
             [self.viewModel.getUptokenCommand execute:nil];
             [TSMessage showNotificationInViewController:self.navigationController
                                                subtitle:@"登录成功"
                                                    type:TSMessageNotificationTypeSuccess];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(),^{
                 [self dismissViewControllerAnimated:YES completion:nil];
             });
         }
         
     }];
    [[self.viewModel.getUptokenCommand.executionSignals switchToLatest]  subscribeNext:^(CMGetUpload *x) {
        if (x.success) {
            [SSKeychain setQiniuToken:x.data];
        }
    }];
    
    //登录按钮属性和事件
    RAC(self.loginButton,enabled) = self.viewModel.validLoginSignal;
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         [self.viewModel.loginCommand execute:nil];
     }];
    
    //注册按钮事件
    [[self.registerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self performSegueWithIdentifier:@"iRegister" sender:nil];
    }];
    
    [[self.forgetButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self performSegueWithIdentifier:@"iForgot" sender:nil];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
