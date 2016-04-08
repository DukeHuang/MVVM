//
//  CMMessageOpenViewController.m
//  CM
//
//  Created by Duke on 2/18/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMMessageOpenViewController.h"
#import "CMMessageTableViewCell.h"
#import "CMPublicInfoTableViewController.h"
#import "CMFeedbackViewController.h"

@interface CMMessageOpenViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_itemArr;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CMMessageOpenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIView *view = [UIView new];
//    view
//    .backgroundColor = [UIColor clearColor];
//    self.tableView.tableFooterView = view;
    // Do any additional setup after loading the view.
    _itemArr = @[@[@"行政职责",@"区城管园林局的主要职责",@"04"],@[@"内设机构",@"区城管园林局设11个内设机构",@"01"],@[@"工作动态",@"发布的信息",@"06"],@[@"意见反馈",@"您好，如果您在使用过程中遇到任何问题，或者对我们有任何意见、建议，请您在此模块提交，我们将用心倾听，不断优化，为您提供更优质的服务",@"00"]];
    
//    01
//    机构职能
//    02
//    政策法规
//    03
//    规划计划
//    04
//    行政职责
//    05
//    业务工作
//    06
//    新闻动态
    self.tableView.tableFooterView  = [UIView new];
    UIImageView *view = [[UIImageView alloc] initWithFrame:self.tableView.frame];
    view.image = [UIImage imageNamed:@"menubg"];
    self.tableView.backgroundView = view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _itemArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CMMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.titleLabel.text = _itemArr[indexPath.row][0];
    cell.contentLabel.text = _itemArr[indexPath.row][1];
    if (indexPath.row == 3) {
        cell.iconImageView.image = [UIImage imageNamed:@"message"];
    }
    else {
        cell.iconImageView.image = [UIImage imageNamed:@"message_logo"];
    }
    return cell;
}
#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        if ([SSKeychain accessToken].isExist) {
            if([[SSKeychain user].verifyStatus isEqualToString:@"1"] ) {
                CMFeedbackViewController *vc = [MainStoryboard instantiateViewControllerWithIdentifier:@"iCMFeedbackViewController"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else {
                [TSMessage showNotificationInViewController:self.navigationController subtitle:@"账号未通过审核，不允许该操作" type:TSMessageNotificationTypeError];
            }

        }
        else {
            UINavigationController *loginNav = [LoginRegisterStoryboard instantiateViewControllerWithIdentifier:@"iLoginNavigationController"];
            [self.navigationController presentViewController:loginNav animated:YES completion:nil];
        }
    }
    else {
        CMPublicInfoTableViewController *vc = [MainStoryboard instantiateViewControllerWithIdentifier:@"iCMPublicInfoTableViewController" ];
        vc.viewModel.categoryCode = _itemArr[indexPath.row][2];
        vc.viewModel.title = _itemArr[indexPath.row][0];
        vc.viewModel.type = @"0";
        [self.navigationController pushViewController:vc animated:YES];

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88.0;
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
