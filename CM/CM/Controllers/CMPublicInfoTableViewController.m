//
//  CMPublicInfoTableViewController.m
//  CM
//
//  Created by Duke on 3/8/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMPublicInfoTableViewController.h"
#import "CMPublicInfoMTLModel.h"
#import "CMPublicInfoDetailViewController.h"
#import "CMMessageMTLModel.h"
#import "CMHttpManager+SelfCenter.h"

@interface CMPublicInfoTableViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CMPublicInfoTableViewController
@dynamic viewModel;
@dynamic tableView;

- (void)awakeFromNib {
    self.viewModel = [[CMPubliceInfoViewModel alloc] initWithServices:nil params:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"资讯";
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.viewModel.dataSouceArr removeAllObjects];
    [self.viewModel.requestRemoteDataCommand execute:@1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)bindViewModel
{
    
    self.viewModel.limit = 30;
    self.viewModel.offset = 0;
    //    self.viewModel.categoryCode = self.beforeDataModel.categoryCode;
    self.viewModel.shouldInfiniteScrolling = YES;
    self.viewModel.shouldPullToRefresh = YES;
    
    [super bindViewModel];
    
    [[RACObserve(self.viewModel,dataSouceArr) deliverOnMainThread] subscribeNext:^(id x) {
        [self.tableView reloadData];
    }];
    [[self.viewModel.requestRemoteDataCommand.executionSignals switchToLatest] subscribeNext:^(id  x) {
        if ([self.viewModel.type isEqualToString:@"0"]) {
            CMPublicInfoMTLModel *model = x;
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
        }
        else {
            CMMessageMTLModel *model = x;
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
        }
        
    }];
    
    [self.viewModel.requestRemoteDataCommand.executing
     subscribeNext:^(NSNumber *executing) {
//         @strongify(self)
         if (executing.boolValue) {
//             [self.view endEditing:YES];
             [SVProgressHUD showWithStatus:@"请稍候..."];
         } else {
             [SVProgressHUD dismiss];
         }
     }];
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSouceArr.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iCell" forIndexPath:indexPath];
    UILabel *titleLabel = [cell viewWithTag:100];
    if ([self.viewModel.type isEqualToString:@"0"]) {
        PublicInfo_Rows *punish = self.viewModel.dataSouceArr[indexPath.row];
        
        titleLabel.text = punish.title;
    } else {
        Message_Rows *message = self.viewModel.dataSouceArr[indexPath.row];
        titleLabel.text = message.title;
        if ([message.readStatus isEqualToString:@"0"]) {
            cell.backgroundColor = [UIColor whiteColor];
        }
        else {
            cell.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        }
    }
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 100;
//}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 60;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    PublicInfo_Rows *punish = self.viewModel.dataSouceArr[indexPath.row];
    CMPublicInfoDetailViewController *vc = [MainStoryboard instantiateViewControllerWithIdentifier:@"iCMPublicInfoDetailViewController"];
    if ([self.viewModel.type isEqualToString:@"0"]) {
        PublicInfo_Rows *punish = self.viewModel.dataSouceArr[indexPath.row];
        
        vc.title = punish.title;
        vc.contentHtmlString = punish.content;
    } else {
        Message_Rows *message = self.viewModel.dataSouceArr[indexPath.row];
        vc.title = message.title;
        vc.contentHtmlString = message.content;
        [[[CMHttpManager sharedClient] getMessageDetailWithAccessToken:[SSKeychain accessToken] messageId:[NSString stringWithFormat:@"%ld",message.rows_id]] subscribeNext:^(id x) {
            NSLog(@"读取信息成功");
        }];
        
    }
    
    [self.navigationController pushViewController:vc animated:YES];
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
