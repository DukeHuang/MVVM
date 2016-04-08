//
//  CMDistrictDataModel.m
//  CM
//
//  Created by Duke on 1/20/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMDistrictDataModel.h"

@implementation CMDistrictDataModel

- (instancetype) init {
    if (self = [super init]) {
        self.area = [[Rows alloc] init];
        self.addressArr = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
