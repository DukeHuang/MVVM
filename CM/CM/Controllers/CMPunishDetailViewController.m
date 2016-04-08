//
//  CMPunishDetailViewController.m
//  CM
//
//  Created by Duke on 3/7/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMPunishDetailViewController.h"
#import "CMHttpManager+Compliant.h"
#import "CMPunishDetailMTLModel.h"
#import "CMHttpSessionManager+File.h"
#import "CMPopWebViewController.h"



@interface CMPunishDetailViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong) CMPunishDetailMTLModel *model;

@property(nonatomic,strong)RACCommand *getPunishDetailCommand;
@property(nonatomic,strong)RACCommand *downLoadFileCommand;


@property(nonatomic,strong)NSMutableArray *contentArr;
@property(nonatomic,strong)NSMutableArray *downloadArr;
@property(nonatomic,assign)NSInteger  appStatus;

@end

@implementation CMPunishDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentArr = [NSMutableArray arrayWithArray:@[@"",@"",@""]];
    self.downloadArr = [NSMutableArray arrayWithArray:@[@"",@"",@""]];
    self.title = @"处罚详情";
    // Do any additional setup after loading the view.
    self.getPunishDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[CMHttpManager sharedClient] getPenaltyDetailWithAccessToken:[SSKeychain accessToken] penaltyId:self.penaltyId];
    }];
    
    
    self.downLoadFileCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *qiniuKey) {
        NSString *savePath = [NSString createDocumentsFileWithFloderName:@"download" fileName:@""];
        
        return [[CMHttpSessionManager sharedClient] downloadFileURL:qiniuKey savePath:savePath fileName:qiniuKey];
    }];
    //下载单个文件...
    [self.downLoadFileCommand.executing
     subscribeNext:^(NSNumber *executing) {
         if (executing.boolValue) {
             [SVProgressHUD showWithStatus:@"下载中..."];
         } else {
             [SVProgressHUD dismiss];
         }
     }];
    
    [self.downLoadFileCommand.errors subscribeNext:^(id x){
        [TSMessage showNotificationInViewController:self.navigationController subtitle:@"下载失败" type:TSMessageNotificationTypeError];
    }];
    
    [self.getPunishDetailCommand.executing
     subscribeNext:^(NSNumber *executing) {
        if (executing.boolValue) {
//             [self.view endEditing:YES];
             [SVProgressHUD showWithStatus:@"请稍候..."];
         } else {
             [SVProgressHUD dismiss];
         }
     }];
    
    [[self.segmentControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISegmentedControl * x) {
        [self.webView loadHTMLString:self.contentArr[x.selectedSegmentIndex] baseURL:nil];
        [self setRightBarButton];
    }];

    
    [[[self.getPunishDetailCommand.executionSignals switchToLatest]
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(CMPunishDetailMTLModel *x) {
         self.model = x;
         [self factoryData];
         [self.segmentControl setSelectedSegmentIndex:self.appStatus];
         [self.webView loadHTMLString:self.contentArr[self.appStatus] baseURL:nil];
         [self setRightBarButton];
    }];
    
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下载文献" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonProgress:)];
    
    [self.getPunishDetailCommand execute:nil];
    
    
    
}
- (void)rightBarButtonProgress:(id)sender {
    UIBarButtonItem *item = (UIBarButtonItem *)sender;
    if ([item.title isEqualToString:@"下载文献"]) {
        [self downLoadFile];
    }
    else if([item.title isEqualToString:@"查看"]) {
        [self openFile];
    }
}

- (void)openFile {
    CMPopWebViewController *vc = [[CMPopWebViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    NSInteger index = self.segmentControl.selectedSegmentIndex;
    NSString *qiniuKey = self.downloadArr[index];
    NSURL *fileURL = [NSURL fileURLWithPath:[NSString createDocumentsFileWithFloderName:@"download" fileName:qiniuKey]];
    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
    [vc.webView loadRequest:request];
    vc.webView.scalesPageToFit = YES;
    [[vc.doneButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [vc.doneButton setTitle:@"确定" forState:UIControlStateNormal];
    [[vc.canelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)downLoadFile {
    NSInteger index = self.segmentControl.selectedSegmentIndex;
    NSString *qiniuKey = self.downloadArr[index];
    if ([qiniuKey isExist]) {
        [[self.downLoadFileCommand execute:qiniuKey] subscribeNext:^(id x) {
//            certMatinf.downloadedURL = [NSString createDocumentsFileWithFloderName:@"download" fileName:qiniuKey];
//            [self.tableView reloadData];
            [self setRightBarButton];
        }];
    }
    
}

-(void)factoryData {
    
    self.appStatus = [self getAppStatusWithServiceStatusOrMattype:[self.model.data.status intValue]];
    if (self.appStatus == 0) {
        [self.segmentControl setEnabled:YES forSegmentAtIndex:0];
        [self.segmentControl setEnabled:NO forSegmentAtIndex:1];
        [self.segmentControl setEnabled:NO forSegmentAtIndex:2];
    }
    else if(self.appStatus == 1) {
        [self.segmentControl setEnabled:YES forSegmentAtIndex:0];
        [self.segmentControl setEnabled:YES forSegmentAtIndex:1];
        [self.segmentControl setEnabled:NO forSegmentAtIndex:2];
    }
    else if(self.appStatus == 2) {
        [self.segmentControl setEnabled:NO forSegmentAtIndex:0];
        [self.segmentControl setEnabled:YES forSegmentAtIndex:1];
        Punish_Mat *preMat = self.model.data.mat[1];
        self.contentArr[2] =preMat.content;
        self.downloadArr[2] = preMat.docPath;
    }
    
    
    for (int i = 0; i < self.model.data.mat.count; i++) {
        Punish_Mat *mat = self.model.data.mat[i];
        int index = [self getAppStatusWithServiceStatusOrMattype:[mat.type intValue]];
        self.contentArr[index] = mat.content;
        self.downloadArr[index] = mat.docPath;
    }
}

-(void)setRightBarButton {
    NSInteger index = self.segmentControl.selectedSegmentIndex;
    NSString *qiniuKey = self.downloadArr[index];
    if ([qiniuKey isExist]) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        NSString *filePath = [NSString createDocumentsFileWithFloderName:@"download" fileName:qiniuKey];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            self.navigationItem.rightBarButtonItem.title = @"查看";
        }
        else {
            self.navigationItem.rightBarButtonItem.title = @"下载文献";
        }
    }
    else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.navigationItem.rightBarButtonItem.title = @"";
    }
}

-(int)getAppStatusWithServiceStatusOrMattype:(int)input {
    int status = 0;
    if (input == 1 || input == 2 ){
        status = 0;
    }
    else if (input == 3) {
        status = 1;
    }
    else if (input == 4) {
        status = 2;
    }
    return status;
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
