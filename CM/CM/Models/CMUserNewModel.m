//
//  CMUserNewModel.m
//  CM
//
//  Created by Duke on 1/14/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMUserNewModel.h"

@implementation CMUserNewModel
+ (NSValueTransformer *)dataJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[CMUserNewData class]];
}
@end

@implementation CMUserNewData

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *map =  [[NSDictionary mtl_identityPropertyMapWithModel:self] mutableCopy];
    map[@"userNewId"] = @"id";
    return map;
}

@end
