//
//  CMBaseMenuViewController.m
//  CM
//
//  Created by Duke on 1/8/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMBaseMenuViewController.h"
#import "CMBaseMenuViewModel.h"
#import "CMBaseMenuCollectionViewCell.h"
#import "DDBannerViewController.h"
#define inset 0.0
#define scale 3.0
#import "CMHttpSessionManager+File.h"
#import "CMBaseChildMenuViewController.h"
#import "CMComplaintViewController.h"
#import "CMPopViewController.h"
#import "CMServcieListViewController.h"
#import "CMProgresstTableViewController.h"

@interface CMBaseMenuViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property(nonatomic,weak,readwrite) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerHeight;

//@property(nonatomic,strong,readwrite) CMBaseMenuViewModel *viewModel;

@end

@implementation CMBaseMenuViewController
@dynamic collectionView;
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
//    self.edgesForExtendedLayout = UIRectEdgeNone
    self.bannerHeight.constant = (SCREEN_WIDTH-inset * (scale+1))/scale;
    DDBannerViewController *vc = [[DDBannerViewController alloc] init];
    vc.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.bannerView setNeedsLayout];
    [self.bannerView layoutIfNeeded];
    
    [vc.view setFrame:self.bannerView.frame];
    [self addChildViewController:vc];
    
    [self.bannerView addSubview:vc.view];
    
    [vc.view setNeedsLayout];
    [vc.view layoutIfNeeded];
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menubg"]];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSouce
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.menusArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CMBaseMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"iBaseMenuCollectionCell" forIndexPath:indexPath];
    CMBaseMenuDataModel *model = self.viewModel.menusArray[indexPath.row];
    NSString *name = model.name;
    [cell.name setText:name];
    cell.logo.image = [UIImage imageNamed:model.iconName];
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = CM_COLOR_GRAY;
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
//    cell.layer.borderColor = [[UIColor whiteColor] CGColor];
//    cell.layer.borderWidth = 3.0;
    return cell;
}

#pragma mark- UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CMBaseMenuDataModel *model = self.viewModel.menusArray[indexPath.row];
    if ([model.categoryCode isExist]) {
        if ([SSKeychain accessToken].isExist) {
            
            if (((model.menuType >= 10 && model.menuType < 30) || (model.menuType >= 40 && model.menuType <50) ) &&![[SSKeychain user].verifyStatus isEqualToString:@"1"]){
                [TSMessage showNotificationInViewController:self.navigationController subtitle:@"账号未通过审核，不允许该操作" type:TSMessageNotificationTypeError];
                return;
            }
            if (model.menuType == COMPLAINT_DZSZ || model.menuType == COMPLAINT_ZFHF) {
                CMPopViewController *vc = [[CMPopViewController alloc] init];
                [self.view addSubview:vc.view];
                vc.title = model.name;
                vc.leftLabel.text = @"受理范围提示:";
                vc.contentLabel.text = model.tipsStr;
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
                    CMComplaintViewController *complaintVC = [MainStoryboard instantiateViewControllerWithIdentifier:@"iCMComplaintViewController"];
                    complaintVC.viewModel.categoryCode = model.categoryCode;
                    complaintVC.viewModel.title = model.name;
                    complaintVC.beforeDataModel = model;
                    [self.navigationController pushViewController:complaintVC animated:YES];
                }];
                
            }
            
            //投诉进度
            else if (model.menuType == COMPLAINT_JDCX || model.menuType == PUNISH_PROGRESS || model.menuType == CER_JDCX) {
                CMProgresstTableViewController *progressVC = [MainStoryboard instantiateViewControllerWithIdentifier:@"iCMProgressTableViewController"];
                progressVC.viewModel.menuModel = model;
                progressVC.viewModel.title = model.name;
                [self.navigationController pushViewController:progressVC animated:YES];
            }
//            SER_GONGCE = 30,//公厕查找
//            SER_OTHERS = 31,//其他公共服务
//            SER_CHENGGUANG = 32,//城管便民服务
//            SER_LAJI = 33
            else if (model.menuType == SER_GONGCE || model.menuType == SER_OTHERS || model.menuType == SER_CHENGGUANG) {
                CMServcieListViewController *serviceVC = [MainStoryboard instantiateViewControllerWithIdentifier:@"iCMServcieListViewController"];
                serviceVC.viewModel.title = model.name;
                serviceVC.beforeDataModel = model;
                [self.navigationController pushViewController:serviceVC animated:YES];
            }
            else {
                CMBaseChildMenuViewController *vc = [MainStoryboard instantiateViewControllerWithIdentifier:@"iCMBaseChildMenuViewController"];
                vc.viewModel.childMenu = [model.childMenu copy];
                vc.viewModel.menuModel = model;
                vc.viewModel.title = model.name;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        } else {
            UINavigationController *loginNav = [LoginRegisterStoryboard instantiateViewControllerWithIdentifier:@"iLoginNavigationController"];
            [self.navigationController presentViewController:loginNav animated:YES completion:nil];
        }
    }
    
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


#pragma mark- UICollecitonViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat x = floorf((SCREEN_WIDTH-inset * (scale+1))/scale);
    
    if ((indexPath.row+1) % 3 == 0) {
        return CGSizeMake(SCREEN_WIDTH - 2*x, x);
    }
    else {
        return CGSizeMake(x, x);
    }
}
//一组section的上左下右
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(inset, inset, inset, inset);
}
//最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return inset;
}
//最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return inset;
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
