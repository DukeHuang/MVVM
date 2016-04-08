//
//  DDBannerViewController.m
//  CM
//
//  Created by Duke on 1/15/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "DDBannerViewController.h"
#import "CHXBannerView.h"
#import "CMHttpManager+PublicInfo.h"
#import "CMPublicInfoMTLModel.h"
#import "CMUserDefault.h"
#import "CMPublicInfoTableViewController.h"
#import "CMPublicInfoDetailViewController.h"

@interface DDBannerViewController () <UIScrollViewDelegate,CHXBannerViewDataSource,CHXBannerViewDelegate>
{
    __weak IBOutlet UIView *_rightView;
}

@property (weak, nonatomic) IBOutlet CHXBannerView *bannerView;
@property (nonatomic,strong)RACCommand *getPublicInfoCommand;

@end

@implementation DDBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _urls = [[NSMutableArray alloc] init];
    
    self.bannerView.delegate = self;
    self.bannerView.dataSource = self;
    self.bannerView.pageControl.currentPageIndicatorTintColor = CM_COLOR_NAV;
    self.bannerView.pageControl.pageIndicatorTintColor = [UIColor whiteColor];

    self.urls = [CMUserDefault sharedInstance].urls;
    
    [self.bannerView reloadData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
}

#pragma mark - CHXBannerViewDataSource

- (NSInteger)numberOfPagesInBannerView:(CHXBannerView *)bannerView {
    return self.urls.count;
}

- (void)bannerView:(CHXBannerView *)bannerView presentImageView:(UIImageView *)imageView forIndex:(NSInteger)index {
    if (self.urls.count == 0) {
        return;
    }
    for (UIView *view in [imageView subviews]) {
        [view removeFromSuperview];
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, imageView.frame.size.width-20    , imageView.frame.size.height-20)];
    PublicInfo_Rows *publicInfo = self.urls[index];
    label.font = [UIFont systemFontOfSize:12.0];
    label.numberOfLines = 0;
    label.text = publicInfo.title;
    [imageView addSubview:label];
}

- (NSTimeInterval)timeIntervalOfTransitionsAnimationInBannerView:(CHXBannerView *)bannerView {
    return 5;
}

#pragma mark - CHXBannerViewDelegate

- (void)bannerView:(CHXBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"didSelectItemAtIndex: %@", @(index));
    PublicInfo_Rows *punish = self.urls[index];
    CMPublicInfoDetailViewController *vc = [MainStoryboard instantiateViewControllerWithIdentifier:@"iCMPublicInfoDetailViewController"];
    vc.title = punish.title;
    vc.contentHtmlString = punish.content;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnPressed:(id)sender {
    CMPublicInfoTableViewController *vc = [MainStoryboard instantiateViewControllerWithIdentifier:@"iCMPublicInfoTableViewController" ];
    vc.viewModel.categoryCode = @"06";
    vc.viewModel.type = @"0";
    vc.viewModel.title = @"资讯";
    [self.navigationController pushViewController:vc animated:YES];
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
