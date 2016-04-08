//
//  CMHttpManager+SelfCenter.m
//  CM
//
//  Created by Duke on 1/14/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMHttpManager+SelfCenter.h"
#import "CMUserNewModel.h"
#import "CMMessageMTLModel.h"

#define Path_UserNew @"/jncg-api/user/new"
#define Path_Message_List @"/jncg-api/message/list"
#define Path_Message_Detail @"/jncg-api/message/"
#define Path_User_Profile_Other @"/jncg-api/user/profile/other"

@implementation CMHttpManager (SelfCenter)
-(RACSignal *)getUserNewWithAccessToken:(NSString *)accessToken {
    NSDictionary *dic = @{@"accessToken":accessToken,
                          };
    return [[[CMHttpManager sharedClient] rac_GET:Path_UserNew parameters:dic]
            tryMap:^id(RACTuple *value, NSError *__autoreleasing *errorPtr) {
                
                NSDictionary *dic = value.first;
                NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"%@'s jsonResponse ====> %@",Path_UserNew,str);
                CMUserNewModel *model = [MTLJSONAdapter modelOfClass:[CMUserNewModel class] fromJSONDictionary:dic error:nil];
                if (model.success) {
                    return model;
                }
                else {
                    NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:model.msg                                                                                                                };
                    *errorPtr = [NSError errorWithDomain:@"" code:model.errorCode userInfo:userinfo];
                    return nil;
                }
            }];
}
-(RACSignal *)getMessageWithAccessToken:(NSString *)accessToken
                                 offset:(int)offset
                                  limit:(int)limit
{
    NSDictionary *parameters = @{
                                 @"accessToken":accessToken,
                                 @"offset":[NSString stringWithFormat:@"%d",offset],
                                 @"limit":[NSString stringWithFormat:@"%d",limit],
                                 };
    return [[[[CMHttpManager sharedClient] rac_GET:Path_Message_List parameters:parameters]
             tryMap:^id(RACTuple *value, NSError *__autoreleasing *errorPtr) {
                 
                 NSDictionary *dic = value.first;
                 NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                 NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 NSLog(@"%@'s jsonResponse ====> %@",Path_Message_List,str);
                 
                 CMMessageMTLModel *model = [MTLJSONAdapter modelOfClass:[CMMessageMTLModel class] fromJSONDictionary:dic error:nil];
                 if (model.success) {
                     return model;
                 }
                 else {
                     NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:model.msg                                                                                                                };
                     *errorPtr = [NSError errorWithDomain:@"" code:model.errorCode userInfo:userinfo];
                     return nil;
                 }
                 return dic;
             }]
            catch:^RACSignal *(NSError *error) {
                return [RACSignal error:error];
            }];
}
- (RACSignal *)getMessageDetailWithAccessToken:(NSString *)accessToken
                                     messageId:(NSString *)messageId {
    NSDictionary *parameters = @{
                                 @"accessToken":accessToken,
                                 };
    return [[[[CMHttpManager sharedClient] rac_GET:[Path_Message_Detail  stringByAppendingString:messageId] parameters:parameters]
             tryMap:^id(RACTuple *value, NSError *__autoreleasing *errorPtr) {
                 
                 NSDictionary *dic = value.first;
                 NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                 NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 NSLog(@"%@'s jsonResponse ====> %@",Path_Message_Detail,str);
                 
                 CMModel *model = [MTLJSONAdapter modelOfClass:[CMModel class] fromJSONDictionary:dic error:nil];
                 if (model.success) {
                     return model;
                 }
                 else {
                     NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:model.msg                                                                                                                };
                     *errorPtr = [NSError errorWithDomain:@"" code:model.errorCode userInfo:userinfo];
                     return nil;
                 }
                 return dic;
             }]
            catch:^RACSignal *(NSError *error) {
                return [RACSignal error:error];
            }];
}
- (RACSignal *)profileOtherWithAccessToken:(NSString *)accessToken avatar:(NSString *)avatar{
    NSDictionary *parameters = @{
                                 @"accessToken":accessToken,
                                 @"avatar":avatar
                                 };
    return [[[[CMHttpManager sharedClient] rac_POST:Path_User_Profile_Other parameters:parameters]
             tryMap:^id(RACTuple *value, NSError *__autoreleasing *errorPtr) {
                 
                 NSDictionary *dic = value.first;
                 NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                 NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 NSLog(@"%@'s jsonResponse ====> %@",Path_User_Profile_Other,str);
                 
                 CMModel *model = [MTLJSONAdapter modelOfClass:[CMModel class] fromJSONDictionary:dic error:nil];
                 if (model.success) {
                     return model;
                 }
                 else {
                     NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:model.msg                                                                                                                };
                     *errorPtr = [NSError errorWithDomain:@"" code:model.errorCode userInfo:userinfo];
                     return nil;
                 }
                 return dic;
             }]
            catch:^RACSignal *(NSError *error) {
                return [RACSignal error:error];
            }];
}
@end
