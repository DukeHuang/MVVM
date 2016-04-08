//
//  CMBaseChildMenuViewModel.m
//  CM
//
//  Created by Duke on 1/19/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMBaseChildMenuViewModel.h"

@implementation CMBaseChildMenuViewModel
-(instancetype)initWithServices:(id<CMViewModelServices>)services params:(NSDictionary *)params{
    self = [super init];
    if (self) {
        self.childMenu = [[NSArray alloc] init];
        self.menuModel = [[CMBaseMenuDataModel alloc] init];
    }
    return self;
}
@end
