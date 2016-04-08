//
//  CMServiceMTLModel.m
//  CM
//
//  Created by Duke on 2/22/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMServiceMTLModel.h"

@implementation CMServiceMTLModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}
+ (NSValueTransformer *)rowsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Rows_Service class]];
}

@end
@implementation Rows_Service
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *map =  [[NSDictionary mtl_identityPropertyMapWithModel:self] mutableCopy];
    map[@"id_service"] = @"id";
    return map;
}

@end


