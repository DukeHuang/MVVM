//
//  MainMenuViewController.m
//  CityManage
//
//  Created by Duke on 1/5/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "MainMenuViewController.h"
#import "AppDelegate.h"
#import "CMHttpManager+Cert.h"
#import "CMHttpManager+Login.h"
#import "CMUserDefault.h"
#import "CMGetUpload.h"
#import "CMHttpManager+PublicInfo.h"
#import "CMPublicInfoMTLModel.h"
@interface MainMenuViewController()
@property(nonatomic,strong) UITabBarController *tabBarController;

@property(nonatomic,strong) RACCommand *appInitCommand;

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    float spacing = 20.0f;
    float menuSize = (SCREEN_WIDTH - 2 * spacing) / 1.414;
    self.menuBackgroudWidth.constant = menuSize;
    self.menuBackgroudHeight.constant = menuSize;
    CGFloat transform = 45 * 3.14 / 180.0;
    self.menuBackgroudView.transform = CGAffineTransformMakeRotation(transform);
    self.menuBackgroudView.layer.borderWidth = 0.5;
    self.menuBackgroudView.layer.borderColor = [CM_COLOR_NAV CGColor];
    RACSignal *signal1 = [[[CMHttpManager sharedClient] getCertCategory] doNext:^(id x) {
        [CMUserDefault sharedInstance].certCategoryModel = x;
    }];
    RACSignal *signal2 = [[[CMHttpManager sharedClient] getPublicInfoWithCategoryCode:@"06" offset:0 limit:7] doNext:^(CMPublicInfoMTLModel *x) {
        [[CMUserDefault sharedInstance].urls addObjectsFromArray:x.rows];
    }];
   self.appInitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
       return [RACSignal merge:@[signal1,signal2]];
   }];
    
    [self.appInitCommand.executing
     subscribeNext:^(NSNumber *executing) {
//         @strongify(self)
         if (executing.boolValue) {
//             [self.view endEditing:YES];
             [SVProgressHUD showWithStatus:@"请稍候..."];
         } else {
             [SVProgressHUD dismiss];
         }
     }];
    [self.appInitCommand execute:nil];

}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ([segue.identifier isEqualToString:IMainMenuToTabbar]) {
         UITabBarController *tabBar = segue.destinationViewController;
         [tabBar setSelectedIndex:((UIButton *)sender).tag - 100];
     }
 }

- (IBAction)menuBtnTouchUpInside:(id)sender {
    [self performSegueWithIdentifier:IMainMenuToTabbar sender:sender];
}
@end
