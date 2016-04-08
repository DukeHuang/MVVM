//
//  CMTableViewModel.h
//  CM
//
//  Created by Duke on 1/14/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMViewModel.h"

@interface CMTableViewModel : CMViewModel

@property(nonatomic,copy) NSArray *dataSource;

@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, assign) NSUInteger perPage;

@property (nonatomic, assign) BOOL shouldPullToRefresh;
@property (nonatomic, assign) BOOL shouldInfiniteScrolling;

@property (nonatomic, strong) RACCommand *requestRemoteDataCommand;
@property (nonatomic, strong) RACCommand *didSelectCommand;

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page;
@end
