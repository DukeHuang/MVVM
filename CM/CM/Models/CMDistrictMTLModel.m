//
//  CMDistrictMTLModel.m
//  CM
//
//  Created by Duke on 1/20/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMDistrictMTLModel.h"

@implementation CMDistrictMTLModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}
+ (NSValueTransformer *)rowsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Rows class]];
}


@end
@implementation Rows
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}
@end


