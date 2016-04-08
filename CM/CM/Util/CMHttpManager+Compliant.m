//
//  CMHttpManager+Compliant.m
//  CM
//
//  Created by Duke on 1/20/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMHttpManager+Compliant.h"
#import "CMDistrictMTLModel.h"
#import "CMModel.h"
#import "CMProgressMTLModel.h"
#import "CMPunishMTLModel.h"
#import "CMPunishDetailMTLModel.h"
#import "CMCertProgressMTLModel.h"
#define Path_District @"/jncg-api/district"
#define Path_Complaint @"/jncg-api/complaint"
#define Path_Penalty_List @"/jncg-api/penalty/list"
#define Path_Cert_List @"/jncg-api/cert"
#define Path_Penalty @"/jncg-api/penalty/"
#define Path_Complaint_Detail @"/jncg-api/complaint/"

@implementation CMHttpManager (Compliant)

- (RACSignal *)getDistrictWithAccessToken:(NSString *)accessToken {
    {
        NSDictionary *dic = @{@"accessToken":accessToken                              };
        return [[[[CMHttpManager sharedClient] rac_GET:Path_District parameters:dic]
                 tryMap:^id(RACTuple *value, NSError *__autoreleasing *errorPtr) {
                     
                     NSDictionary *dic = value.first;
                     NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                     NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                     NSLog(@"%@'s jsonResponse ====> %@",Path_District,str);
                     
                     CMDistrictMTLModel *model = [MTLJSONAdapter modelOfClass:[CMDistrictMTLModel class] fromJSONDictionary:dic error:nil];
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
}

- (RACSignal *)complaintWithAccessToken:(NSString *)accessToken
                                  title:(NSString *)title
                                   date:(NSString *)date
                               location:(NSString *)location
                           districtCode:(NSString *)districtCode
                               matType0:(NSString *)matType0
                               matPath0:(NSString *)matPath0
                               matType1:(NSString *)matType1
                               matPath1:(NSString *)matPath1
                               matType2:(NSString *)matType2
                               matPath2:(NSString *)matPath2
                           categoryCode:(NSString *)categoryCode
                                content:(NSString *)content
                                  pName:(NSString *)pName
                                    pNo:(NSString *)pNo;
{
    NSDictionary *dic = @{@"accessToken":accessToken,
                          @"categoryCode":categoryCode,
                          @"content":content,
                          @"location":location,
                          @"title":title,
                          @"date":date,
                          @"districtCode":districtCode,
                          };
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    if ([matType0 isExist]) {
        [mutableDic setObject:matType0 forKey:@"mat[0].matType"];
        [mutableDic setObject:matPath0 forKey:@"mat[0].matPath"];
    }
    if ([matType1 isExist]) {
        [mutableDic setObject:matType1 forKey:@"mat[1].matType"];
        [mutableDic setObject:matPath1 forKey:@"mat[1].matPath"];
    }
    if ([matType2 isExist]) {
        [mutableDic setObject:matType2 forKey:@"mat[2].matType"];
        [mutableDic setObject:matPath2 forKey:@"mat[2].matPath"];
    }
    if ([pName isExist]) {
        [mutableDic setObject:pName forKey:@"pName"];
       
    }
    if ([pNo isExist]) {
         [mutableDic setObject:pNo forKey:@"pNo"];
    }
    return [[[[CMHttpManager sharedClient] rac_POST:Path_Complaint parameters:mutableDic]
             tryMap:^id(RACTuple *value, NSError *__autoreleasing *errorPtr) {
                 
                 NSDictionary *dic = value.first;
                 NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                 NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 NSLog(@"%@'s jsonResponse ====> %@",Path_Complaint,str);
                 
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

-(RACSignal *)getComplaintWithAccessToken:(NSString *)accessToken
                                   offset:(int)offset
                                    limit:(int)limit
                             categoryCode:(NSString *)categoryCode

{
    NSDictionary *parameters = @{
                                 @"offset":[NSString stringWithFormat:@"%d",offset],
                                 @"limit":[NSString stringWithFormat:@"%d",limit],
                                 @"accessToken":accessToken,
                                 @"categoryCode":categoryCode,
                                 };
    return [[[[CMHttpManager sharedClient] rac_GET:Path_Complaint  parameters:parameters]
             tryMap:^id(RACTuple *value, NSError *__autoreleasing *errorPtr) {
                 
                 NSDictionary *dic = value.first;
                 NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                 NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 NSLog(@"%@'s jsonResponse ====> %@",Path_Complaint,str);
                 
                 CMProgressMTLModel *model = [MTLJSONAdapter modelOfClass:[CMProgressMTLModel class] fromJSONDictionary:dic error:nil];
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

-(RACSignal *)getPenaltyWithAccessToken:(NSString *)accessToken
                                   offset:(int)offset
                                    limit:(int)limit

{
    NSDictionary *parameters = @{
                                 @"offset":[NSString stringWithFormat:@"%d",offset],
                                 @"limit":[NSString stringWithFormat:@"%d",limit],
                                 @"accessToken":accessToken,
                                 };
    return [[[[CMHttpManager sharedClient] rac_GET:Path_Penalty_List  parameters:parameters]
             tryMap:^id(RACTuple *value, NSError *__autoreleasing *errorPtr) {
                 
                 NSDictionary *dic = value.first;
                 NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                 NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 NSLog(@"%@'s jsonResponse ====> %@",Path_Penalty_List,str);
                 
                 CMPunishMTLModel *model = [MTLJSONAdapter modelOfClass:[CMPunishMTLModel class] fromJSONDictionary:dic error:nil];
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

-(RACSignal *)getCerWithAccessToken:(NSString *)accessToken
                                 offset:(int)offset
                                  limit:(int)limit

{
    NSDictionary *parameters = @{
                                 @"offset":[NSString stringWithFormat:@"%d",offset],
                                 @"limit":[NSString stringWithFormat:@"%d",limit],
                                 @"accessToken":accessToken,
                                 };
    return [[[[CMHttpManager sharedClient] rac_GET:Path_Cert_List  parameters:parameters]
             tryMap:^id(RACTuple *value, NSError *__autoreleasing *errorPtr) {
                 
                 NSDictionary *dic = value.first;
                 NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                 NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 NSLog(@"%@'s jsonResponse ====> %@",Path_Cert_List,str);
                 
                 CMCertProgressMTLModel *model = [MTLJSONAdapter modelOfClass:[CMCertProgressMTLModel class] fromJSONDictionary:dic error:nil];
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

-(RACSignal *)getPenaltyDetailWithAccessToken:(NSString *)accessToken
                                    penaltyId:(NSString *)penaltyId

{
    NSDictionary *parameters = @{
                                 @"accessToken":accessToken,
                                 };
    return [[[[CMHttpManager sharedClient] rac_GET:[Path_Penalty  stringByAppendingString:penaltyId] parameters:parameters]
             tryMap:^id(RACTuple *value, NSError *__autoreleasing *errorPtr) {
                 
                 NSDictionary *dic = value.first;
                 NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                 NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 NSLog(@"%@'s jsonResponse ====> %@",Path_Penalty,str);
                 
                 CMPunishDetailMTLModel *model = [MTLJSONAdapter modelOfClass:[CMPunishDetailMTLModel class] fromJSONDictionary:dic error:nil];
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

- (RACSignal *)getComplaintDetailWithAccessToken:(NSString *)accessToken complaintId:(NSString *)complaintId {
    NSDictionary *parameters = @{
                                 @"accessToken":accessToken,
                                 };
    return [[[[CMHttpManager sharedClient] rac_GET:[Path_Complaint_Detail  stringByAppendingString:complaintId] parameters:parameters]
             tryMap:^id(RACTuple *value, NSError *__autoreleasing *errorPtr) {
                 
                 NSDictionary *dic = value.first;
                 NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                 NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 NSLog(@"%@'s jsonResponse ====> %@",Path_Complaint_Detail,str);
                 
                 CMPunishDetailMTLModel *model = [MTLJSONAdapter modelOfClass:[CMPunishDetailMTLModel class] fromJSONDictionary:dic error:nil];
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
