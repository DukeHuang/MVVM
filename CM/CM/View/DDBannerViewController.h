//
//  DDBannerViewController.h
//  CM
//
//  Created by Duke on 1/15/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPublicInfoMTLModel.h"

@interface DDBannerViewController : UIViewController

@property(nonatomic,strong)NSMutableArray<PublicInfo_Rows*> *urls;

@end
