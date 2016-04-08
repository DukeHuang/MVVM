//
//  CMProgresstTableViewController.h
//  CM
//
//  Created by Duke on 3/6/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMTableViewController.h"
#import "CMServiceViewModel.h"
#import "CMProgressViewModel.h"
#import "CMBaseMenuDataModel.h"

@interface CMProgresstTableViewController : CMTableViewController 

@property(nonatomic,strong) CMProgressViewModel *viewModel;
@property (nonatomic, assign) BOOL isFirstUpdate;

@property(nonatomic,strong)CMBaseMenuDataModel *beforeDataModel;

@end
