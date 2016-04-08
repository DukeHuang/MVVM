//
//  CMUploadFileMTLModel.m
//  CM
//
//  Created by Duke on 1/22/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMUploadFileMTLModel.h"

@implementation CMUploadFileMTLModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}
+ (NSValueTransformer *)dataJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[UploadFileData class]];
}
@end
@implementation UploadFileData
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[UploadFileData class]];
}

@end


