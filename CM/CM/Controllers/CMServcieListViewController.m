//
//  CMServcieListViewController.m
//  CM
//
//  Created by Duke on 2/19/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMServcieListViewController.h"
#import "CMServiceTableViewCell.h"
#import "CMServiceMTLModel.h"
@import MapKit;

@interface CMServcieListViewController ()

@property (weak, nonatomic,readwrite) IBOutlet UITableView *tableView;

@end

@implementation CMServcieListViewController
@dynamic viewModel;
@dynamic tableView;

- (void)awakeFromNib {
    self.viewModel = [[CMServiceViewModel alloc] initWithServices:nil params:nil];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self findCurrentLocation];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)bindViewModel {
    
    self.viewModel.limit = 30;
    self.viewModel.offset = 0;
    self.viewModel.categoryCode = self.beforeDataModel.categoryCode;
    self.viewModel.shouldInfiniteScrolling = YES;
    self.viewModel.shouldPullToRefresh = YES;
    
    [super bindViewModel];
     [RACObserve(self.viewModel,currentLocation) subscribeNext:^(CLLocation *x) {
         if (x) {
             self.viewModel.latitude = x.coordinate.latitude;
             self.viewModel.longtitude = x.coordinate.longitude;
             [self.viewModel.requestRemoteDataCommand execute:@1];
         }
     }];

    [[RACObserve(self.viewModel,dataSouceArr) deliverOnMainThread] subscribeNext:^(id x) {
        [self.tableView reloadData];
    }];
    [[self.viewModel.requestRemoteDataCommand.executionSignals switchToLatest] subscribeNext:^(CMServiceMTLModel *model) {
        if (self.viewModel.page == 1) {
            self.viewModel.dataSouceArr = [[NSMutableArray alloc] init];
        }
        if (model.rows.count > 0) {
            self.tableView.showsInfiniteScrolling = YES;
            [self.viewModel.dataSouceArr addObjectsFromArray:model.rows];
            self.viewModel.dataSouceArr = self.viewModel.dataSouceArr;
        }
        else {
            self.tableView.showsInfiniteScrolling = NO;
        }
    }];
    [self.viewModel.requestRemoteDataCommand.executing
     subscribeNext:^(NSNumber *executing) {
//         @strongify(self)
         if (executing.boolValue) {
//             [self.view endEditing:YES];
             [SVProgressHUD showWithStatus:@"请稍候..."];
         } else {
             [SVProgressHUD dismiss];
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)findCurrentLocation {
    self.isFirstUpdate = YES;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
}

#pragma mark- CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if (self.isFirstUpdate) {
        self.isFirstUpdate = NO;
        return;
    }
    CLLocation *location = [locations lastObject];
    
    if (location.horizontalAccuracy > 0) {
        self.viewModel.currentLocation = location;
        [self.locationManager stopUpdatingLocation];
    }
    // 获取当前所在的城市名
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
//    [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *array, NSError *error)
//     {
//         if (array.count > 0)
//         {
//             CLPlacemark *placemark = [array objectAtIndex:0];
//             //             NSLog(@"%@",placemark.name);
//             //             NSString *province =  placemark.administrativeArea;
//             NSString *city = placemark.locality;
//             if (!city) {
//                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
//                 city = placemark.administrativeArea;
//             }
//             self.cityName = city;
//         }
//         
//         else if (error == nil && [array count] == 0)
//         {
//             NSLog(@"No results were returned.");
//         }
//         
//         else if (error != nil)
//         {
//             NSLog(@"An error occurred = %@", error);
//         }
//     }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSouceArr.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Rows_Service *service = self.viewModel.dataSouceArr[indexPath.row];
    CMServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iCMServiceTableViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = service.name;
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.1fkm",service.distance];
    cell.detailTitleLable.text = service.addr;
//    01：
//    0接收；1收运
//    02：
//    0免费；1收费
//    03：
//    0执勤；1开放
//    04：
//    0开放；1关闭
    
    NSString *statusString;
    UIColor *statusColor;
    if ([service.status isEqualToString:@"0"]) {
        if([self.viewModel.categoryCode isEqualToString:@"0101"]) {
            statusString = @"接收";
        }
        if([self.viewModel.categoryCode isEqualToString:@"02"]) {
            statusString = @"免费";
        }
        if([self.viewModel.categoryCode isEqualToString:@"03"]) {
            statusString = @"执勤";
        }
        if([self.viewModel.categoryCode isEqualToString:@"04"]) {
            statusString = @"开放";
        }
        statusColor = [UIColor greenColor];
    }
    if ([service.status isEqualToString:@"1"]) {
        if([self.viewModel.categoryCode isEqualToString:@"0101"]) {
            statusString = @"收运";
        }
        if([self.viewModel.categoryCode isEqualToString:@"02"]) {
            statusString = @"收费";
        }
        if([self.viewModel.categoryCode isEqualToString:@"03"]) {
            statusString = @"开放";
        }
        if([self.viewModel.categoryCode isEqualToString:@"04"]) {
            statusString = @"关闭";
        }
        statusColor = [UIColor redColor];
    }
    cell.statusLabel.text = statusString;
    cell.statusLabel.backgroundColor = statusColor;
    [cell.statusLabel setCornerRadius];
    
    if ([self.viewModel.categoryCode isEqualToString:@"03"]) {
        cell.constraintHeight.constant = 20.0f;
        [cell.phoneButton1 setTitle:[NSString stringWithFormat:@"城管中队电话：%@",service.tel1] forState:UIControlStateNormal];
        [cell.phoneButton2 setTitle:[NSString stringWithFormat:@"城管科电话：%@",service.tel2] forState:UIControlStateNormal];
        
        [[[cell.phoneButton1 rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否拨打该号码" message:service.tel1 delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert.rac_buttonClickedSignal subscribeNext:^(id x) {
                if ([x integerValue] == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",service.tel1]]];
                }
            }];
            [alert show];
            
        }];
        [[[cell.phoneButton2 rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否拨打该号码" message:service.tel2 delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert.rac_buttonClickedSignal subscribeNext:^(id x) {
                if ([x integerValue] == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",service.tel2]]];
                }
            }];
            [alert show];
            
        }];
    }
    else if  ([self.viewModel.categoryCode isEqualToString:@"0101"]) {
        cell.constraintHeight.constant = 20.0f;
        [cell.phoneButton1 setTitle:[NSString stringWithFormat:@"街道城管电话：%@",service.tel1] forState:UIControlStateNormal];
        [cell.phoneButton2 setTitle:[NSString stringWithFormat:@"城管园林局环卫科电话：%@",service.tel2] forState:UIControlStateNormal];
        
        [[[cell.phoneButton1 rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否拨打该号码" message:service.tel1 delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert.rac_buttonClickedSignal subscribeNext:^(id x) {
                if ([x integerValue] == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",service.tel1]]];
                }
            }];
            [alert show];
            
        }];
        [[[cell.phoneButton2 rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否拨打该号码" message:service.tel2 delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert.rac_buttonClickedSignal subscribeNext:^(id x) {
                if ([x integerValue] == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",service.tel2]]];
                }
            }];
            [alert show];
            
        }];
    }

    else {
        cell.phoneButton1.hidden = YES;
        cell.phoneButton2.hidden = YES;
    }
    
    [[[cell.goThereButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x)
    {
        //获取当前位置
//        MKMapItem *mylocation = [MKMapItem mapItemForCurrentLocation];
        //当前经维度
//        float currentLatitude=mylocation.placemark.location.coordinate.latitude;
//        float currentLongitude=mylocation.placemark.location.coordinate.longitude;
        
//        CLLocationCoordinate2D coords1 = CLLocationCoordinate2DMake(currentLatitude,currentLongitude);
        
        //目的地位置
        CLLocationCoordinate2D coordinate;
        coordinate.latitude=service.lat;
        coordinate.longitude=service.lng;
        
        
        CLLocationCoordinate2D coords2 = coordinate;
        //当前的位置
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        //起点
        //MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords1 addressDictionary:nil]];
        //目的地的位置
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords2 addressDictionary:nil]];
        
        toLocation.name = service.name;
        NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
        NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
        //打开苹果自身地图应用，并呈现特定的item
        [MKMapItem openMapsWithItems:items launchOptions:options];
    }];
    return cell;
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 100;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 100;
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
