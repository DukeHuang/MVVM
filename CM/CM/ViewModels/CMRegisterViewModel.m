//
//  CMRegisterViewModel.m
//  CM
//
//  Created by Duke on 3/3/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMRegisterViewModel.h"
#import "CMHttpManager+Login.h"

@interface CMRegisterViewModel()

@property(nonatomic,strong,readwrite) RACSignal *validPhone;

@property(nonatomic,strong,readwrite) RACCommand *validRegisterCommand;

@property(nonatomic,strong,readwrite) RACCommand *getVerifyCodeCommand;

@property(nonatomic,strong,readwrite) RACCommand *registerCommand;

@property(nonatomic,strong,readwrite) RACCommand *forgotPwdCommand;

@end

@implementation CMRegisterViewModel

- (void)initialize {
    [super initialize];
    self.validPhone = [RACObserve(self, phoneNum) map:^id(NSString *value) {
        return @(value.length == 11);
    }];
    self.getVerifyCodeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSString *type = (NSString *)input;
        return [[CMHttpManager sharedClient] getSms:self.phoneNum type:type];
    }];
    
    self.registerCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[CMHttpManager sharedClient] registerWithPhoneNumber:self.phoneNum password:self.password captcha:self.verifyCode];
    }];
    [self.registerCommand.errors subscribe:self.errors];
    
    self.forgotPwdCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[CMHttpManager sharedClient] forgotPwdWithPhoneNumber:self.phoneNum password:self.password captcha:self.verifyCode];
    }];
    [self.forgotPwdCommand.errors subscribe:self.errors];
    
    
    self.validRegisterCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [self checkoutInput];
    }];
    [self.validRegisterCommand.errors subscribe:self.errors];
}

- (RACSignal *)checkoutInput {
    if (self.phoneNum.length != 11) {
        RACSignal *validPhone = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:@"请输入正确的电话号码"                                                                                                               };
            [subscriber sendError:[NSError errorWithDomain:@"" code:0 userInfo:userinfo]];
            return nil;
        }];
        return validPhone;
    }
    if (![self.verifyCode isExist]) {
        RACSignal *validVerifyCode = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:@"请输入验证码"                                                                                                               };
            [subscriber sendError:[NSError errorWithDomain:@"" code:0 userInfo:userinfo]];
            return nil;
        }];
        return validVerifyCode;
    }
    if (self.password.length < 6) {
        RACSignal *validPassword = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:@"请输入不少于6位的密码"                                                                                                               };
            [subscriber sendError:[NSError errorWithDomain:@"" code:0 userInfo:userinfo]];
            return nil;
        }];
        return validPassword;
    }
    if (![self.rePassword isEqualToString:self.password]) {
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
