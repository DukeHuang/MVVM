//
//  CMCertCategoryMTLModel.m
//  CM
//
//  Created by Duke on 1/29/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMCertCategoryMTLModel.h"

@implementation CMCertCategoryMTLModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}
+ (NSValueTransformer *)rowsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[CertRows class]];
}
@end

@implementation CertRows
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}
@end


