//
//  CMHttpManager+Service.m
//  CM
//
//  Created by Duke on 2/22/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMHttpManager+Service.h"
#import "CMServiceMTLModel.h"
#define Path_Convenience @"/jncg-api/convenience/"

@implementation CMHttpManager (Service)

- (RACSignal *)getConvenienceWithCategoryCode:(NSString *)code
                                       offset:(int)offset
                                        limit:(int)limit
                                          lng:(float)longtitude
                                          lat:(float)latitude
{
        NSDictionary *parameters = @{
                              @"offset":[NSString stringWithFormat:@"%d",offset],
                              @"limit":[NSString stringWithFormat:@"%d",limit],
                              @"lng":[NSString stringWithFormat:@"%f",longtitude],
                              @"lat":[NSString stringWithFormat:@"%f",latitude],
                              };
    return [[[[CMHttpManager sharedClient] rac_GET:[Path_Convenience stringByAppendingString:code] parameters:parameters]
             tryMap:^id(RACTuple *value, NSError *__autoreleasing *errorPtr) {
                 
                 NSDictionary *dic = value.first;
                 NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                 NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 NSLog(@"%@'s jsonResponse ====> %@",Path_Convenience,str);
                 
                 CMServiceMTLModel *model = [MTLJSONAdapter modelOfClass:[CMServiceMTLModel class] fromJSONDictionary:dic error:nil];
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
