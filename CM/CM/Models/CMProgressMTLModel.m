//
//  CMProgressMTLModel.m
//  CM
//
//  Created by Duke on 3/7/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMProgressMTLModel.h"

@implementation CMProgressMTLModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}
+ (NSValueTransformer *)rowsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Progress_Rows class]];
}

@end
@implementation Progress_Rows

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *map =  [[NSDictionary mtl_identityPropertyMapWithModel:self] mutableCopy];
    map[@"row_id"] = @"id";
    map[@"Progress"] = @"newProgress";
    return map;
}
+ (NSValueTransformer *)matJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Mat class]];
}


@end


@implementation Mat
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *map =  [[NSDictionary mtl_identityPropertyMapWithModel:self] mutableCopy];
    map[@"mat_id"] = @"id";
    return map;
}



@end


