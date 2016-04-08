//
//  CMCertProgressMTLModel.m
//  CM
//
//  Created by Duke on 3/8/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMCertProgressMTLModel.h"

@implementation CMCertProgressMTLModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSValueTransformer *)rowsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[CertProgress_Rows class]];
}
@end
@implementation CertProgress_Rows

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *map =  [[NSDictionary mtl_identityPropertyMapWithModel:self] mutableCopy];
    map[@"CertProgress_Rows_id"] = @"id";
    return map;
}
+ (NSValueTransformer *)categoryJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[CertProgress_Category class]];
}

+ (NSValueTransformer *)matJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[CertProgress_Mat class]];
}


@end


@implementation CertProgress_Category
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}
@end


@implementation CertProgress_Mat
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *map =  [[NSDictionary mtl_identityPropertyMapWithModel:self] mutableCopy];
    map[@"CertProgress_Mat_id"] = @"id";
    return map;
}
@end


