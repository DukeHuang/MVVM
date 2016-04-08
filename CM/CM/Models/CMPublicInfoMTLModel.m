//
//  CMPublicInfoMTLModel.m
//  CM
//
//  Created by Duke on 3/8/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMPublicInfoMTLModel.h"

@implementation CMPublicInfoMTLModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSValueTransformer *)rowsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PublicInfo_Rows class]];
}

@end
@implementation PublicInfo_Rows
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *map =  [[NSDictionary mtl_identityPropertyMapWithModel:self] mutableCopy];
    map[@"rows_id"] = @"id";
    return map;
}
@end


