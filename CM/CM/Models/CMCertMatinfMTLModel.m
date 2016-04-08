//
//  CMCertMatinfMTLModel.m
//  CM
//
//  Created by Duke on 1/29/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMCertMatinfMTLModel.h"

@implementation CMCertMatinfMTLModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}
+ (NSValueTransformer *)rowsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[CertMatinfRows class]];
}

@end
@implementation CertMatinfRows
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *map =  [[NSDictionary mtl_identityPropertyMapWithModel:self] mutableCopy];
    map[@"id_CertMatinfRows"] = @"id";
    return map;
}
@end


