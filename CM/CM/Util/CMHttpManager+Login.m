//
//  CMHttpSessionManager+Login.m
//  CM
//
//  Created by Duke on 1/12/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMHttpManager+Login.h"
#import "CMHttpSessionManager+File.h"
#import "CMModel.h"
#import "CMLoginModel.h"
#import "CMGetUpload.h"
#import "CMProfielMTLModel.h"
#define Path_Login  @"/jncg-api/auth/login"
#define Path_User_Uptoken  @"/jncg-api/user/uptoken"
#define Path_SMS @"/jncg-api/auth/captcha/sms"
#define Path_Register @"/jncg-api/auth/register"
#define Path_Profile @"/jncg-api/user/profile"
#define Path_User_Password_Reset @"/jncg-api/user/password/reset"
#define Path_User_Password @"/jncg-api/user/password"




@implementation CMHttpManager (Login)
- (RACSignal *)loginWithUsername:(NSString *)username
                        password:(NSString *)password
{
    NSDictionary *dic = @{@"phoneNumber":username,
                          @"password":password
                          };
    return [[[[CMHttpManager sharedClient] rac_POST:Path_Login parameters:dic]
              tryMap:^id(RACTuple *value, NSError *__autoreleasing *errorPtr) {
                  
                  NSDictionary *dic = value.first;
                  NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                  NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                  NSLog(@"%@'s jsonResponse ====> %@",Path_Login,str);
                  
                  CMLoginModel *model = [MTLJSONAdapter modelOfClass:[CMLoginModel class] fromJSONDictionary:dic error:nil];
                  if (model.success) {
                      return model;
                  }
                  else {
                      NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:model.msg                                                                                                                };
                      *errorPtr = [NSError errorWithDomain:@"" code:0 userInfo:userinfo];
                      return nil;
                  }
             }]
            catch:^RACSignal *(NSError *error) {
                return [RACSignal error:error];
            }];
}
- (RACSignal *)getupToken:(NSString *)accessToken
{
    NSDictionary *dic = @{@"accessToken":accessToken
                          };
    return [[[[CMHttpManager sharedClient] rac_GET:Path_User_Uptoken parameters:dic]
             tryMap:^id(RACTuple *value, NSError *__autoreleasing *errorPtr) {
                 
                 NSDictionary *dic = value.first;
                 NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                 NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 NSLog(@"%@'s jsonResponse ====> %@",Path_User_Uptoken,str);
                 
                 CMGetUpload *model = [MTLJSONAdapter modelOfClass:[CMGetUpload class] fromJSONDictionary:dic error:nil];
                 if (model.success) {
                     return model;
                 }
                 else {
                     NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:model.msg                                                                                                                };
                     *errorPtr = [NSError errorWithDomain:@"" code:0 userInfo:userinfo];
                     return nil;
                 }
             }]
            catch:^RACSignal *(NSError *error) {
                return [RACSignal error:error];
            }];
}

- (RACSignal *)getSms:(NSString *)phoneNumber type:(NSString *)type {
    NSDictionary *dic = @{@"phoneNumber":phoneNumber,
                          @"type":type
                          };
    return [[[[CMHttpManager sharedClient] rac_GET:Path_SMS parameters:dic]
             tryMap:^id(RACTuple *value, NSError *__autoreleasing *errorPtr) {
                 
                 NSDictionary *dic = value.first;
                 NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                 NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 NSLog(@"%@'s jsonResponse ====> %@",Path_SMS,str);
                 
                 CMModel *model = [MTLJSONAdapter modelOfClass:[CMModel class] fromJSONDictionary:dic error:nil];
//                 return model;
                 if (model.success) {
                     return model;
                 }
                 else {
                     NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:model.msg                                                                                                                };
                     *errorPtr = [NSError errorWithDomain:@"" code:0 userInfo:userinfo];
                     return nil;
                 }
             }]
            catch:^RACSignal *(NSError *error) {
                return [RACSignal error:error];
            }];
}

-(RACSignal *)registerWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password captcha:(NSString *)captcha {
    NSDictionary *dic = @{@"phoneNumber":phoneNumber,
                          @"password":password,
                          @"captcha":captcha,
                          };
    return [[[[CMHttpManager sharedClient] rac_POST:Path_Register parameters:dic]
             tryMap:^id(RACTuple *value, NSError *__autoreleasing *errorPtr) {
                 
                 NSDictionary *dic = value.first;
                 NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                 NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 NSLog(@"%@'s jsonResponse ====> %@",Path_Register,str);
                 CMLoginModel *model = [MTLJSONAdapter modelOfClass:[CMLoginModel class] fromJSONDictionary:dic error:nil];
                 if (model.success) {
                     return model;
                 }
                 else {
                     NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:model.msg                                                                                                                };
                     *errorPtr = [NSError errorWithDomain:@"" code:0 userInfo:userinfo];
                     return nil;
                 }
             }]
            catch:^RACSignal *(NSError *error) {
                return [RACSignal error:error];
            }];
}

- (RACSignal *)profileWithAccessToken:(NSString *)accessToken
                             realname:(NSString *)realname
                             idCardNo:(NSString *)idCardNo
                           idCardImg1:(NSString *)idCardImg1
                           idCardImg2:(NSString *)idCardImg2
{
    NSDictionary *dic = @{@"accessToken":accessToken,
                          @"realname":realname,
                          @"idCardNo":idCardNo,
                          @"idCardImg1":idCardImg1,
                          @"idCardImg2":idCardImg2,
                          };
    return [[[[CMHttpManager sharedClient] rac_POST:Path_Profile parameters:dic]
             tryMap:^id(RACTuple *value, NSError *__autoreleasing *errorPtr) {
                 
                 NSDictionary *dic = value.first;
                 NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                 NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 NSLog(@"%@'s jsonResponse ====> %@",Path_Profile,str);
                 CMModel *model = [MTLJSONAdapter modelOfClass:[CMModel class] fromJSONDictionary:dic error:nil];
                 if (model.success) {
                     return model;
                 }
                 else {
                     NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:model.msg                                                                                                                };
                     *errorPtr = [NSError errorWithDomain:@"" code:0 userInfo:userinfo];
                     return nil;
                 }
             }]
            catch:^RACSignal *(NSError *error) {
                return [RACSignal error:error];
            }];
}

- (RACSignal *)getProfileWithAccessToken:(NSString *)accessToken {
    NSDictionary *dic = @{@"accessToken":accessToken,
                          };
    return [[[[CMHttpManager sharedClient] rac_GET:Path_Profile parameters:dic]
             tryMap:^id(RACTuple *value, NSError *__autoreleasing *errorPtr) {
                 
                 NSDictionary *dic = value.first;
                 NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                 NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 NSLog(@"%@'s jsonResponse ====> %@",Path_Profile,str);
                 
                 
                 CMProfielMTLModel *model = [MTLJSONAdapter modelOfClass:[CMProfielMTLModel class] fromJSONDictionary:dic error:nil];
                 if (model.success) {
                     User *user = [[User alloc] init];
                     user.idCardNo = model.data.idCardNo;
                     user.idCardImg1 = model.data.idCardImg1;
                     user.idCardImg2 = model.data.idCardImg2;
                     user.user_id = model.data.user_id;
                     user.regTime = model.data.regTime;
                     user.realname = model.data.realname;
                     user.verifyStatus = model.data.verifyStatus;
                     user.phoneNumber = model.data.phoneNumber;
                     user.verifyOpinion = model.data.verifyOpinion;
                     user.avatar = model.data.avatar;
                     return user;
                 }
                 else {
                     NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:model.msg                                                                                                                };
                     *errorPtr = [NSError errorWithDomain:@"" code:model.errorCode userInfo:userinfo];
                     return nil;
                 }
             }]
            catch:^RACSignal *(NSError *error) {
                return [RACSignal error:error];
            }];
}
-(RACSignal *)forgotPwdWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password captcha:(NSString *)captcha {
    NSDictionary *dic = @{@"phoneNumber":phoneNumber,
                          @"password":password,
                          @"captcha":captcha,
                          };
    return [[[[CMHttpManager sharedClient] rac_POST:Path_User_Password_Reset parameters:dic]
             tryMap:^id(RACTuple *value, NSError *__autoreleasing *errorPtr) {
                 
                 NSDictionary *dic = value.first;
                 NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                 NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 NSLog(@"%@'s jsonResponse ====> %@",Path_User_Password_Reset,str);
                 CMModel *model = [MTLJSONAdapter modelOfClass:[CMModel class] fromJSONDictionary:dic error:nil];
                 if (model.success) {
                     return model;
                 }
                 else {
                     NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:model.msg                                                                                                                };
                     *errorPtr = [NSError errorWithDomain:@"" code:model.errorCode userInfo:userinfo];
                     return nil;
                 }
             }]
            catch:^RACSignal *(NSError *error) {
                return [RACSignal error:error];
            }];
}

- (RACSignal *)changePwdWithAccessToken:(NSString *)accessToken
                               password:(NSString *)password
                            oldPassword:(NSString *)oldPassword
{
    NSDictionary *dic = @{@"accessToken":accessToken,
                          @"password":password,
                          @"oldPassword":oldPassword,
                          };
    return [[[[CMHttpManager sharedClient] rac_POST:Path_User_Password parameters:dic]
             tryMap:^id(RACTuple *value, NSError *__autoreleasing *errorPtr) {
                 
                 NSDictionary *dic = value.first;
                 NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                 NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 NSLog(@"%@'s jsonResponse ====> %@",Path_User_Password,str);
                 CMModel *model = [MTLJSONAdapter modelOfClass:[CMModel class] fromJSONDictionary:dic error:nil];
                 if (model.success) {
                     return model;
                 }
                 else {
                     NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:model.msg                                                                                                                };
                     *errorPtr = [NSError errorWithDomain:@"" code:model.errorCode userInfo:userinfo];
                     return nil;
                 }
             }]
            catch:^RACSignal *(NSError *error) {
                return [RACSignal error:error];
            }];
}


@end
