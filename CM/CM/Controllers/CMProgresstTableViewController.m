//
//  CMProgresstTableViewController.m
//  CM
//
//  Created by Duke on 3/6/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMProgresstTableViewController.h"
#import "CMProgressTableViewCell.h"
#import "CMProgressMTLModel.h"
#import "CMComplaintDetailTableViewController.h"
#import "CMPunishMTLModel.h"
#import "CMPunishDetailViewController.h"
#import "CMCertProgressMTLModel.h"
#import "CMUserDefault.h"
#import "CMCertProgressDetailTableViewController.h"

@interface CMProgresstTableViewController ()
@property (weak, nonatomic,readwrite) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation CMProgresstTableViewController
@dynamic viewModel;
@dynamic tableView;

- (void)awakeFromNib {
    self.viewModel = [[CMProgressViewModel alloc] initWithServices:nil params:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.iconImageView.image = [UIImage imageNamed:self.viewModel.menuModel.iconName];
    self.nameLabel.text = self.viewModel.menuModel.name;
    self.tableView.tableFooterView = [UIView new];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)bindViewModel
{
    
    self.viewModel.limit = 30;
    self.viewModel.offset = 0;
    self.viewModel.shouldInfiniteScrolling = YES;
    self.viewModel.shouldPullToRefresh = YES;
    
    [super bindViewModel];
    
    
    [[RACObserve(self.viewModel,dataSouceArr) deliverOnMainThread] subscribeNext:^(id x) {
        [self.tableView reloadData];
    }];
    [[self.viewModel.requestRemoteDataCommand.executionSignals switchToLatest] subscribeNext:^(CMProgressMTLModel *model) {
        if (self.viewModel.page == 1) {
            self.viewModel.dataSouceArr = [[NSMutableArray alloc] init];
        }
        if (model.rows.count > 0) {
            self.tableView.showsInfiniteScrolling = YES;
            [self.viewModel.dataSouceArr addObjectsFromArray:model.rows];
            self.viewModel.dataSouceArr = self.viewModel.dataSouceArr;
        }
        else {
            self.tableView.showsInfiniteScrolling = NO;
        }
    }];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.viewModel.dataSouceArr removeAllObjects];
    [self.viewModel.requestRemoteDataCommand execute:@1];
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSouceArr.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.viewModel.menuModel.menuType == PUNISH_PROGRESS) {
        Punish_Rows *punish = self.viewModel.dataSouceArr[indexPath.row];
        CMProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iProgressTableViewCell" forIndexPath:indexPath];
        NSDictionary *dic = @{
                              @"01":@"绿化园林",
                              @"02":@"环境卫生",
                              @"03":@"噪音污染",
                              @"04":@"违法建筑",
                              @"05":@"市容市貌",
                              @"06":@"政风行风",
                              @"07":@"商招店招",
                              };
        if (punish.categoryCode.length > 2) {
            NSString *str = [dic objectForKey:[punish.categoryCode substringToIndex:2 ]];
            cell.title.text = [str stringByAppendingString:@"投诉"];
        }
        else {
            NSString *str = [dic objectForKey:punish.categoryCode];
            cell.title.text = [str stringByAppendingString:@"投诉"];
        }
        //    0等待受理；1投诉未接收；2投诉已接收；3正在处理；4处理完毕
        NSString *status;
        UIColor *statusBackgroundColor;
        switch ([punish.status intValue]) {
            case 1:
                status = @"事先告知";
                statusBackgroundColor = [UIColor yellowColor];
                break;
            case 2:
                status = @"听证告知";
                statusBackgroundColor = [UIColor blueColor];
                break;
            case 3:
                status = @"处罚决定";
                statusBackgroundColor = [UIColor yellowColor];
                break;
            case 4:
                status = @"案件完结";
                statusBackgroundColor = [UIColor greenColor];
                break;
            default:
                break;
        }
        cell.status.text = status;
        cell.status.backgroundColor = statusBackgroundColor;
        [cell.status setCornerRadius];
        
        if ([punish.row_newProgress isEqualToString:@"1"]) {
            cell.backgroundColor = [UIColor whiteColor];
        }
        else {
            cell.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        }
        return cell;

    }
    else if (self.viewModel.menuModel.menuType == CER_JDCX){
        CertProgress_Rows *cert = self.viewModel.dataSouceArr[indexPath.row];
        CMProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iProgressTableViewCell" forIndexPath:indexPath];
        for (CertRows *rows in [CMUserDefault sharedInstance].certCategoryModel.rows) {
            if (rows.code == cert.categoryCode) {
                cell.title.text = rows.name;
            }
        }
        NSString *status;
        UIColor *statusBackgroundColor;
        switch ([cert.status intValue]) {
            case 0:
                status = @"等待受理";
                statusBackgroundColor = [UIColor yellowColor];
                break;
            case 1:
                status = @"通过";
                statusBackgroundColor = [UIColor greenColor];
                break;
            case 2:
                status = @"不通过";
                statusBackgroundColor = [UIColor redColor];
                break;
            default:
                break;
        }
        cell.status.text = status;
        cell.status.backgroundColor = statusBackgroundColor;
        [cell.status setCornerRadius];
        
//        if ([CertProgress_Rows.row_newProgress isEqualToString:@"1"]) {
//            cell.backgroundColor = [UIColor whiteColor];
//        }
//        else {
//            cell.backgroundColor = [UIColor grayColor];
//        }
        return cell;
    }
    else {
        Progress_Rows *progress = self.viewModel.dataSouceArr[indexPath.row];
        CMProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iProgressTableViewCell" forIndexPath:indexPath];
        cell.title.text = progress.title;
        
        //    0等待受理；1投诉未接收；2投诉已接收；3正在处理；4处理完毕
        NSString *status;
        UIColor *statusBackgroundColor;
        switch ([progress.status intValue]) {
            case 0:
                status = @"等待受理";
                statusBackgroundColor = [UIColor yellowColor];
                break;
            case 1:
                status = @"投诉未接收";
                statusBackgroundColor = [UIColor redColor];
                break;
            case 2:
                status = @"投诉已接收";
                statusBackgroundColor = [UIColor yellowColor];
                break;
            case 3:
                status = @"正在处理";
                statusBackgroundColor = [UIColor greenColor];
                break;
            case 4:
                status = @"处理完毕";
                statusBackgroundColor = [UIColor yellowColor];
                break;
                
            default:
                break;
        }
        cell.status.text = status;
        cell.status.backgroundColor = statusBackgroundColor;
        [cell.status setCornerRadius];
        
        if ([progress.Progress isEqualToString:@"0"]) {
            cell.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        }
        else {
            cell.backgroundColor = [UIColor whiteColor];
        }
        return cell;
    }
    
    
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 100;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.menuModel.menuType == PUNISH_PROGRESS) {
        CMPunishDetailViewController *progressVC = [MainStoryboard instantiateViewControllerWithIdentifier:@"iCMPunishDetailViewController"];
        Punish_Rows *punish = self.viewModel.dataSouceArr[indexPath.row];
        progressVC.penaltyId = [NSString stringWithFormat:@"%ld",(long)punish.row_id];
    
        [self.navigationController pushViewController:progressVC animated:YES];
    }
    else if (self.viewModel.menuModel.menuType == CER_JDCX) {
        CMCertProgressDetailTableViewController *progressVC = [MainStoryboard instantiateViewControllerWithIdentifier:@"iCMCertProgressDetailTableViewController"];
        CertProgress_Rows *cert = self.viewModel.dataSouceArr[indexPath.row];
        progressVC.rows = cert;
        progressVC.mat = cert.mat;
        progressVC.title = cert.category.name;
        [self.navigationController pushViewController:progressVC animated:YES];
    }
    else {
        CMComplaintDetailTableViewController *progressVC = [MainStoryboard instantiateViewControllerWithIdentifier:@"iCMComplaintDetailTableViewController"];
        progressVC.progress =  self.viewModel.dataSouceArr[indexPath.row];
        
        [self.navigationController pushViewController:progressVC animated:YES];
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

@end
