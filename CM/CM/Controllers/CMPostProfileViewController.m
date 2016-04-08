//
//  CMPostProfileViewController.m
//  CM
//
//  Created by Duke on 3/4/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMPostProfileViewController.h"
#import "CMPostPorfileViewModel.h"
#import <IQActionSheetPickerView.h>
#import <IQMediaPickerController.h>
#import "CMGetUpload.h"
#import "CMUploadFileDataModel.h"
#import "CMUploadFileMTLModel.h"

@interface CMPostProfileViewController ()<IQActionSheetPickerViewDelegate,IQMediaPickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *idCardTF;
@property (weak, nonatomic) IBOutlet UIButton *rightSideButton;
@property (weak, nonatomic) IBOutlet UIImageView *rightSideImageView;
@property (weak, nonatomic) IBOutlet UIButton *otherSideButton;
@property (weak, nonatomic) IBOutlet UIImageView *otherSideImageView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property(nonatomic,strong,readwrite)CMPostPorfileViewModel *viewModel;


@end

@implementation CMPostProfileViewController
@dynamic viewModel;
- (void)awakeFromNib {
    self.viewModel  = [[CMPostPorfileViewModel alloc] initWithServices:nil params:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)bindViewModel {
    [super bindViewModel];
    [[self.viewModel.getUpTokenCommand.executionSignals switchToLatest]  subscribeNext:^(CMGetUpload *x) {
        if (x.success) {
            [SSKeychain setQiniuToken:x.data];
        }
    }];
    [self.viewModel.getUpTokenCommand execute:nil];
    
    RAC(self.viewModel,realname) = self.nameTF.rac_textSignal;
    RAC(self.viewModel,idCardNo) = self.idCardTF.rac_textSignal;
    
    RAC(self.rightSideImageView,image) = RACObserve(self.viewModel,idCardImage1);
    RAC(self.otherSideImageView,image) = RACObserve(self.viewModel,idCardImage2);
    //添加身份证照片
    void (^getDataBlock)(UIButton *btn) = ^(UIButton *btn) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                                delegate:self
                                                       cancelButtonTitle:@"取消"
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:@"拍摄照片",@"选取照片",nil];
        actionSheet.tag = btn.tag;
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
            controller.view.tag = btn.tag;
            controller.delegate = self;
            [controller setMediaType:mediaType];
            [self.navigationController presentViewController:controller animated:YES completion:nil];
        }];
        [actionSheet showInView:self.view];
    };
    [[self.rightSideButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:getDataBlock];
    [[self.otherSideButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:getDataBlock];
    
    [[self.doneButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [[self.viewModel.validPostCommand execute:nil] subscribeNext:^(NSNumber *x) {
            if ([ x boolValue]) {
                [self.viewModel.postProfileCommand execute:nil];
            }
        }];
    }];
    @weakify(self)
    [self.viewModel.postProfileCommand.executing
     subscribeNext:^(NSNumber *executing) {
         @strongify(self)
         if (executing.boolValue) {
             [self.view endEditing:YES];
             [SVProgressHUD showWithStatus:@"上传中..."];
         } else {
             [SVProgressHUD dismiss];
         }
     }];
    
    [[self.viewModel.postProfileCommand.executionSignals switchToLatest] subscribeNext:^(CMModel *x) {
        if (x.success) {
            [TSMessage showNotificationInViewController:self.navigationController
                                               subtitle:@"上传成功"
                                                   type:TSMessageNotificationTypeSuccess];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(),^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
    }];
//    self.viewModel.uploadFileCommand executing
    [self.viewModel.uploadFileCommand.executing
     subscribeNext:^(NSNumber *executing) {
         @strongify(self)
         if (executing.boolValue) {
             [self.view endEditing:YES];
             [SVProgressHUD showWithStatus:@"上传中..."];
         } else {
             [SVProgressHUD dismiss];
         }
     }];
}

#pragma mark - mediaPickerControllerDelegate

- (void)mediaPickerController:(IQMediaPickerController*)controller didFinishMediaWithInfo:(NSDictionary *)info {
    [self handleMediaInfoWith:controller info:info index:controller.view.tag-100];
}

- (void)handleMediaInfoWith:(IQMediaPickerController *)controller info:(NSDictionary *)info index:(NSInteger)index
{
    switch (controller.mediaType)
    {
        case IQMediaPickerControllerMediaTypePhotoLibrary:
        {
            UIImage *image = info[@"IQMediaTypeImage"][0][@"IQMediaImage"];
            [self.viewModel setValue:image forKeyPath:[NSString stringWithFormat:@"idCardImage%ld",(long)index]];
            CMUploadFileDataModel *model = [[CMUploadFileDataModel alloc] init];
                model.mimeType = MIMETYPE_PNG;
                model.fileName = @"name0.png";
                model.dataFromPhotoLibrary = UIImagePNGRepresentation(image);
                model.mediaType = [NSNumber numberWithInteger:IQMediaPickerControllerMediaTypePhotoLibrary];
                [[self.viewModel.uploadFileCommand execute:RACTuplePack(model,[NSNumber numberWithInteger:index])] subscribeNext:^(UploadFileData *x) {
                    [self.viewModel setValue:x.fileName forKeyPath:[NSString stringWithFormat:@"idCardImg%ld",(long)index]];
                }];
        }
            break;
        
        case IQMediaPickerControllerMediaTypePhoto:
        {
             UIImage *image = info[@"IQMediaTypeImage"][0][@"IQMediaImage"];
            [self.viewModel setValue:image forKeyPath:[NSString stringWithFormat:@"idCardImage%ld",(long)index]];
           
            CMUploadFileDataModel *model = [[CMUploadFileDataModel alloc] init];
            model.mimeType = MIMETYPE_PNG;
            model.fileName = @"name0.png";
            model.dataFromPhotoLibrary = UIImagePNGRepresentation(image);
            model.mediaType = [NSNumber numberWithInteger:IQMediaPickerControllerMediaTypePhotoLibrary];
            [[self.viewModel.uploadFileCommand execute:RACTuplePack(model,[NSNumber numberWithInteger:index])] subscribeNext:^(UploadFileData *x) {
                [self.viewModel setValue:x.fileName forKeyPath:[NSString stringWithFormat:@"idCardImg%ld",(long)index]];
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
