//
//  CMLoginModel.m
//  CM
//
//  Created by Duke on 1/13/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMLoginModel.h"

@implementation CMLoginModel
+ (NSValueTransformer *)dataJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[CMLoginData class]];
}
@end
@implementation CMLoginData
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[CMLoginData class]];
}
+ (NSValueTransformer *)userJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[User class]];
}
@end
@implementation User
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *dic =  [[NSDictionary mtl_identityPropertyMapWithModel:[User class]] mutableCopy];
    dic[@"user_id"] = @"id";
    return dic;
}
@end


