//
//  CMHttpSessionManager+Login.h
//  CM
//
//  Created by Duke on 1/12/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMHttpManager.h"

@interface CMHttpManager (Login)
- (RACSignal *)loginWithUsername:(NSString *)username
                        password:(NSString *)password;

- (RACSignal *)getupToken:(NSString *)accessToken;

- (RACSignal *)getSms:(NSString *)phoneNumber
                 type:(NSString *)type;
- (RACSignal *)registerWithPhoneNumber:(NSString *)phoneNumber
                              password:(NSString *)password
                               captcha:(NSString *)captcha;
- (RACSignal *)profileWithAccessToken:(NSString *)accessToken
                              realname:(NSString *)realname
                            idCardNo:(NSString *)idCardNo
                            idCardImg1:(NSString *)idCardImg1
                           idCardImg2:(NSString *)idCardImg2;

- (RACSignal *)getProfileWithAccessToken:(NSString *)accessToken;

- (RACSignal *)forgotPwdWithPhoneNumber:(NSString *)phoneNumber
                              password:(NSString *)password
                               captcha:(NSString *)captcha;

- (RACSignal *)changePwdWithAccessToken:(NSString *)accessToken
                               password:(NSString *)password
                            oldPassword:(NSString *)oldPassword;




@end
