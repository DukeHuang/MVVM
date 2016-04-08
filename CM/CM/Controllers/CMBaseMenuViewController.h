//
//  CMBaseMenuViewController.h
//  CM
//
//  Created by Duke on 1/8/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMCollectionViewController.h"
#import "CMBaseMenuViewModel.h"

@interface CMBaseMenuViewController : CMCollectionViewController
@property(nonatomic,strong) CMBaseMenuViewModel *viewModel;
@end
