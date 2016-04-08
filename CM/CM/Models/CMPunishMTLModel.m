//
//  CMPunishMTLModel.m
//  CM
//
//  Created by Duke on 3/7/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMPunishMTLModel.h"

@implementation CMPunishMTLModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *map =  [[NSDictionary mtl_identityPropertyMapWithModel:self] mutableCopy];
    return map;
}
+ (NSValueTransformer *)rowsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Punish_Rows class]];
}
@end
@implementation Punish_Rows
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *map =  [[NSDictionary mtl_identityPropertyMapWithModel:self] mutableCopy];
    map[@"row_id"] = @"id";
    map[@"row_newProgress"] = @"newProgress";
    return map;
}
@end


