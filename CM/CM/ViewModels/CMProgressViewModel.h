//
//  CMProgressViewModel.h
//  CM
//
//  Created by Duke on 3/6/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMTableViewModel.h"
#import "CMBaseMenuDataModel.h"

@interface CMProgressViewModel : CMTableViewModel
@property(nonatomic,strong) CMBaseMenuDataModel *menuModel;
@property(nonatomic,strong) NSMutableArray *dataSouceArr;
@property(nonatomic,assign) NSInteger offset;
@property(nonatomic,assign) NSInteger limit;
@end
