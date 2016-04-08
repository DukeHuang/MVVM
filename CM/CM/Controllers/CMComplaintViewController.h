//
//  CMComplaintViewController.h
//  CM
//
//  Created by Duke on 1/19/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMViewController.h"
#import "CMComplaintViewModel.h"
#import "CMBaseMenuDataModel.h"

@interface CMComplaintViewController : CMViewController


@property(nonatomic,strong,readonly)CMComplaintViewModel *viewModel;

@property(nonatomic,strong)CMBaseMenuDataModel *dataModel;
@property(nonatomic,strong)CMBaseMenuDataModel *beforeDataModel;


@end
