//
//  CMComplaintDetailTableViewController.m
//  CM
//
//  Created by Duke on 3/7/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMComplaintDetailTableViewController.h"
#import "CMHttpSessionManager+File.h"
#import "CMPopWebViewController.h"
#import "CMImageViewController.h"
#import "CMHttpManager+Compliant.h"
@import MediaPlayer;
@import AVFoundation;

@interface CMComplaintDetailTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (weak, nonatomic) IBOutlet UIImageView *statusProgressImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *complaintedPeopleLabel;
@property (weak, nonatomic) IBOutlet UILabel *complaintedPeopleNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLable;
@property (weak, nonatomic) IBOutlet UIButton *mat0;
@property (weak, nonatomic) IBOutlet UIButton *mat1;
@property (weak, nonatomic) IBOutlet UIButton *mat2;
@property (weak, nonatomic) IBOutlet UITableViewCell *complaintPersonCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *complaintPersonNoCell;


@property (nonatomic,copy) NSString *matPath0;
@property (nonatomic,copy) NSString *matPath1;
@property (nonatomic,copy) NSString *matPath2;

@property(nonatomic,strong)RACCommand *downLoadFileCommand;
@property(nonatomic,strong)RACCommand *getComplaintCommand;

@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation CMComplaintDetailTableViewController
@dynamic tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    self.downLoadFileCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *qiniuKey) {
        NSString *savePath = [NSString createDocumentsFileWithFloderName:@"download" fileName:@""];
        
        return [[CMHttpSessionManager sharedClient] downloadFileURL:qiniuKey savePath:savePath fileName:qiniuKey];
    }];
    [self.downLoadFileCommand.executing
     subscribeNext:^(NSNumber *executing) {
         if (executing.boolValue) {
             [SVProgressHUD showWithStatus:@"下载中..."];
         } else {
             [SVProgressHUD dismiss];
         }
     }];
    
    self.getComplaintCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSString *complaintId = [NSString stringWithFormat:@"%ld",self.progress.row_id];
        return [[CMHttpManager sharedClient] getComplaintDetailWithAccessToken:[SSKeychain accessToken] complaintId:complaintId];
    }];
    
    [self.getComplaintCommand.executing
     subscribeNext:^(NSNumber *executing) {
         if (executing.boolValue) {
             [SVProgressHUD showWithStatus:@"请稍候..."];
         } else {
             [SVProgressHUD dismiss];
         }
     }];
    [self.getComplaintCommand execute:nil];
    
//   self.downLoadFileCommand.executing

    self.title = @"投诉详情";
    NSString *statusImageName;
    NSString *statusProgressName;
//    0等待受理；1投诉未接收；2投诉已接收；3正在处理；4处理完毕
    switch ([self.progress.status intValue]) {
        case 0:
        case 1:
        case 2:
            statusImageName = @"st1";
            break;
        
        case 3:
            statusImageName = @"st2";
            break;
        case 4:
            statusImageName = @"st3";
            break;
    }
    
    switch ([self.progress.status intValue]) {
        case 0:
            statusProgressName = @"wait";
            break;
        case 1:
            statusProgressName = @"not";
            break;
        case 2:
        case 3:
            statusProgressName = @"now";
            break;
        case 4:
            statusProgressName = @"done";
            break;
        default:
            break;
    }
    self.statusImageView.image = [UIImage imageNamed:statusImageName];
    self.statusProgressImageView.image = [UIImage imageNamed:statusProgressName];
    self.contentLabel.text = self.progress.content;
    self.titleLabel.text = self.progress.title;
    NSDictionary *dic = @{
                          @"01":@"绿化园林",
                          @"02":@"环境卫生",
                          @"03":@"噪音污染",
                          @"04":@"违法建筑",
                          @"05":@"市容市貌",
                          @"06":@"政风行风",
                          @"07":@"商招店招",
                          };

    NSString *str = [dic objectForKey:[self.progress.categoryCode substringToIndex:2 ]];
    if ([[self.progress.categoryCode substringToIndex:2 ] isEqualToString:@"06"]) {
        self.complaintPersonCell.hidden = NO;
        self.complaintPersonNoCell.hidden = NO;
        self.complaintedPeopleLabel.text = self.progress.pName;
        self.complaintedPeopleNoLabel.text = self.progress.pNo;
    } else {
        self.complaintPersonCell.hidden = YES;
        self.complaintPersonNoCell.hidden = YES;
    }
    self.iconImageView.image = [UIImage imageNamed:str];
    self.dateLable.text = self.progress.date;
    self.nameLabel.text = [str stringByAppendingString:@"投诉"];
    
    //配置3个材料按钮
    
    for (int i = 0; i < 3; i++) {
        UIButton *matButton = [self valueForKey:[NSString stringWithFormat:@"mat%d",i]];
        matButton.hidden = YES;
        matButton.layer.borderWidth = 1.0;
        matButton.layer.borderColor = [[UIColor grayColor] CGColor];
        [matButton setCornerRadius];
    }
    
    for (int i = 0; i < self.progress.mat.count; i++)  {
        
        Mat *mat = self.progress.mat[i];
        NSArray *arr = [mat.matType componentsSeparatedByString:@"/"];
        
        NSString *type;
        if (arr.count >= 2) {
            type = arr[1];
        } else {
            type =  mat.matType;
        }
        
        NSString *buttonImageName = @"";
        UIImage *image;
        NSString *qiniuKey = mat.matPath;
        NSString *path = [NSString createDocumentsFileWithFloderName:@"download" fileName:qiniuKey];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([type isEqualToString:@"mp3"] || [type isEqualToString:@"m4a"] ) {
            buttonImageName = @"record";
            image = [UIImage imageNamed:buttonImageName];
            }
        else if ([type isEqualToString:@"mp4"]  ) {
            
            if ([fileManager fileExistsAtPath:path]) {
                image = [self getThumbnailImage:[NSURL fileURLWithPath:path]];
            }
            else {
                buttonImageName = @"video";
                image = [UIImage imageNamed:buttonImageName];
                
            }
        }
        else if ([type isEqualToString:@"png"] ||[type isEqualToString:@"jpg"] || [type isEqualToString:@"jpeg"] ) {
            if ([fileManager fileExistsAtPath:path]) {
                image =  [UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
            }
            else {
                buttonImageName = @"imageLoading";
                image = [UIImage imageNamed:buttonImageName];
                
            }
            
        }
        else   {
            buttonImageName = @"imageLoading";
            image = [UIImage imageNamed:buttonImageName];
        }
        UIButton *matButton = [self valueForKey:[NSString stringWithFormat:@"mat%d",i]];
        [matButton setBackgroundImage:image forState:UIControlStateNormal];
        matButton.hidden = NO;
        
        
        
        [[matButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            //检查本地文件是否已存在
            if ([fileManager fileExistsAtPath:path]) {
                [self openMediaWithKey:qiniuKey filePath:path];
            }
            else {
                [[self.downLoadFileCommand execute:qiniuKey] subscribeNext:^(id x) {
//                    [self.tableView reloadData];
                    NSString *buttonImageName;
                    UIImage *image;
                    if ([type isEqualToString:@"mp3"] || [type isEqualToString:@"m4a"] ) {
                        buttonImageName = @"record";
                        image = [UIImage imageNamed:buttonImageName];
                    }
                    else if ([type isEqualToString:@"mp4"]  ) {
                        
                        if ([fileManager fileExistsAtPath:path]) {
                            image = [self getThumbnailImage:[NSURL fileURLWithPath:path]];
                        }
                        else {
                            buttonImageName = @"video";
                            image = [UIImage imageNamed:buttonImageName];
                            
                        }
                    }
                    else if ([type isEqualToString:@"png"] ||[type isEqualToString:@"jpg"] || [type isEqualToString:@"jpeg"] ) {
                        if ([fileManager fileExistsAtPath:path]) {
                            image =  [UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
                        }
                        else {
                            buttonImageName = @"imageLoading";
                            image = [UIImage imageNamed:buttonImageName];
                            
                        }
                        
                    }
                    else   {
                        buttonImageName = @"imageLoading";
                        image = [UIImage imageNamed:buttonImageName];
                    }
                    UIButton *matButton = [self valueForKey:[NSString stringWithFormat:@"mat%d",i]];
                    [matButton setBackgroundImage:image forState:UIControlStateNormal];
                    [self openMediaWithKey:qiniuKey filePath:path];
                }];
            }
        }];
    }
    
    if ([self.progress.rejectContent isExist]) {
        self.reasonLable.text = [NSString stringWithFormat:@"拒绝原因:%@",self.progress.rejectContent];
    }
    else if ([self.progress.feedbackContent isExist]){
        self.reasonLable.text = [NSString stringWithFormat:@"反馈内容:%@",self.progress.feedbackContent];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)openMediaWithKey:(NSString *)qiniuKey filePath:(NSString *)path {
    NSArray *arr = [qiniuKey componentsSeparatedByString:@"."];
    
    NSString *type;
    if (arr.count >= 2) {
        type = arr[1];
    } else {
        type =  @"";
    }
    
    if ([type isEqualToString:@"mp3"] || [type isEqualToString:@"m4a"] ||[type isEqualToString:@"mp4"]) {
        NSURL *URL = [[NSURL alloc] initFileURLWithPath:path];
        MPMoviePlayerViewController *_moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:URL];
        [self presentMoviePlayerViewControllerAnimated:_moviePlayerController];
        _moviePlayerController.moviePlayer.movieSourceType=MPMovieSourceTypeFile;
        [_moviePlayerController.moviePlayer play];
    }
    else if ([type isEqualToString:@"png"] ||[type isEqualToString:@"jpg"] || [type isEqualToString:@"jpeg"] ) {
        
        CMImageViewController *imageVC = [[CMImageViewController alloc] init];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
        [self presentViewController:imageVC animated:YES completion:nil];
        imageVC.imageView.image = image;
        [[imageVC.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];

//        CMPopWebViewController *vc = [[CMPopWebViewController alloc] init];
//        [self presentViewController:vc animated:YES completion:nil];
//        NSURL *fileURL = [NSURL fileURLWithPath:path];
//        NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
//        [vc.webView loadRequest:request];
//        vc.webView.scalesPageToFit = YES;
//        [[vc.doneButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }];
//        [vc.doneButton setTitle:@"确定" forState:UIControlStateNormal];
//        [[vc.canelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }];
    }
    else {
        [TSMessage showNotificationInViewController:self.navigationController subtitle:@"无法查看该类型的文件" type:TSMessageNotificationTypeError];
    }
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}


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
//                          @"0101":@"绿化园林",
//                          @"0102":@"环境卫生",
//                          @"0201":@"噪音污染",
//                          @"0202":@"违法建筑",
//                          @"0203":@"市容市貌",
//                          @"0204":@"政风行风",
//                          @"0205":@"商招店招",
//                          @"0206":@"绿化园林",
//                          @"0301":@"环境卫生",
//                          @"0302":@"噪音污染",
//                          @"0501":@"违法建筑",
//                          @"0502":@"市容市貌",
//                          @"0503":@"政风行风",
//                          @"0504":@"商招店招",

@end
