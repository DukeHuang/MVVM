//
//  CMProfielMTLModel.m
//  CM
//
//  Created by Duke on 3/9/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMProfielMTLModel.h"

@implementation CMProfielMTLModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}
+ (NSValueTransformer *)dataJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[Profile_Data class]];
}

@end
@implementation Profile_Data
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *dic =  [[NSDictionary mtl_identityPropertyMapWithModel:[User class]] mutableCopy];
    dic[@"user_id"] = @"id";
    return dic;
}
@end


