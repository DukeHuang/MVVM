//
//  CMPostPorfileViewModel.m
//  CM
//
//  Created by Duke on 3/4/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMPostPorfileViewModel.h"
#import "CMHttpManager+Login.h"
#import "CMGetUpload.h"
#import "CMUploadFileDataModel.h"
#import "CMHttpSessionManager+File.h"
@interface CMPostPorfileViewModel ()

@property(nonatomic,strong,readwrite) RACCommand *validPostCommand;

@property(nonatomic,strong,readwrite) RACCommand *postProfileCommand;
@property(nonatomic,strong,readwrite) RACCommand *getUpTokenCommand;
@property(nonatomic,strong,readwrite)  RACCommand *uploadFileCommand;


@end


@implementation CMPostPorfileViewModel

-(void)initialize {
    [super initialize];
    self.validPostCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [self checkoutInput];
    }];
    [self.validPostCommand.errors subscribe:self.errors];
    self.postProfileCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[CMHttpManager sharedClient] profileWithAccessToken:self.accessToken realname:self.realname idCardNo:self.idCardNo idCardImg1:self.idCardImg1 idCardImg2:self.idCardImg2];
    }];
    [self.postProfileCommand.errors subscribe:self.errors];
    
    self.getUpTokenCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[CMHttpManager sharedClient] getupToken:self.accessToken];
    }];
    self.uploadFileCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *tuple) {
        RACTupleUnpack(CMUploadFileDataModel *data,NSNumber *index) = tuple;
        return [[CMHttpSessionManager sharedClient] uploadFileWithToken:[SSKeychain qiniuToken] dateModel:data index:[index intValue]];
    }];
    
}
- (RACSignal *)checkoutInput {
    if (![self.realname isExist]) {
        RACSignal *validPhone = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:@"请输入真实姓名"                                                                                                               };
            [subscriber sendError:[NSError errorWithDomain:@"" code:0 userInfo:userinfo]];
            return nil;
        }];
        return validPhone;
    }
    if (self.idCardNo.length != 18 ) {
        RACSignal *validVerifyCode = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:@"请输入正确的身份证号"                                                                                                               };
            [subscriber sendError:[NSError errorWithDomain:@"" code:0 userInfo:userinfo]];
            return nil;
        }];
        return validVerifyCode;
    }
    if (![self.idCardImg1 isExist]) {
        RACSignal *validPassword = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:@"请上传身份证正面图片"                                                                                                               };
            [subscriber sendError:[NSError errorWithDomain:@"" code:0 userInfo:userinfo]];
            return nil;
        }];
        return validPassword;
    }
    if (![self.idCardImg2 isExist]) {
        RACSignal *validPassword = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:@"请上传身份证反面图片"                                                                                                               };
            [subscriber sendError:[NSError errorWithDomain:@"" code:0 userInfo:userinfo]];
            return nil;
        }];
        return validPassword;
    }
    else {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@YES];
            [subscriber sendCompleted];
            return nil;
        }];
    }
}

@end
