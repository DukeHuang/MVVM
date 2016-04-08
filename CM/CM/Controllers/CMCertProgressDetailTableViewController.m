//
//  CMCertProgressDetailTableViewController.m
//  CM
//
//  Created by Duke on 3/8/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMCertProgressDetailTableViewController.h"
#import "CMCertMatPassTableViewCell.h"
#import "CMCertMatNoPassTableViewCell.h"
#import "CMCertViewController.h"
#import "CMHttpManager+Cert.h"

@interface CMCertProgressDetailTableViewController ()

@property(nonatomic,strong)RACCommand *getCertDetailCommand;

@end

@implementation CMCertProgressDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"" style:0 target:nil action:nil];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.getCertDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSString *certId = [NSString stringWithFormat:@"%ld",self.rows.CertProgress_Rows_id];
        return [[CMHttpManager sharedClient] getCertDetailWithAccessToken:[SSKeychain accessToken] certId:certId];
    }];
    
    [self.getCertDetailCommand.executing
     subscribeNext:^(NSNumber *executing) {
         if (executing.boolValue) {
             [SVProgressHUD showWithStatus:@"请稍候..."];
         } else {
             [SVProgressHUD dismiss];
         }
     }];
    [self.getCertDetailCommand execute:nil];
    
    if ([self.rows.status isEqualToString:@"2"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重新申办" style:UIBarButtonItemStylePlain target:self action:@selector(reCert)];
    }
}

- (void)reCert {
    CMCertViewController *vc =(CMCertViewController *) [MainStoryboard instantiateViewControllerWithIdentifier:@"iCMCertViewController"];
//    NSIndexPath *indexPath = (NSIndexPath *)sender;
    
    CMBaseMenuDataModel *model = [[CMBaseMenuDataModel alloc] initWithCategoryCode:self.rows.categoryCode menuType:NULLTYPE name:self.rows.category.name iconName:@"" childMenu:nil];
    [self.navigationController pushViewController:vc animated:YES];
    vc.viewModel.title = model.name;
    vc.viewModel.currentDataModel = model;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    if ([self.rows.status isEqualToString:@"1"]) {
        return self.mat.count+1;
    }
    else {
        return self.mat.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.mat.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iCell3"forIndexPath:indexPath];
        UILabel *label = (UILabel *)[cell viewWithTag:100];
        if ([self.rows.desc isExist]) {
            [label setText:[NSString stringWithFormat:@"温馨提示：\n%@",self.rows.desc]];
        }
        return cell;
        
    }
    CertProgress_Mat *mat = self.mat[indexPath.row];
    if ([mat.status isEqualToString:@"2"]) {
        CMCertMatNoPassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iCell2"forIndexPath:indexPath];
        cell.title.text = mat.name;
        if (mat.verifyOpinion.length == 0) {
            cell.reason.text = @"原因不详";
        }
        else {
            cell.reason.text = mat.verifyOpinion;
        }
        
        
        return cell;
    } else {
        CMCertMatPassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iCell1"forIndexPath:indexPath];
        
        cell.title.text = mat.name;
        if ([mat.status isEqualToString:@"0"]) {
            cell.image.hidden = YES;
        }
        else {
            cell.image.hidden = NO;
        }
        return cell;
    }
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
