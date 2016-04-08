//
//  CMHttpManager+Cert.m
//  CM
//
//  Created by Duke on 1/28/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMHttpManager+Cert.h"
#import "CMModel.h"
#import "CMCertCategoryMTLModel.h"
#import "CMCertMatinfMTLModel.h"
#define Path_Cert_Category @"/jncg-api/cert/category"
#define Path_Cert_Matif @"/jncg-api/cert/matinf"
#define Path_Cert @"/jncg-api/cert"
#define Path_Cert_Detail @"/jncg-api/cert/"

@implementation CMHttpManager (Cert)


- (RACSignal *)getCertCategory {
//    NSDictionary *dic = @{@"accessToken":accessToken                              };
    return [[[[CMHttpManager sharedClient] rac_GET:Path_Cert_Category parameters:nil]
             tryMap:^id(RACTuple *value, NSError *__autoreleasing *errorPtr) {
                 
                 NSDictionary *dic = value.first;
                 NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                 NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 NSLog(@"%@'s jsonResponse ====> %@",Path_Cert_Category,str);
                 
                                      CMCertCategoryMTLModel *model = [MTLJSONAdapter modelOfClass:[CMCertCategoryMTLModel class] fromJSONDictionary:dic error:nil];
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

- (RACSignal *)getCertMatinfoWithAccessToken:(NSString *)accessToken
                                categoryCode:(NSString *)categoryCode
{
        NSDictionary *dic = @{@"accessToken":accessToken,
                              @"categoryCode":categoryCode
                              };
    return [[[[CMHttpManager sharedClient] rac_GET:Path_Cert_Matif parameters:dic]
             tryMap:^id(RACTuple *value, NSError *__autoreleasing *errorPtr) {
                 
                 NSDictionary *dic = value.first;
                 NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                 NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 NSLog(@"%@'s jsonResponse ====> %@",Path_Cert_Matif,str);
                 
                 CMCertMatinfMTLModel *model = [MTLJSONAdapter modelOfClass:[CMCertMatinfMTLModel class] fromJSONDictionary:dic error:nil];
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

- (RACSignal *)uploadCertWithAccessToken:(NSString *)accessToken
                            categoryCode:(NSString *)categoryCode
                               certArray:(NSMutableArray<CertMatinfRows *> *)arr
{
    NSDictionary *dic = @{@"accessToken":accessToken,
                          @"categoryCode":categoryCode
                          };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    for (int i = 0; i < arr.count; i++) {
        CertMatinfRows *cert = arr[i];
        [parameters setObject:[NSString stringWithFormat:@"%ld",cert.id_CertMatinfRows]forKey:[NSString stringWithFormat:@"mat[%d].matInfId",i]];
        [parameters setObject:cert.uploadFileName forKey:[NSString stringWithFormat:@"mat[%d].matPath",i]];
        [parameters setObject:@".png" forKey:[NSString stringWithFormat:@"mat[%d].matType",i]];
    }
    
//    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
//    mutableDictionary
    
    return [[[[CMHttpManager sharedClient] rac_POST:Path_Cert parameters:parameters]
             tryMap:^id(RACTuple *value, NSError *__autoreleasing *errorPtr) {
                 
                 NSDictionary *dic = value.first;
                 NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                 NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 NSLog(@"%@'s jsonResponse ====> %@",Path_Cert,str);
                 
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
- (RACSignal *)getCertDetailWithAccessToken:(NSString *)accessToken certId:(NSString *)certId {
    NSDictionary *parameters = @{
                                 @"accessToken":accessToken,
                                 };
    return [[[[CMHttpManager sharedClient] rac_GET:[Path_Cert_Detail  stringByAppendingString:certId] parameters:parameters]
             tryMap:^id(RACTuple *value, NSError *__autoreleasing *errorPtr) {
                 
                 NSDictionary *dic = value.first;
                 NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                 NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 NSLog(@"%@'s jsonResponse ====> %@",Path_Cert_Detail,str);
                 
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
