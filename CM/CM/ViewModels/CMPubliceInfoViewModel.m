//
//  CMPubliceInfoViewModel.m
//  CM
//
//  Created by Duke on 3/8/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMPubliceInfoViewModel.h"
#import "CMHttpManager+PublicInfo.h"
#import "CMHttpManager+SelfCenter.h"

@implementation CMPubliceInfoViewModel
- (void)initialize {
    [super initialize];
    self.dataSouceArr = [[NSMutableArray alloc] init];
//    self.title = self.menuModel.name;
    [self.requestRemoteDataCommand.errors subscribe:self.errors];
}
- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    if ([self.type isEqualToString:@"0"]) {
        return [[CMHttpManager sharedClient]
                getPublicInfoWithCategoryCode:self.categoryCode
                offset:(int)(self.limit * (page - 1))
                limit:(int)self.limit];
    }
    else  {
        return [[CMHttpManager sharedClient] getMessageWithAccessToken:[SSKeychain accessToken]
                                                                offset:(int)(self.limit *(page -1))
                                                                 limit:(int)self.limit];
    }
    
    
}
@end
