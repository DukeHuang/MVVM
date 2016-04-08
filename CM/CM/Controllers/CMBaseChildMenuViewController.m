//
//  CMBaseChildMenuViewController.m
//  CM
//
//  Created by Duke on 1/8/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMBaseChildMenuViewController.h"
#import "CMComplaintViewController.h"
#import "CMPopViewController.h"
#import "CMPopWebViewController.h"
#import "CMCertViewController.h"
#import "CMServcieListViewController.h"


@interface CMBaseChildMenuViewController ()

@property (nonatomic,weak,readonly) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property(nonatomic,strong,readwrite) CMBaseChildMenuViewModel *viewModel;


@end

@implementation CMBaseChildMenuViewController
@dynamic tableView;
@dynamic viewModel;

- (void)awakeFromNib {
    self.viewModel  = [[CMBaseChildMenuViewModel alloc] initWithServices:nil params:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.iconImageView.image = [UIImage imageNamed:self.viewModel.menuModel.iconName];
    self.nameLabel.text = self.viewModel.menuModel.name;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CMBaseMenuDataModel *model = self.viewModel.menuModel;
    if (model.menuType == COMPLAINT_BUILD) {
        return 1;
    }
    else {
        return self.viewModel.childMenu.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CMBaseMenuDataModel *model = self.viewModel.childMenu[indexPath.row];
    if (self.viewModel.menuModel.menuType == COMPLAINT_BUILD) {
        
        UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"iComplaintBuildCell" forIndexPath:indexPath];
        cell.textLabel.text = model.name;
        
//        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        return cell;

    }
    else {
        UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//        cell.textLabel.text = model.name;
//        cell.textLabel.numberOfLines = 0;
        UILabel *titleLabel = [cell viewWithTag:100];
        titleLabel.text = model.name;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CMBaseMenuDataModel *model = self.viewModel.menuModel;
//    if (model.menuType == COMPLAINT_BUILD) {
//        return 88.0;
//    }
//    else {
//        return 44.0;
//    }
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.menuModel.menuType == COMPLAINT_BUILD) {
        return;
    }
    
    if (self.viewModel.menuModel.menuType >= 10 && self.viewModel.menuModel.menuType < 20) {
        CMPopViewController *vc = [[CMPopViewController alloc] init];
        [self.view addSubview:vc.view];
        vc.titleLabel.text = self.viewModel.menuModel.name;
        vc.leftLabel.text = @"受理范围提示:";
        vc.contentLabel.text = self.viewModel.menuModel.tipsStr;
        vc.viewCenterYConstraint.constant = -SCREEN_HEIGHT/2;
        [vc.view layoutIfNeeded];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^(void){
            vc.view.frame = self.view.frame;
            vc.viewCenterYConstraint.constant = 0;
            [vc.view layoutIfNeeded];
        } completion:^(BOOL isFinished){
        }];
        [[vc.dontButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [vc.view removeFromSuperview];
            [self performSegueWithIdentifier:@"iComplaintSegue" sender:indexPath];
        }];
    }
    if (self.viewModel.menuModel.menuType >= 20 && self.viewModel.menuModel.menuType < 30) {
        CMPopWebViewController *vc = [[CMPopWebViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
         [vc.webView loadHTMLString:self.viewModel.childMenu[indexPath.row].tipsStr baseURL:nil];
        [[vc.doneButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self dismissViewControllerAnimated:YES completion:nil];
             [self performSegueWithIdentifier:@"iPushtCert" sender:indexPath];
        }];
        [[vc.canelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    
    if (self.viewModel.menuModel.menuType >= 30 && self.viewModel.menuModel.menuType < 40) {
        //大件生活垃圾收运
        CMPopViewController *vc = [[CMPopViewController alloc] init];
        [self.view addSubview:vc.view];
        vc.titleLabel.text = self.viewModel.childMenu[indexPath.row].name;
        vc.leftLabel.text = @"受理范围提示:";
        vc.contentLabel.text = self.viewModel.childMenu[indexPath.row].tipsStr;
        vc.viewCenterYConstraint.constant = -SCREEN_HEIGHT/2;
        [vc.view layoutIfNeeded];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^(void){
            vc.view.frame = self.view.frame;
            vc.viewCenterYConstraint.constant = 0;
            [vc.view layoutIfNeeded];
        } completion:^(BOOL isFinished){
        }];
        [[vc.dontButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [vc.view removeFromSuperview];
            CMServcieListViewController *serviceVC = [MainStoryboard instantiateViewControllerWithIdentifier:@"iCMServcieListViewController"];
            serviceVC.viewModel.title = self.viewModel.childMenu[indexPath.row].name;
            serviceVC.beforeDataModel = self.viewModel.childMenu[indexPath.row];
            [self.navigationController pushViewController:serviceVC animated:YES];
        }];
        
    }
    
//    [self performS    egueWithIdentifier:@"iComplaintSegue" sender:indexPath];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"iComplaintSegue"]) {
        CMComplaintViewController *vc =(CMComplaintViewController *) segue.destinationViewController;
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        CMBaseMenuDataModel *model = self.viewModel.childMenu[indexPath.row];
        vc.viewModel.categoryCode = model.categoryCode;
        vc.viewModel.title = model.name;
        vc.beforeDataModel = self.viewModel.menuModel;
    }
    if ([segue.identifier isEqualToString:@"iPushtCert"]) {
        CMCertViewController *vc =(CMCertViewController *) segue.destinationViewController;
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        CMBaseMenuDataModel *model = self.viewModel.childMenu[indexPath.row];
        vc.viewModel.title = model.name;
        vc.viewModel.preDataModel = self.viewModel.menuModel;
        vc.viewModel.currentDataModel = model;
    }
}

@end
