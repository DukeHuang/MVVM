//
//  CMBaseChildMenuViewModel.h
//  CM
//
//  Created by Duke on 1/19/16.
//  Copyright © 2016 DU. All rights reserved.
//


#import "CMBaseMenuDataModel.h"
#import "CMTableViewModel.h"

@interface CMBaseChildMenuViewModel : CMTableViewModel

@property(nonatomic,strong) CMBaseMenuDataModel *menuModel;
@property(nonatomic,strong) NSArray<CMBaseMenuDataModel*> *childMenu;

@end
