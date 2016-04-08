//
//  CMTabBarController.m
//  CM
//
//  Created by Duke on 1/12/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMTabBarController.h"
#import "CMLoginViewController.h"
#import "CMBaseMenuViewController.h"
#import "CMBaseMenuViewModel.h"
#import "CMUserDefault.h"
#import "CMMessageOpenViewController.h"

@interface CMTabBarController ()

@end

@implementation CMTabBarController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        //投诉
        CMBaseMenuViewController *vc0 = [MainStoryboard instantiateViewControllerWithIdentifier:@"iBaseMenuViewController"];
        UITabBarItem *item0 = [[UITabBarItem alloc] initWithTitle:CMS_TS image:[UIImage imageNamed:@"tabbar_toushu"] tag:0];
        vc0.tabBarItem = item0;
        CMBaseMenuViewModel *viewModel0 = [[CMBaseMenuViewModel alloc] initWithServices:nil params:@{@"tag":[NSNumber numberWithInteger:0]}];
        vc0.viewModel = viewModel0;
        
        //便民服务
        CMBaseMenuViewController *vc1 = [MainStoryboard instantiateViewControllerWithIdentifier:@"iBaseMenuViewController"];
        UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:CMS_BMFW image:[UIImage imageNamed:@"tabbar_bianmingfuwu"] tag:0];
        vc1.tabBarItem = item1;
        CMBaseMenuViewModel *viewModel1 = [[CMBaseMenuViewModel alloc] initWithServices:nil params:@{@"tag":[NSNumber numberWithInteger:1]}];
        vc1.viewModel = viewModel1;
        //证件申办
        CMBaseMenuViewController *vc2 = [MainStoryboard instantiateViewControllerWithIdentifier:@"iBaseMenuViewController"];
        UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:CMS_ZJSB image:[UIImage imageNamed:@"tabbar_zhengjianshenban"] tag:2];
        vc2.tabBarItem = item2;
        CMBaseMenuViewModel *viewModel2 = [[CMBaseMenuViewModel alloc] initWithServices:nil params:@{@"tag":[NSNumber numberWithInteger:2]}];
        [RACObserve([CMUserDefault sharedInstance], certCategoryModel) subscribeNext:^(CMCertCategoryMTLModel *model) {
            for (CertRows *row in model.rows) {
                for (CMBaseMenuDataModel *menuDataModel in viewModel2.menusArray)
                {
                    if ([row.code isEqualToString:menuDataModel.categoryCode]) {
                        menuDataModel.tipsStr = row.content;
                    }
                    for (CMBaseMenuDataModel *childMenuModel in menuDataModel.childMenu) {
                        if ([row.code isEqualToString:childMenuModel.categoryCode]) {
                            childMenuModel.tipsStr = row.content;
                        }
                    }
                }
                
            }
            
        }];
        vc2.viewModel = viewModel2;
        
        //行政处罚
        CMBaseMenuViewController *vc3 = [MainStoryboard instantiateViewControllerWithIdentifier:@"iBaseMenuViewController"];
        UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:CMS_XZCF image:[UIImage imageNamed:@"tabbar_xinzhengchufa"] tag:3];
        vc3.tabBarItem = item3;
        CMBaseMenuViewModel *viewModel3 = [[CMBaseMenuViewModel alloc] initWithServices:nil params:@{@"tag":[NSNumber numberWithInteger:3]}];
        vc3.viewModel = viewModel3;
        //信息公开
        CMMessageOpenViewController *vc4 = [MainStoryboard instantiateViewControllerWithIdentifier:@"iCMMessageOpen"];
        UITabBarItem *item4 = [[UITabBarItem alloc] initWithTitle:CMS_XXGK image:[UIImage imageNamed:@"tabbar_xinxigongkai"] tag:4];
        vc4.tabBarItem = item4;
        
        
        
        self.viewControllers = [NSArray arrayWithObjects:vc0,vc1,vc2,vc3,vc4,nil];
    }
    return  self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"" style:0 target:nil action:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)rightNavBarAction:(id)sender {
    
    if ([SSKeychain accessToken].isExist) {
        [self performSegueWithIdentifier:@"iPushSelfCenterViewController" sender:nil];
    }
    else {
        UINavigationController *loginNav = [LoginRegisterStoryboard instantiateViewControllerWithIdentifier:@"iLoginNavigationController"];
        [self.navigationController presentViewController:loginNav animated:YES completion:nil];
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)backToMenu:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
