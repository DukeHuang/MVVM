//
//  CMBaseMenuViewModel.h
//  CM
//
//  Created by Duke on 1/15/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMViewModel.h"
#import "CMBaseMenuDataModel.h"

@interface CMBaseMenuViewModel : CMViewModel

@property(nonatomic,strong) NSArray<CMBaseMenuDataModel *> *menusArray;


@end
