//
//  CMChangePwdViewModel.m
//  CM
//
//  Created by Duke on 3/15/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMChangePwdViewModel.h"
#import "CMHttpManager+Login.h"
@interface CMChangePwdViewModel()

@property(nonatomic,copy,readwrite) NSString *oldPassword;

@property(nonatomic,copy,readwrite) NSString *theNewPassword;

@property(nonatomic,copy,readwrite) NSString *reNewPassword;

@property(nonatomic,strong,readwrite) RACCommand *validPasswordCommand;


@property(nonatomic,strong,readwrite) RACCommand *changePasswordCommand;


@end

@implementation CMChangePwdViewModel
- (void)initialize {
    [super initialize];
   
    
    self.changePasswordCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[CMHttpManager sharedClient] changePwdWithAccessToken:[SSKeychain accessToken] password:self.theNewPassword oldPassword:self.oldPassword];
    }];
    [self.changePasswordCommand.errors subscribe:self.errors];
    self.validPasswordCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [self checkoutInput];
    }];
    [self.validPasswordCommand.errors subscribe:self.errors];
    
}

- (RACSignal *)checkoutInput {
    if (self.oldPassword.length < 6) {
        RACSignal *validPhone = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:@"请输入正确的旧密码"                                                                                                               };
            [subscriber sendError:[NSError errorWithDomain:@"" code:0 userInfo:userinfo]];
            return nil;
        }];
        return validPhone;
    }
    if (self.theNewPassword.length < 6) {
        RACSignal *validVerifyCode = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:@"请输入不少于6位的新密码"                                                                                                               };
            [subscriber sendError:[NSError errorWithDomain:@"" code:0 userInfo:userinfo]];
            return nil;
        }];
        return validVerifyCode;
    }
   
    if (![self.reNewPassword isEqualToString:self.theNewPassword]) {
        RACSignal *validRepassword = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:@"两次输入的密码不一致"                                                                                                               };
            [subscriber sendError:[NSError errorWithDomain:@"" code:0 userInfo:userinfo]];
            return nil;
        }];
        return validRepassword;
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
