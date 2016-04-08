//
//  CMHttpManager+PublicInfo.m
//  CM
//
//  Created by Duke on 3/8/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMHttpManager+PublicInfo.h"
#import "CMPublicInfoMTLModel.h"
#define Path_Article  @"/jncg-api/article/"
#define Path_Feedback  @"/jncg-api/feedback"
@implementation CMHttpManager (PublicInfo)
-(RACSignal *)getPublicInfoWithCategoryCode:(NSString *)code
                                     offset:(int)offset
                                      limit:(int)limit
{
    NSDictionary *parameters = @{
                                 @"offset":[NSString stringWithFormat:@"%d",offset],
                                 @"limit":[NSString stringWithFormat:@"%d",limit],
                                 };
    return [[[[CMHttpManager sharedClient] rac_GET:[Path_Article stringByAppendingString:code] parameters:parameters]
             tryMap:^id(RACTuple *value, NSError *__autoreleasing *errorPtr) {
                 
                 NSDictionary *dic = value.first;
                 NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                 NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 NSLog(@"%@'s jsonResponse ====> %@",Path_Article,str);
                 
                 CMPublicInfoMTLModel *model = [MTLJSONAdapter modelOfClass:[CMPublicInfoMTLModel class] fromJSONDictionary:dic error:nil];
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
-(RACSignal *)feedbackWithAccessToken:(NSString *)accessToken
                              content:(NSString *)content
{
    NSDictionary *dic = @{@"accessToken":accessToken,
                          @"content":content
                          };
    return [[[[CMHttpManager sharedClient] rac_POST:Path_Feedback parameters:dic]
             tryMap:^id(RACTuple *value, NSError *__autoreleasing *errorPtr) {
                 
                 NSDictionary *dic = value.first;
                 NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                 NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 NSLog(@"%@'s jsonResponse ====> %@",Path_Feedback,str);
                 
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
