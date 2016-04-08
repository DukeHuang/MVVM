//
//  CMProgressViewModel.m
//  CM
//
//  Created by Duke on 3/6/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMProgressViewModel.h"
#import "CMHttpManager+Compliant.h"


@implementation CMProgressViewModel
- (void)initialize {
    [super initialize];
    self.dataSouceArr = [[NSMutableArray alloc] init];
    RAC(self,title) = RACObserve(self.menuModel, name);
    [self.requestRemoteDataCommand.errors subscribe:self.errors];
}
- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    
    if (self.menuModel.menuType == COMPLAINT_JDCX) {
        return [[CMHttpManager sharedClient]
                getComplaintWithAccessToken:[SSKeychain accessToken]
                offset:(int)(self.limit * (page - 1))
                limit:(int)self.limit
                categoryCode:@""];
    }
    else if (self.menuModel.menuType ==PUNISH_PROGRESS ) {
        return [[CMHttpManager sharedClient]
                getPenaltyWithAccessToken:[SSKeychain accessToken]
                offset:(int)(self.limit * (page - 1))
                limit:(int)self.limit];
    }
    else if (self.menuModel.menuType ==CER_JDCX ) {
        return [[CMHttpManager sharedClient]
                getCerWithAccessToken:[SSKeychain accessToken]
                offset:(int)(self.limit * (page - 1))
                limit:(int)self.limit];
    }
    else {
        return nil;
    }
    
}
@end
