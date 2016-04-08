//
//  CMBaseChildMenuViewController.h
//  CM
//
//  Created by Duke on 1/8/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMTableViewController.h"
#import "CMBaseChildMenuViewModel.h"

@interface CMBaseChildMenuViewController : CMTableViewController

@property(nonatomic,strong,readonly) CMBaseChildMenuViewModel *viewModel;

@end
