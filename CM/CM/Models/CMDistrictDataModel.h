//
//  CMDistrictDataModel.h
//  CM
//
//  Created by Duke on 1/20/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMDistrictMTLModel.h"

@interface CMDistrictDataModel : NSObject

@property(nonatomic,strong)Rows *area;
@property(nonatomic,strong)NSMutableArray<Rows *> *addressArr;

@end
