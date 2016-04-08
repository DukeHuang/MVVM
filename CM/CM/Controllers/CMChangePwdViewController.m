//
//  CMChangePwdViewController.m
//  CM
//
//  Created by Duke on 3/15/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMChangePwdViewController.h"
#import "CMChangePwdViewModel.h"

@interface CMChangePwdViewController ()

@property(nonatomic,strong,readwrite)CMChangePwdViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UITextField *oldPwdTF;
@property (weak, nonatomic) IBOutlet UITextField *thenewPwdTF;
@property (weak, nonatomic) IBOutlet UITextField *reNewPwdTf;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation CMChangePwdViewController
@dynamic viewModel;
- (void)awakeFromNib {
    self.viewModel  = [[CMChangePwdViewModel alloc] initWithServices:nil params:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bindViewModel {
    [super bindViewModel];
    RAC(self.viewModel,oldPassword) = self.oldPwdTF.rac_textSignal;
    RAC(self.viewModel,theNewPassword) = self.thenewPwdTF.rac_textSignal;
    RAC(self.viewModel,reNewPassword) = self.reNewPwdTf.rac_textSignal;

    
    [[self.doneButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        //        [self performSegueWithIdentifier:@"iProfile" sender:nil];
        [self myresignFirstResponder];
        [[self.viewModel.validPasswordCommand execute:nil] subscribeNext:^(id x) {
            if (x) {
                [self.viewModel.changePasswordCommand execute:nil];
            }
        }];
    }];
    @weakify(self)
    //注册中...
    [self.viewModel.changePasswordCommand.executing
     subscribeNext:^(NSNumber *executing) {
         @strongify(self)
         if (executing.boolValue) {
             [self.view endEditing:YES];
             [SVProgressHUD showWithStatus:@"修改中..."];
         } else {
             [SVProgressHUD dismiss];
         }
     }];
    
    //注册信号返回
    [[self.viewModel.changePasswordCommand.executionSignals switchToLatest]
     subscribeNext:^(CMLoginModel *model) {
         if (model.success) {
             [TSMessage showNotificationInViewController:self.navigationController
                                                subtitle:@"修改成功"
                                                    type:TSMessageNotificationTypeSuccess];
                          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(),^{
//                 NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:@"登陆失效"                                                                                                               };
//                 NSError *error = [NSError errorWithDomain:@"" code:INVALID_TOKEN userInfo:userinfo];
//                 [[RACSignal error:error] subscribe:self.viewModel.errors];
                 
//                              [SSKeychain deleteAccessToken];
                              [self.navigationController popViewControllerAnimated:YES];
//                              UINavigationController *loginNav = [LoginRegisterStoryboard instantiateViewControllerWithIdentifier:@"iLoginNavigationController"];
//                              [self.navigationController presentViewController:loginNav animated:YES completion:nil];
             });
         }
         
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)myresignFirstResponder {
    [self.oldPwdTF resignFirstResponder];
    [self.thenewPwdTF resignFirstResponder];
    [self.reNewPwdTf resignFirstResponder];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
