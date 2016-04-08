//
//  CMBaseViewController.m
//  CM
//
//  Created by Duke on 1/12/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMViewController.h"
#import "CMHttpManager+Login.h"
#import "CMGetUpload.h"

@interface CMViewController ()

@property(nonatomic,strong,readwrite) CMViewModel *viewModel;

@end

@implementation CMViewController

+(instancetype)allocWithZone:(struct _NSZone *)zone {
    CMViewController *viewController = [super allocWithZone:zone];
    
    @weakify(viewController)
    [[viewController rac_signalForSelector:@selector(viewDidLoad)]
     subscribeNext:^(id x) {
         @strongify(viewController)
         [viewController bindViewModel];
     }];
    return viewController;
}



-(CMViewController *)initWithViewModel:(id)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"" style:0 target:nil action:nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
-(void)bindViewModel {
    //System title view
    RAC(self,title) = RACObserve(self.viewModel, title);
    //titleView
    
    //errors
    [self.viewModel.errors subscribeNext:^(NSError *error) {
        if (error.code == INVALID_TOKEN) {
            [TSMessage showNotificationInViewController:self.navigationController
                                               subtitle:[error localizedFailureReason]
                                                   type:TSMessageNotificationTypeError];
            [self.navigationController popViewControllerAnimated:YES];
            UINavigationController *loginNav = [LoginRegisterStoryboard instantiateViewControllerWithIdentifier:@"iLoginNavigationController"];
            [self.navigationController presentViewController:loginNav animated:YES completion:nil];
        }
        else if (error.code == INVALID_UP_TOKEN) {
            [TSMessage showNotificationInViewController:self.navigationController
                                               subtitle:[error localizedFailureReason]
                                                   type:TSMessageNotificationTypeError];
            [self.navigationController popViewControllerAnimated:YES];
            UINavigationController *loginNav = [LoginRegisterStoryboard instantiateViewControllerWithIdentifier:@"iLoginNavigationController"];
            [self.navigationController presentViewController:loginNav animated:YES completion:nil];
        }
        else if (error.code == -1009) {
            [TSMessage showNotificationInViewController:self.navigationController
                                               subtitle:@"没有网络连接"
                                                   type:TSMessageNotificationTypeError];
        }
        else if (error.code == -1001) {
            [TSMessage showNotificationInViewController:self.navigationController
                                               subtitle:@"请求超时"
                                                   type:TSMessageNotificationTypeError];
        }
        else {
            [TSMessage showNotificationInViewController:self.navigationController
                                               subtitle:[error localizedFailureReason]
                                                   type:TSMessageNotificationTypeError];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.viewModel.willDisappearSignal sendNext:nil];
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
