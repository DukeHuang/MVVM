//
//  CMPunishDetailMTLModel.m
//  CM
//
//  Created by Duke on 3/7/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMPunishDetailMTLModel.h"

@implementation CMPunishDetailMTLModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}
+ (NSValueTransformer *)dataJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[Punish_Data class]];
}

@end
@implementation Punish_Data

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *map =  [[NSDictionary mtl_identityPropertyMapWithModel:self] mutableCopy];
    map[@"punish_data_id"] = @"id";
//    map[@"row_newProgress"] = @"newProgress";
    return map;
}

+ (NSValueTransformer *)matJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Punish_Mat class]];
}

@end


@implementation Punish_Mat
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *map =  [[NSDictionary mtl_identityPropertyMapWithModel:self] mutableCopy];
    map[@"punish_mat_id"] = @"id";
    //    map[@"row_newProgress"] = @"newProgress";
    return map;
}


@end


