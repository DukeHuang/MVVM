//
//  CMServiceViewModel.m
//  CM
//
//  Created by Duke on 2/19/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMServiceViewModel.h"
#import "CMHttpManager+Service.h"

@implementation CMServiceViewModel

- (void)initialize {
    [super initialize];
    self.dataSouceArr = [[NSMutableArray alloc] init];
//    self.getServiceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *tuple) {
//        RACTupleUnpack(NSString *code,NSNumber *offset,NSNumber *limit,NSNumber *longtitude,NSNumber *latitude) = tuple;
//        return [[CMHttpManager sharedClient]
//                getConvenienceWithCategoryCode:code
//                offset:[offset intValue]
//                limit:[limit intValue]
//                lng:[longtitude floatValue]
//                lat:[latitude floatValue]];
//    }];
    
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    return [[CMHttpManager sharedClient]
            getConvenienceWithCategoryCode:self.categoryCode
            offset:(int)(self.limit  * (page - 1))
            limit:(int)self.limit
            lng:self.longtitude
            lat:self.latitude];
}

@end
