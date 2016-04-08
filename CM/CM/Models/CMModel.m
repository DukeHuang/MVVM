//
//  CMModel.m
//  CM
//
//  Created by Duke on 1/13/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMModel.h"

@implementation CMModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}
@end


