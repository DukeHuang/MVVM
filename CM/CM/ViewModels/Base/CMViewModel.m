//
//  CMViewModel.m
//  CM
//
//  Created by Duke on 1/12/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMViewModel.h"

@interface CMViewModel()

@property (nonatomic, strong, readwrite) id<CMViewModelServices> services;
@property (nonatomic, copy, readwrite) NSDictionary *params;

@property (nonatomic, strong, readwrite) RACSubject *errors;
@property (nonatomic, strong, readwrite) RACSubject *willDisappearSignal;

@end

@implementation CMViewModel

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    CMViewModel *viewModel = [super allocWithZone:zone];
    
    @weakify(viewModel)
    [[viewModel rac_signalForSelector:@selector(initWithServices:params:)]
     subscribeNext:^(id x) {
         @strongify(viewModel)
         [viewModel initialize];
     }];
    return viewModel;
}


-(instancetype)initWithServices:(id<CMViewModelServices>)services
                         params:(NSDictionary *)params {
    self = [super init];
    if (self) {
        self.shouldFetchLocalDataOnViewModelInitialize = YES;
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
        self.title = params[@"title"];
        self.services = services;
        self.params = params;
    }
    return self;
}

-(RACSubject *)errors {
    if (!_errors) {
        _errors = [RACSubject subject];
    }
    return _errors;
}

-(RACSubject *)willDisappearSignal {
    if (!_willDisappearSignal) {
        _willDisappearSignal = [RACSubject subject];
    }
    return _willDisappearSignal;
}

- (void)initialize {}
@end
