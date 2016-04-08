//
//  CMCertViewController.m
//  CM
//
//  Created by Duke on 1/28/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMCertViewController.h"
#import "CMCertTableViewModel.h"
#import "CMUploadTableViewCell.h"
#import "CMCertMatinfMTLModel.h"
#import <IQActionSheetPickerView.h>
#import <IQMediaPickerController.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CMHttpSessionManager+File.h"
#import "CMUploadFileMTLModel.h"
#import "CMPopWebViewController.h"

@interface CMCertViewController ()<IQActionSheetPickerViewDelegate,IQMediaPickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITextViewDelegate>
//@property(nonatomic,strong,readwrite) CMCertTableViewModel *viewModel;

@property (nonatomic,weak,readonly) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation CMCertViewController
@dynamic viewModel;
@dynamic tableView;


- (void)awakeFromNib {
    self.viewModel  = [[CMCertTableViewModel alloc] initWithServices:nil params:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.viewModel.segmentSelectedFirst = YES;
    [self.viewModel.getCertMatinfoCommand execute:nil];
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

-(void)bindViewModel {
    [super bindViewModel];
    [[RACSignal merge:@[RACObserve(self.viewModel, upLoadArr),RACObserve(self.viewModel, downloadArr),RACObserve(self.viewModel, segmentSelectedFirst)]] subscribeNext:^(id x) {
        [self.tableView reloadData];
    }];
    
    [[self.segmentedControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISegmentedControl *control) {
        self.viewModel.segmentSelectedFirst = control.selectedSegmentIndex == 0 ? YES :NO;
    }];
    
    //上传单个文件...
    [self.viewModel.upLoadFileCommand.executing
     subscribeNext:^(NSNumber *executing) {
         if (executing.boolValue) {
             [SVProgressHUD showWithStatus:@"上传中..."];
         } else {
             [SVProgressHUD dismiss];
         }
     }];
    
    [self.viewModel.upLoadAllFileCommand.errors subscribe:self.viewModel.errors];
    
    //上传单个文件...
    [self.viewModel.upLoadAllFileCommand.executing
     subscribeNext:^(NSNumber *executing) {
         if (executing.boolValue) {
             [SVProgressHUD showWithStatus:@"上传中..."];
         } else {
             [SVProgressHUD dismiss];
         }
     }];
    //下载单个文件...
    [self.viewModel.downLoadFileCommand.executing
     subscribeNext:^(NSNumber *executing) {
         if (executing.boolValue) {
             [SVProgressHUD showWithStatus:@"下载中..."];
         } else {
             [SVProgressHUD dismiss];
         }
     }];
    [[self.doneButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [[self.viewModel.validupLoadAllFileCommand execute:nil] subscribeNext:^(id x) {
            if (x) {
                [self.viewModel.upLoadAllFileCommand execute:nil];
            }
        }];
    }];
    [[self.viewModel.upLoadAllFileCommand.executionSignals switchToLatest] subscribeNext:^(CMModel * x) {
        if (x.success) {
            [TSMessage showNotificationInViewController:self.navigationController
                                               subtitle:@"提交成功"
                                                   type:TSMessageNotificationTypeSuccess];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(),^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
    }];
    [[self.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.segmentSelectedFirst ? self.viewModel.upLoadArr.count : self.viewModel.downloadArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.viewModel.segmentSelectedFirst) {
        CMUploadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iCellUpload" forIndexPath:indexPath];
         CertMatinfRows *certMatinf = (CertMatinfRows*) self.viewModel.upLoadArr[indexPath.row];
        [self configureCell:cell atIndexPath:indexPath withObject:certMatinf];
        return cell;
    }
    else {
        CMUploadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iCellUpload" forIndexPath:indexPath];
        CertMatinfRows *certMatinf = (CertMatinfRows*) self.viewModel.downloadArr[indexPath.row];
        [self configureDownloadCell:cell atIndexPath:indexPath withObject:certMatinf];
        return cell;
    }
    
}
#pragma mark - Configure

- (void)configureCell:(CMUploadTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(CertMatinfRows *)certMatinf
{
    
    cell.titleLabel.text = certMatinf.name;
    if ([certMatinf.uploadFileName isExist]) {
        [cell.doneButton setTitle:@"删除" forState:UIControlStateNormal];
        [cell.doneButton setBackgroundColor:[UIColor redColor]];
        cell.fileNameLabel.text = certMatinf.uploadFileName;
        [[[cell.doneButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            certMatinf.uploadFileName = @"";
            [self.tableView reloadData];
        }];
    }
    else {
        cell.fileNameLabel.text = @"*";
        [cell.doneButton setBackgroundColor:CM_COLOR_NAV];
        [cell.doneButton setTitle:@"上传" forState:UIControlStateNormal];
        [[[cell.doneButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal]
         subscribeNext:^(id x) {
             UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:@"拍摄照片",@"选取照片",nil];
             actionSheet.tag = indexPath.row;
             [actionSheet.rac_buttonClickedSignal subscribeNext:^(id x) {
                 if ([x integerValue] == 2) {
                     return ;
                 }
                 IQMediaPickerControllerMediaType mediaType;
                 if ([x integerValue] == 0) {
                     mediaType = IQMediaPickerControllerMediaTypePhoto;
                 } else if ([x integerValue] == 1) {
                     mediaType = IQMediaPickerControllerMediaTypePhotoLibrary;
                 }
                 IQMediaPickerController *controller = [[IQMediaPickerController alloc] init];
                 
                 controller.view.tag = indexPath.row;
                 controller.delegate = self;
                 [controller setMediaType:mediaType];
                 [self presentViewController:controller animated:YES completion:nil];
             }];
             [actionSheet showInView:self.view];
         }];
    }

}
- (void)configureDownloadCell:(CMUploadTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(CertMatinfRows *)certMatinf
{
    
    cell.titleLabel.text = certMatinf.name;
    
    if ([certMatinf.downloadedURL isExist]) {
        [cell.doneButton setTitle:@"查看" forState:UIControlStateNormal];
        [cell.doneButton setBackgroundColor:[UIColor greenColor]];
        cell.fileNameLabel.text = certMatinf.downloadedURL;
        [[[cell.doneButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            CMPopWebViewController *vc = [[CMPopWebViewController alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
            NSURL *fileURL = [NSURL fileURLWithPath:certMatinf.downloadedURL];
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
        }];
    }
    else {
        cell.fileNameLabel.text = certMatinf.exPath;
        [cell.doneButton setBackgroundColor:CM_COLOR_NAV];
        [cell.doneButton setTitle:@"下载" forState:UIControlStateNormal];
        [[[cell.doneButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal]
         subscribeNext:^(id x) {
             //to do
            NSString *qiniuKey = certMatinf.exPath;
              [[self.viewModel.downLoadFileCommand execute:qiniuKey] subscribeNext:^(id x) {
                  certMatinf.downloadedURL = [NSString createDocumentsFileWithFloderName:@"download" fileName:qiniuKey];
                  [self.tableView reloadData];
              }];
         }];
    }
    
}
#pragma mark - mediaPickerControllerDelegate

- (void)mediaPickerController:(IQMediaPickerController*)controller didFinishMediaWithInfo:(NSDictionary *)info {
    [self handleMediaInfoWith:controller info:info index:controller.view.tag];
}

- (void)handleMediaInfoWith:(IQMediaPickerController *)controller info:(NSDictionary *)info index:(NSInteger)index
{
    switch (controller.mediaType)
    {
        case IQMediaPickerControllerMediaTypePhotoLibrary:
        {
            UIImage *image = info[@"IQMediaTypeImage"][0][@"IQMediaImage"];
            CMUploadFileDataModel *model = [[CMUploadFileDataModel alloc] init];
            model.mimeType = MIMETYPE_PNG;
            model.fileName = @"name0.png";
            model.dataFromPhotoLibrary = UIImagePNGRepresentation(image);
            model.mediaType = [NSNumber numberWithInteger:IQMediaPickerControllerMediaTypePhotoLibrary];
            [[self.viewModel.upLoadFileCommand execute:RACTuplePack(model,[NSNumber numberWithInteger:index])] subscribeNext:^(UploadFileData *x) {
                self.viewModel.upLoadArr[index].uploadFileName = x.fileName;
                [self.tableView reloadData];
            }];
        }
            break;
        case IQMediaPickerControllerMediaTypePhoto:
        {
            NSURL *mediaUrl = info[@"IQMediaTypeImage"][0][@"IQMediaURL"];
            CMUploadFileDataModel *model = [[CMUploadFileDataModel alloc] init];
            model.mimeType = MIMETYPE_PNG;
            model.fileName = @"name1.png";
            model.filePath = mediaUrl;
            model.mediaType = [NSNumber numberWithInteger:IQMediaPickerControllerMediaTypePhoto];
            [[self.viewModel.upLoadFileCommand execute:RACTuplePack(model,[NSNumber numberWithInteger:index])] subscribeNext:^(UploadFileData *x) {
                self.viewModel.upLoadArr[index].uploadFileName = x.fileName;
                [self.tableView reloadData];
            }];
        }
            break;
        default:
            break;
    }
}

- (void)mediaPickerControllerDidCancel:(IQMediaPickerController *)controller
{
    
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return (section == 0 || section == 1) ? 0.1: 11;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return indexPath.section == 0 ? 90 : 44;
//    
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
