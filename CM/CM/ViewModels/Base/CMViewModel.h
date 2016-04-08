//
//  CMViewModel.h
//  CM
//
//  Created by Duke on 1/12/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CMViewModelServices;



@interface CMViewModel : NSObject

//init method
-(instancetype)initWithServices:(id<CMViewModelServices>)services params:(NSDictionary *)params;

@property (nonatomic,strong,readonly) id<CMViewModelServices> services;

@property (nonatomic,copy,readonly) NSDictionary *params;

//标题
@property (nonatomic,copy) NSString *title;

//回调block
@property (nonatomic,copy) VoidBlock_id callback;

// A RACSubject object, which representing all erros occurred in view model
@property (nonatomic,strong,readonly) RACSubject *errors;

@property (nonatomic,assign) BOOL shouldFetchLocalDataOnViewModelInitialize;

@property (nonatomic,assign) BOOL shouldRequestRemoteDataOnViewDidLoad;

@property (nonatomic,strong,readonly) RACSubject *willDisappearSignal;

-(void)initialize;

@end
