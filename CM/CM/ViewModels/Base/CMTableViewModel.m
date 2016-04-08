//
//  CMTableViewModel.m
//  CM
//
//  Created by Duke on 1/14/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMTableViewModel.h"
@interface CMTableViewModel()

//@property (nonatomic, strong, readwrite) RACCommand *requestRemoteDataCommand;

@end


@implementation CMTableViewModel

- (void)initialize {
    [super initialize];
    
    @weakify(self)
    self.requestRemoteDataCommand = [[RACCommand alloc]
        initWithSignalBlock:^(NSNumber *page) {
            @strongify(self)
            return [[self requestRemoteDataSignalWithPage:page.unsignedIntegerValue] takeUntil:self.rac_willDeallocSignal];
        }];
    
    [[self.requestRemoteDataCommand.errors
     filter:[self requestRemoteDataErrorsFilter]]
     subscribe:self.errors];
}

- (BOOL (^)(NSError *error))requestRemoteDataErrorsFilter {
    return ^(NSError *error) {
        return YES;
    };
}
- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    return [RACSignal empty];
}

@end
