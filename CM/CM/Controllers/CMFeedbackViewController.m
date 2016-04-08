//
//  CMFeedbackViewController.m
//  CM
//
//  Created by Duke on 3/11/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMFeedbackViewController.h"

@interface CMFeedbackViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *donwButton;



@end

@implementation CMFeedbackViewController
@dynamic viewModel;
- (void)awakeFromNib {
    self.viewModel  = [[CMFeedbackViewModel alloc] initWithServices:nil params:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.textView.layer.borderWidth = 1.0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    
}

- (void)bindViewModel {
    [super bindViewModel];
    self.viewModel.title = @"意见反馈";
    RAC(self.viewModel,contentStr) = self.textView.rac_textSignal;
    @weakify(self)
    [self.viewModel.feedbackCommand.executing
     subscribeNext:^(NSNumber *executing) {
         @strongify(self)
         if (executing.boolValue) {
             [self.view endEditing:YES];
             [SVProgressHUD showWithStatus:@"提交中..."];
         } else {
             [SVProgressHUD dismiss];
         }
     }];
    [[self.viewModel.feedbackCommand.executionSignals switchToLatest]
     subscribeNext:^(CMLoginModel *model) {
         if (model.success) {
             [TSMessage showNotificationInViewController:self.navigationController
                                                subtitle:@"提交成功"
                                                    type:TSMessageNotificationTypeSuccess];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(),^{
                 [self.navigationController popViewControllerAnimated:YES];
             });
         }
         
     }];

    [[self.donwButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([self.textView.text isExist]) {
            [self.viewModel.feedbackCommand execute:nil];
        }
        else {
            [TSMessage showNotificationInViewController:self.navigationController subtitle:@"请输入反馈意见" type:TSMessageNotificationTypeError];
        }
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

@end
