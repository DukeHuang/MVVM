//
//  CMComplaintViewController.m
//  CM
//
//  Created by Duke on 1/19/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMComplaintViewController.h"
#import "CMComplaintViewModel.h"
#import <IQActionSheetPickerView.h>
#import <IQMediaPickerController.h>
#import "CMDistrictMTLModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "CMUploadFileDataModel.h"
#import "CMModel.h"
@import AVFoundation;
@import MediaPlayer;

@interface CMComplaintViewController()<IQActionSheetPickerViewDelegate,IQMediaPickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UIButton *areaButton;
@property (weak, nonatomic) IBOutlet UITextField *areaTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property (weak, nonatomic) IBOutlet UIButton *dataButton0;
@property (weak, nonatomic) IBOutlet UIButton *dataButton1;
@property (weak, nonatomic) IBOutlet UIButton *dataButton2;
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextField *comlaintPersonName;

@property (weak, nonatomic) IBOutlet UITextField *complaintPersonNOTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *personHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHightConstraint;

@property (nonatomic,copy) NSString *date;

@property(nonatomic,strong,readwrite)CMComplaintViewModel *viewModel;


@end

@implementation CMComplaintViewController
@dynamic viewModel;

-(void)awakeFromNib {
    self.viewModel = [[CMComplaintViewModel alloc] initWithServices:nil params:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentTextView.delegate = self;
    self.contentTextView.text = CMS_TEXTVIEW_PLACEHOLDER;
    [self.viewModel.districtCommand execute:nil];
    [self.verifyButton setBackgroundImage:[self buttonImageFromColor:[UIColor grayColor]] forState:UIControlStateDisabled];
    self.iconImageView.image = [UIImage imageNamed:self.beforeDataModel.iconName];
    self.titleLabel.text = self.viewModel.title;
    
    [self.titleTextField setCornerRadius];
    [self.dateButton setCornerRadius];
    [self.verifyButton setCornerRadius];
    [self.areaTextField setCornerRadius];
    [self.areaButton setCornerRadius];
    [self.contentTextView setCornerRadius];
    [self.bottomView setCornerRadius];
    [self.comlaintPersonName setCornerRadius];
    [self.complaintPersonNOTextField setCornerRadius];
    
    if (self.beforeDataModel.menuType == COMPLAINT_ZFHF) {
        self.personHeightConstraint.constant = 35;
        self.bottomViewHightConstraint.constant = 203+35;
    }
    else {
        self.personHeightConstraint.constant = 0;
        self.bottomViewHightConstraint.constant = 203;
    }
    
    UILongPressGestureRecognizer *longPress0 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    UILongPressGestureRecognizer *longPress1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    UILongPressGestureRecognizer *longPress2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    longPress0.minimumPressDuration = 0.8;
    longPress1.minimumPressDuration = 0.8;
    longPress2.minimumPressDuration = 0.8;
    [self.dataButton0 addGestureRecognizer:longPress0];
    [self.dataButton1 addGestureRecognizer:longPress1];
    [self.dataButton2 addGestureRecognizer:longPress2];
    
//    self.titleTextField.text = @"duketest111";
//    self.contentTextView.text = @"duketesttest111";
//    self.areaTextField.text = @"dukelocation111";
}
-(void)btnLong:(UILongPressGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        UIView *v = (UIView *)[gestureRecognizer view];
//        _longPressIndex = v.tag;
            UIActionSheet*  sheetShown = [[UIActionSheet alloc]initWithTitle:@"是否删除" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除",nil];
            [sheetShown showInView:self.view];
        [[sheetShown rac_buttonClickedSignal] subscribeNext:^(id x) {
            if (v.tag == 100) {
                self.viewModel.dataModel0.dataFromPhotoLibrary = nil;
                self.viewModel.dataModel0.fileName = nil;
                self.viewModel.dataModel0.mimeType = nil;
                self.viewModel.dataModel0.image = [UIImage imageNamed:@"ad"];
            }
            else if(v.tag == 101) {
                self.viewModel.dataModel1.dataFromPhotoLibrary = nil;
                self.viewModel.dataModel1.fileName = nil;
                self.viewModel.dataModel1.mimeType = nil;
                self.viewModel.dataModel1.image = [UIImage imageNamed:@"ad"];
            }
            else {
                self.viewModel.dataModel2.dataFromPhotoLibrary = nil;
                self.viewModel.dataModel2.fileName = nil;
                self.viewModel.dataModel2.mimeType = nil;
                self.viewModel.dataModel2.image = [UIImage imageNamed:@"ad"];
            }
        }];
    }
}
- (UIImage *)buttonImageFromColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
#pragma mark- bindViewModel
- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self)
    RAC(self.viewModel,complaintTitle) = self.titleTextField.rac_textSignal;
    RAC(self.viewModel,date) = RACObserve(self, date);
    RAC(self.viewModel,location) = self.areaTextField.rac_textSignal;
    RAC(self.viewModel,content) = [self.contentTextView.rac_textSignal
                                   map:^id(NSString *str)  {
                                       if ([str isEqualToString:CMS_TEXTVIEW_PLACEHOLDER]) {
                                           return @"";
                                       }
                                       else {
                                           return str;
                                       }
                                   }];
    RAC(self.viewModel,pName) = self.comlaintPersonName.rac_textSignal;
    RAC(self.viewModel,pNo) = self.complaintPersonNOTextField.rac_textSignal;
    
   [RACObserve(self.viewModel.dataModel0, image) subscribeNext:^(UIImage *image) {
       if(!image) {
           [self.dataButton0 setImage:[UIImage imageNamed:@"ad"] forState:UIControlStateNormal];
       }
       else {
           [self.dataButton0 setImage:image forState:UIControlStateNormal];
       }
   }];
    [RACObserve(self.viewModel.dataModel1, image) subscribeNext:^(UIImage *image) {
        if(!image) {
            [self.dataButton1 setImage:[UIImage imageNamed:@"ad"] forState:UIControlStateNormal];
        }
        else {
            [self.dataButton1 setImage:image forState:UIControlStateNormal];
        }
    }];
    [RACObserve(self.viewModel.dataModel2, image) subscribeNext:^(UIImage *image) {
        if(!image) {
            [self.dataButton2 setImage:[UIImage imageNamed:@"ad"] forState:UIControlStateNormal];
        }
        else {
            [self.dataButton2 setImage:image forState:UIControlStateNormal];
        }
    }];
    

    //获取区域列表...
    [self.viewModel.districtCommand.executing
     subscribeNext:^(NSNumber *executing) {
         @strongify(self)
         if (executing.boolValue) {
             [self.view endEditing:YES];
             [SVProgressHUD showWithStatus:@"获取区域列表..."];
         } else {
             [SVProgressHUD dismiss];
         }
     }];
    //上传zhong...
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
    
    
    [[self.dateButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        
        [self myresignFirstResponder];
        IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"选取时间" delegate:self];
        picker.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [picker setTag:0];
        [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDateTimePicker];
        [picker show];
    }];
    
    [RACObserve(self.viewModel, date) subscribeNext:^(NSString *date) {
        if (date.isExist) {
            [self.dateButton setTitle:date forState:UIControlStateNormal];
        }
    }];
    
    [[self.areaButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self myresignFirstResponder];
        if (self.viewModel.districtArr.count <= 1) {
            [self.viewModel.districtCommand execute:nil];
        }
        else {
            IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"选取社区和街道" delegate:self];
            picker.titlesForComponenets = [self createPickerTitlesForComponents:self.viewModel.districtArr index:0];
            [picker show];
        }
        
    }];
    
    
    
    
    void (^getDataBlock)(UIButton *btn) = ^(UIButton *btn) {
        
        if (self.beforeDataModel.menuType == COMPLAINT_HJWS || self.beforeDataModel.menuType == COMPLAINT_ZYWR || self.beforeDataModel.menuType == COMPLAINT_ZFHF) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                                    delegate:self
                                                           cancelButtonTitle:@"取消"
                                                      destructiveButtonTitle:nil
                                                           otherButtonTitles:@"拍摄照片",@"选取照片",@"录制视频",@"选取视频",@"录制录音",@"选取录音",nil];
            actionSheet.tag = btn.tag;
            [actionSheet.rac_buttonClickedSignal subscribeNext:^(id x) {
                if ([x integerValue] == 6) {
                    return ;
                }
                IQMediaPickerControllerMediaType mediaType;
                if ([x integerValue] == 0) {
                    mediaType = IQMediaPickerControllerMediaTypePhoto;
                } else if ([x integerValue] == 1) {
                    mediaType = IQMediaPickerControllerMediaTypePhotoLibrary;
                } else if ([x integerValue] == 2) {
                    mediaType = IQMediaPickerControllerMediaTypeVideo;
                } else if ([x integerValue] == 3) {
                    mediaType = IQMediaPickerControllerMediaTypeVideoLibrary;
                } else if ([x integerValue] == 4) {
                    mediaType = IQMediaPickerControllerMediaTypeAudio;
                } else if ([x integerValue] == 5) {
                    mediaType = IQMediaPickerControllerMediaTypeAudioLibrary;
                }
                IQMediaPickerController *controller = [[IQMediaPickerController alloc] init];
                
                controller.view.tag = btn.tag;
                controller.delegate = self;
                [controller setMediaType:mediaType];
                [self presentViewController:controller animated:YES completion:nil];
            }];
            [actionSheet showInView:self.view];
        }
        else if (self.beforeDataModel.menuType == COMPLAINT_SRSM || self.beforeDataModel.menuType == COMPLAINT_DZSZ )
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                                    delegate:self
                                                           cancelButtonTitle:@"取消"
                                                      destructiveButtonTitle:nil
                                                           otherButtonTitles:@"拍摄照片",@"选取照片",@"录制视频",@"选取视频",nil];
            actionSheet.tag = btn.tag;
            [actionSheet.rac_buttonClickedSignal subscribeNext:^(id x) {
                if ([x integerValue] == 4) {
                    return ;
                }
                IQMediaPickerControllerMediaType mediaType;
                if ([x integerValue] == 0) {
                    mediaType = IQMediaPickerControllerMediaTypePhoto;
                } else if ([x integerValue] == 1) {
                    mediaType = IQMediaPickerControllerMediaTypePhotoLibrary;
                } else if ([x integerValue] == 2) {
                    mediaType = IQMediaPickerControllerMediaTypeVideo;
                } else if ([x integerValue] == 3) {
                    mediaType = IQMediaPickerControllerMediaTypeVideoLibrary;
                } 
                IQMediaPickerController *controller = [[IQMediaPickerController alloc] init];
                
                controller.view.tag = btn.tag;
                controller.delegate = self;
                [controller setMediaType:mediaType];
                [self presentViewController:controller animated:YES completion:nil];
            }];
            [actionSheet showInView:self.view];
        }
        else {
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
                [self presentViewController:controller animated:YES completion:nil];
            }];
            [actionSheet showInView:self.view];
        }
    };
    
        
    
    [[self.dataButton0 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:getDataBlock];
    [[self.dataButton1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:getDataBlock];
    [[self.dataButton2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:getDataBlock];
    
    [[self.verifyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [[self.viewModel.validComplaintCommand execute:nil] subscribeNext:^(id x) {
            if (x) {
                [[self.viewModel.uploadFileCommand execute:nil] subscribeNext:^(id x) {
                    [self.viewModel.complaintCommand execute:nil];
                }];
            }
        }];
    }];
    
    [[self.viewModel.complaintCommand.executionSignals switchToLatest] subscribeNext:^(CMModel * x) {
        if (x.success) {
            [TSMessage showNotificationInViewController:self.navigationController
                                               subtitle:@"投诉成功"
                                                   type:TSMessageNotificationTypeSuccess];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(),^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - pickerViewDelegate
- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray*)titles
{
    NSMutableString *title = [NSMutableString new];
    for (NSString *str in titles) {
        if (![str isEqualToString:CMS_CHOOSE_AREA]) {
            [title appendString:[NSString stringWithFormat:@"%@  ",str]];
        }
    }
    [self.areaButton setTitle:title forState:UIControlStateNormal];
    self.viewModel.titles = titles;
}
- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectDate:(NSDate*)date
{
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    self.date = [dateFormatter stringFromDate:localeDate];
}
- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didChangeRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        pickerView.titlesForComponenets = [self createPickerTitlesForComponents:self.viewModel.districtArr index:(int)row];
        [pickerView reloadAllComponents];
    }
    
}

- (void)actionSheetPickerViewDidCancel:(IQActionSheetPickerView *)pickerView
{
    
}
- (void)actionSheetPickerViewWillCancel:(IQActionSheetPickerView *)pickerView
{
    
}
#pragma mark - mediaPickerControllerDelegate

- (void)mediaPickerController:(IQMediaPickerController*)controller didFinishMediaWithInfo:(NSDictionary *)info {
    [self handleMediaInfoWith:controller info:info index:controller.view.tag-100];
}

- (void)handleMediaInfoWith:(IQMediaPickerController *)controller info:(NSDictionary *)info index:(NSInteger)index
{
    [self.viewModel setValue:[NSNumber numberWithInteger:controller.mediaType]  forKeyPath:[NSString stringWithFormat:@"dataModel%ld.mediaType",index]];
    switch (controller.mediaType)
    {
        case IQMediaPickerControllerMediaTypePhotoLibrary:
        {
            UIImage *image = info[@"IQMediaTypeImage"][0][@"IQMediaImage"];
            
            [self.viewModel setValue:UIImagePNGRepresentation(image) forKeyPath:[NSString stringWithFormat:@"dataModel%ld.dataFromPhotoLibrary",(long)index]];
            [self.viewModel setValue:MIMETYPE_PNG forKeyPath:[NSString stringWithFormat:@"dataModel%ld.mimeType",index]];
            [self.viewModel setValue:[NSString stringWithFormat:@"name%d.png",0] forKeyPath:[NSString stringWithFormat:@"dataModel%ld.fileName",index]];
            [self.viewModel setValue:image forKeyPath:[NSString stringWithFormat:@"dataModel%ld.image",index]];
        }
            break;
        case IQMediaPickerControllerMediaTypeVideoLibrary:
        {
            NSURL *mediaUrl = info[@"IQMediaTypeVideo"][0][@"IQMediaAssetURL"];
            NSURL *outputURL = [NSURL fileURLWithPath:[ self dataPath:[self fileNameWithCurrentTimeAndFileType:@".mp4"]]];
            [self                   convertMOVToMP4WithInputURL:mediaUrl
                                                      outputURL:outputURL
                      exportAsynchronouslyWithCompletionHandler:^{
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [SVProgressHUD dismiss];
                              [self.viewModel setValue:MIMETYPE_MP4 forKeyPath:[NSString stringWithFormat:@"dataModel%ld.mimeType",index]];
                              [self.viewModel setValue:[NSString stringWithFormat:@"name%ld.mp4",index] forKeyPath:[NSString stringWithFormat:@"dataModel%ld.fileName",index]];
                              [self.viewModel setValue:[self getThumbnailImage:outputURL] forKeyPath:[NSString stringWithFormat:@"dataModel%ld.image",index]];
                              [self.viewModel setValue:outputURL forKeyPath:[NSString stringWithFormat:@"dataModel%ld.filePath",index]];                          });
                          
                      }];
        }
            break;
        case IQMediaPickerControllerMediaTypeAudioLibrary:
        {
            MPMediaItem *item = info[@"IQMediaTypeAudio"][0][@"IQMediaItem"];
            [self mediaItemToData:item index:index exportAsynchronouslyWithCompletionHandler:nil];
        }
            break;
        case IQMediaPickerControllerMediaTypePhoto:
        {
            NSURL *mediaUrl = info[@"IQMediaTypeImage"][0][@"IQMediaURL"];
            NSString *key = [[NSString qiniuKey] stringByAppendingString:@".png"];
            NSString *path = [NSString createDocumentsFileWithFloderName:@"download" fileName:key];
            [[NSFileManager defaultManager] moveItemAtPath:[mediaUrl path] toPath:path error:nil];
            
            NSURL *url = [NSURL fileURLWithPath:path];
            
            [self.viewModel setValue:MIMETYPE_PNG forKeyPath:[NSString stringWithFormat:@"dataModel%ld.mimeType",index]];
            [self.viewModel setValue:[NSString stringWithFormat:@"name%ld.png",index] forKeyPath:[NSString stringWithFormat:@"dataModel%ld.fileName",index]];
            [self.viewModel setValue:info[@"IQMediaTypeImage"][0][@"IQMediaImage"] forKeyPath:[NSString stringWithFormat:@"dataModel%ld.image",index]];
            [self.viewModel setValue:url forKeyPath:[NSString stringWithFormat:@"dataModel%ld.filePath",index]];
        }
            break;
        case IQMediaPickerControllerMediaTypeVideo:
        {
            if ([info allKeys].count == 0) {
                [TSMessage showNotificationInViewController:self.navigationController subtitle:@"录制错误" type:TSMessageNotificationTypeError];
                break;
            }
            NSURL *mediaUrl = info[@"IQMediaTypeVideo"][0][@"IQMediaURL"];
            NSURL *outputURL = [NSURL fileURLWithPath:[ self dataPath:[self fileNameWithCurrentTimeAndFileType:@".mp4"]]];
            [self                   convertMOVToMP4WithInputURL:mediaUrl
                                                      outputURL:outputURL
                      exportAsynchronouslyWithCompletionHandler:^{
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [self.viewModel setValue:MIMETYPE_MP4 forKeyPath:[NSString stringWithFormat:@"dataModel%ld.mimeType",index]];
                              [self.viewModel setValue:[NSString stringWithFormat:@"name%ld.mp4",index] forKeyPath:[NSString stringWithFormat:@"dataModel%ld.fileName",index]];
                              [self.viewModel setValue:[self getThumbnailImage:outputURL] forKeyPath:[NSString stringWithFormat:@"dataModel%ld.image",index]];
                              [self.viewModel setValue:outputURL forKeyPath:[NSString stringWithFormat:@"dataModel%ld.filePath",index]];
                              [SVProgressHUD dismiss];
                          });
                          
                      }];
        }
            break;
        case IQMediaPickerControllerMediaTypeAudio:
        {
            
            
            NSURL *mediaUrl = info[@"IQMediaTypeAudio"][0][@"IQMediaURL"];
            NSString *key = [[NSString qiniuKey] stringByAppendingString:@".m4a"];
            NSString *path = [NSString createDocumentsFileWithFloderName:@"download" fileName:key];
            [[NSFileManager defaultManager] moveItemAtPath:[mediaUrl path] toPath:path error:nil];
            
            NSURL *url = [NSURL fileURLWithPath:path];
            
            [self.viewModel setValue:MIMITYPE_M4A forKeyPath:[NSString stringWithFormat:@"dataModel%ld.mimeType",index]];
            [self.viewModel setValue:[NSString stringWithFormat:@"name%ld.m4a",index] forKeyPath:[NSString stringWithFormat:@"dataModel%ld.fileName",index]];
            [self.viewModel setValue:[UIImage imageNamed:@"Fav_Search_musicHL"] forKeyPath:[NSString stringWithFormat:@"dataModel%ld.image",index]];
            [self.viewModel setValue:url forKeyPath:[NSString stringWithFormat:@"dataModel%ld.filePath",index]];
            break;
        }
        default:
            break;
    }
}

- (void)mediaPickerControllerDidCancel:(IQMediaPickerController *)controller
{
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:CMS_TEXTVIEW_PLACEHOLDER]) {
        textView.text = @"";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = CMS_TEXTVIEW_PLACEHOLDER;
    }
}
/**
 *  把一维的行政区域转成二维的数组，用于选择器的数据源
 *
 *  @param districtArr 一维的行政区域
 *  @param rowIndex    picker的第一列选中的index
 *
 *  @return @[@[第一列titiles],@[第一列选中index时，第二列titles]]
 */

-(NSArray<NSArray *> *)createPickerTitlesForComponents:(NSMutableArray<CMDistrictDataModel *> *)districtArr index:(int)rowIndex {
    NSMutableArray *arrArea = [NSMutableArray new];
    for (int i = 0; i < self.viewModel.districtArr.count; i++) {
        CMDistrictDataModel *dataModel = districtArr[i];
        [arrArea addObject:dataModel.area.name];
    }
    NSMutableArray *arrAddress0 = [NSMutableArray new];
    CMDistrictDataModel *nilModel = [[CMDistrictDataModel alloc] init];
    nilModel.area.code = @"";
    nilModel.area.name = CMS_CHOOSE_AREA;
    [arrAddress0 addObject:nilModel.area.name];
    NSMutableArray *arr = districtArr[rowIndex].addressArr;
    for (int i = 0; i < arr.count; i++) {
        Rows *m = arr[i];
        [arrAddress0 addObject:m.name];
    }
    return @[arrArea,arrAddress0];
}


/**
 *  转换MOV格式到mp4
 *
 *  @param inputURL MOV assert路径
 *
 *  @param outputURL 输出路径
 *
 */
- (void)convertMOVToMP4WithInputURL:(NSURL *)inputURL
                          outputURL:(NSURL *)outputURL
exportAsynchronouslyWithCompletionHandler:(void(^)(void))completionHandler
{
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [[NSFileManager defaultManager] removeItemAtURL:outputURL error:nil];
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    
     NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality])
    {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetPassthrough];
        
        exportSession.outputURL = outputURL;
    
        exportSession.outputFileType = AVFileTypeMPEG4;
        
//        @weakify(self)
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
//            @strongify(self)
           
            
            switch ([exportSession status]) {
//                case AVAssetExportSessionStatusFailed:
//                    NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
//                    
//                    break;
//                    
//                case AVAssetExportSessionStatusCancelled:
//                    
//                    NSLog(@"Export canceled");
//                    
//                    break;
                case AVAssetExportSessionStatusCompleted:
                {
                    dispatch_async(dispatch_get_main_queue(), completionHandler);
                }
                    break;
                default:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                        [SVProgressHUD showErrorWithStatus:@"选取失败"];
                    });
                    
                }
                    break;
            }
        }];
    }
    
}

-(void)mediaItemToData : (MPMediaItem * ) curItem index:(NSInteger )index exportAsynchronouslyWithCompletionHandler:(void(^)(void))completionHandler

{
    [SVProgressHUD showWithStatus:@"请稍候..."];
    NSURL *url = [curItem valueForProperty: MPMediaItemPropertyAssetURL];
    
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL: url options:nil];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset: songAsset
                                                                      presetName:AVAssetExportPresetAppleM4A];
    
    exporter.outputFileType =@"com.apple.m4a-audio";
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * myDocumentsDirectory = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    [[NSDate date] timeIntervalSince1970];
    NSTimeInterval seconds = [[NSDate date] timeIntervalSince1970];
    NSString *intervalSeconds = [NSString stringWithFormat:@"%0.0f",seconds];
    
    NSString * fileName = [NSString stringWithFormat:@"%@.m4a",intervalSeconds];
    
    NSString *exportFile = [myDocumentsDirectory stringByAppendingPathComponent:fileName];
    
    NSURL *exportURL = [NSURL fileURLWithPath:exportFile];
    exporter.outputURL = exportURL;
    
    // do the export
    // (completion handler block omitted)
    [exporter exportAsynchronouslyWithCompletionHandler:
     ^{
         int exportStatus = exporter.status;
         
         switch (exportStatus)
         {
//             case AVAssetExportSessionStatusFailed:
//             {
//                 NSError *exportError = exporter.error;
//                 NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
//                 break;
//             }
             case AVAssetExportSessionStatusCompleted:
             {
//                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), completionHandler);

                 NSLog (@"AVAssetExportSessionStatusCompleted");
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self.viewModel setValue:MIMETYPE_AUDIO forKeyPath:[NSString stringWithFormat:@"dataModel%ld.mimeType",index]];
                     [self.viewModel setValue:[NSString stringWithFormat:@"name%ld.m4a",index] forKeyPath:[NSString stringWithFormat:@"dataModel%ld.fileName",index]];
                     [self.viewModel setValue:[UIImage imageNamed:@"Fav_Search_musicHL"] forKeyPath:[NSString stringWithFormat:@"dataModel%ld.image",index]];
                     [self.viewModel setValue:exportURL forKeyPath:[NSString stringWithFormat:@"dataModel%ld.filePath",index]];
                     [SVProgressHUD dismiss];
                 });
                 break;
             }
//             case AVAssetExportSessionStatusUnknown:
//             {
//                 NSLog (@"AVAssetExportSessionStatusUnknown"); break;
//             }
//             case AVAssetExportSessionStatusExporting:
//             {
//                 NSLog (@"AVAssetExportSessionStatusExporting"); break;
//             }
//             case AVAssetExportSessionStatusCancelled:
//             {
//                 NSLog (@"AVAssetExportSessionStatusCancelled"); break;
//             }
//             case AVAssetExportSessionStatusWaiting:
//             {
//                 NSLog (@"AVAssetExportSessionStatusWaiting"); break;
//             }
             default:
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [SVProgressHUD dismiss];
                     [SVProgressHUD showErrorWithStatus:@"选取失败"];
                });
                 NSLog (@"didn't get export status");
                 break;
             }
         }
     }];
}

- (void) uploadVideo:(CMUploadFileDataModel*)dataModel {
//    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:mediaUrl options:nil];
    [self.viewModel.uploadFileCommand execute:dataModel];
}
/**
 *  获取视频的第一张图片
 *
 *  @param videoURL
 *
 *  @return
 */
- (UIImage *)getThumbnailImage:(NSURL *)videoURL

{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return thumb;
}
/**
 *  创建文件
 *
 *  @param file 文件名
 *
 *  @return 返回路径
 */
- (NSString *)dataPath:(NSString *)file
{
    
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"mp4"];
    BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    NSAssert(bo,@"创建目录失败");
    
    NSString *result = [path stringByAppendingPathComponent:file];
    
    return result;
    
}
- (NSString *)fileNameWithCurrentTimeAndFileType:(NSString *)type {
    [[NSDate date] timeIntervalSince1970];
    NSTimeInterval seconds = [[NSDate date] timeIntervalSince1970];
    NSString *intervalSeconds = [NSString stringWithFormat:@"%0.0f",seconds];
    
    NSString * fileName = [NSString stringWithFormat:@"%@%@",intervalSeconds,type];
    return fileName;
}

-(void)myresignFirstResponder {
    [self.titleTextField resignFirstResponder];
    [self.contentTextView resignFirstResponder];
    [self.areaTextField resignFirstResponder];
    [self.complaintPersonNOTextField resignFirstResponder];
    [self.comlaintPersonName resignFirstResponder];
}


@end
