//
//  CMPublicInfoTableViewController.h
//  CM
//
//  Created by Duke on 3/8/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPubliceInfoViewModel.h"
#import "CMTableViewController.h"

@interface CMPublicInfoTableViewController : CMTableViewController
@property(nonatomic,strong) CMPubliceInfoViewModel *viewModel;
@end
