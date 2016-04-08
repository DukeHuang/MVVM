//
//  CMMessageMTLModel.m
//  CM
//
//  Created by Duke on 3/14/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMMessageMTLModel.h"

@implementation CMMessageMTLModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSValueTransformer *)rowsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Message_Rows class]];
}

@end
@implementation Message_Rows
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *map =  [[NSDictionary mtl_identityPropertyMapWithModel:self] mutableCopy];
    map[@"rows_id"] = @"id";
    return map;
}
@end


