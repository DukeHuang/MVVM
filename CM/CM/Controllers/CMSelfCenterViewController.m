//
//  CMSelfCenterViewController.m
//  CM
//
//  Created by Duke on 1/14/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMSelfCenterViewController.h"
#import "CMSelfCenterTableViewModel.h"
#import "CMSelfCenterActionTableViewCell.h"
#import "CMSelfCenterCell.h"
#import "CMSelfCenterUserInfoTableViewCell.h"
#import "CMUserDefault.h"
#import "CMProgresstTableViewController.h"
#import "CMPostProfileViewController.h"
#import "CMPublicInfoTableViewController.h"
#import "CMChangePwdViewController.h"
#import "CMUploadTableViewCell.h"
#import "CMCertMatinfMTLModel.h"
#import <IQActionSheetPickerView.h>
#import <IQMediaPickerController.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CMHttpSessionManager+File.h"
#import "CMUploadFileMTLModel.h"
#import "CMPopWebViewController.h"

@interface CMSelfCenterViewController ()<IQActionSheetPickerViewDelegate,IQMediaPickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITextViewDelegate>

@property(nonatomic,strong,readwrite) CMSelfCenterTableViewModel *viewModel;
@property (nonatomic,weak,readonly) IBOutlet UITableView *tableView;

@end

@implementation CMSelfCenterViewController

@dynamic viewModel;
@dynamic tableView;

- (void)awakeFromNib {
    self.viewModel  = [[CMSelfCenterTableViewModel alloc] initWithServices:nil params:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self)
    [RACObserve(self.viewModel,userNewModel.data)  subscribeNext:^(id x) {
        @strongify(self)
        [self.tableView reloadData];
    }];

    [self.viewModel.userNewCommand.executing
     subscribeNext:^(NSNumber *executing) {
         @strongify(self)
         if (executing.boolValue) {
             [self.view endEditing:YES];
             [SVProgressHUD showWithStatus:@"获取中..."];
         } else {
             [SVProgressHUD dismiss];
         }
     }];
    
}
- (void)bindViewModel {
    [super bindViewModel];
    [self.viewModel.upLoadFileCommand.executing
     subscribeNext:^(NSNumber *executing) {
         if (executing.boolValue) {
             [SVProgressHUD showWithStatus:@"上传中..."];
         } else {
             [SVProgressHUD dismiss];
         }
     }];
    [self.viewModel.profileOtherCommand.executing
     subscribeNext:^(NSNumber *executing) {
         if (executing.boolValue) {
             [SVProgressHUD showWithStatus:@"提交中..."];
         } else {
             [SVProgressHUD dismiss];
         }
     }];
    [[self.viewModel.profileOtherCommand.executionSignals switchToLatest] subscribeNext:^(CMModel* x) {
        if (x.success) {
            [TSMessage showNotificationInViewController:self.navigationController subtitle:@"上传成功" type:TSMessageNotificationTypeSuccess];
            [self.viewModel.userNewCommand execute:nil];
            [[self.viewModel.getProfileCommand execute:nil]  subscribeNext:^(User *x) {
                [[CMUserDefault sharedInstance] writeUserToPlist:x];
                [self.tableView reloadData];
            }];
        }
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.viewModel.userNewCommand execute:nil];
    [[self.viewModel.getProfileCommand execute:nil]  subscribeNext:^(User *x) {
        [[CMUserDefault sharedInstance] writeUserToPlist:x];
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.isPass ? self.viewModel.passArr.count : self.viewModel.noPassArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.isPass ? [(self.viewModel.passArr[section]) count] : [(self.viewModel.noPassArr[section]) count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.isPass) {
        switch (indexPath.section) {
            case 0:
            {
                CMSelfCenterUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iLoginCell" forIndexPath:indexPath ];
                [cell configureCellWithUser:[[CMUserDefault sharedInstance] readUserFromPlist]];
                [[[cell.reRegisterButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal ] subscribeNext:^(id x){
                    CMPostProfileViewController *vc = [LoginRegisterStoryboard instantiateViewControllerWithIdentifier:@"iCMPostProfileViewController"];
                    vc.viewModel.accessToken = [SSKeychain accessToken];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
                [[[cell.iconButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal ] subscribeNext:^(id x){
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
                
                
                return cell;
            }
                
                break;
                
            case 4:
            {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iLogoutCell" forIndexPath:indexPath ];
                return cell;
            }
                break;
            default:
            {
                CMSelfCenterActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iActionCell" forIndexPath:indexPath ];
                CMSelfCenterCell *data =(CMSelfCenterCell *)((self.viewModel.passArr)[indexPath.section][indexPath.row]);
                cell.icon.image = [UIImage imageNamed:data.iconName];
                [cell.lblTitle setText:data.title];
                [cell.hasTips setHidden:!data.hasTips];
                return cell;
            }
                break;
        }
    } else {
        switch (indexPath.section) {
            case 0:
            {
                CMSelfCenterUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iLoginCell" forIndexPath:indexPath ];
                [cell configureCellWithUser:[[CMUserDefault sharedInstance] readUserFromPlist]];
                return cell;
            }
                break;
            default:
            {
                CMSelfCenterActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iActionCell" forIndexPath:indexPath ];
                CMSelfCenterCell *data =(CMSelfCenterCell *)((self.viewModel.noPassArr)[indexPath.section][indexPath.row]);
                cell.icon.image = [UIImage imageNamed:data.iconName];
                [cell.lblTitle setText:data.title];
                [cell.hasTips setHidden:!data.hasTips];
                return cell;
            }
                break;
        }
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0 || section == 1) ? 0.1: 11;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? 90 : 44;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.viewModel.isPass) {
        if (indexPath.section == 4 && indexPath.row == 0) {
            [SSKeychain deleteAccessToken];
            [SSKeychain deletePassword];
            [SSKeychain deleteUser];
            [self.navigationController popViewControllerAnimated:YES];
        }
        if (indexPath.section == 1 ) {
            CMBaseMenuDataModel *model;
            if (indexPath.row == 0) {
                //投诉进度查询
                model = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"08" menuType:COMPLAINT_JDCX name:@"投诉进度查询" iconName:@"进度" childMenu:nil];
            }
            else if (indexPath.row == 1) {
                model = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"06" menuType:CER_JDCX name:@"申办进度查询" iconName:@"进度" childMenu:nil];
            }
            else {
                model = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"01" menuType:PUNISH_PROGRESS name:@"处罚意见查询" iconName:@"处罚意见" childMenu:nil];
            }
            CMProgresstTableViewController *progressVC = [MainStoryboard instantiateViewControllerWithIdentifier:@"iCMProgressTableViewController"];
            progressVC.viewModel.menuModel = model;
            progressVC.viewModel.title = model.name;
            [self.navigationController pushViewController:progressVC animated:YES];
        }
        if (indexPath.section == 2) {
            CMPublicInfoTableViewController *vc = [MainStoryboard instantiateViewControllerWithIdentifier:@"iCMPublicInfoTableViewController" ];
            vc.viewModel.type = @"1";
            vc.viewModel.title = @"我的消息";
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.section == 3) {
            CMChangePwdViewController *vc = [LoginRegisterStoryboard instantiateViewControllerWithIdentifier:@"iCMChangePwdViewController" ];
//            vc.viewModel.type = @"1";
            vc.viewModel.title = @"修改密码";
            [self.navigationController pushViewController:vc animated:YES];
        }
        
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
                self.viewModel.uploadFileName = x.fileName;
                [self.viewModel.profileOtherCommand execute:nil];
//                [self.tableView reloadData];
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
                self.viewModel.uploadFileName = x.fileName;
                [self.viewModel.profileOtherCommand execute:nil];
//                [self.tableView reloadData];
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


@end
