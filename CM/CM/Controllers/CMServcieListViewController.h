//
//  CMServcieListViewController.h
//  CM
//
//  Created by Duke on 2/19/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMTableViewController.h"
#import "CMServiceViewModel.h"
#import "CMBaseMenuDataModel.h"
@import CoreLocation;

@interface CMServcieListViewController :CMTableViewController <CLLocationManagerDelegate>

@property(nonatomic,strong) CMServiceViewModel *viewModel;
//@property(nonatomic,strong,readwrite) CLLocation *currentLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL isFirstUpdate;
@property(nonatomic,strong)CMBaseMenuDataModel *beforeDataModel;

@end
