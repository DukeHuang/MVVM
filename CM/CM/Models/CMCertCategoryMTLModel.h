//
//  CMCertCategoryMTLModel.h
//  CM
//
//  Created by Duke on 1/29/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <Mantle/Mantle.h>

@class CertRows;
@interface CMCertCategoryMTLModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) BOOL success;

@property (nonatomic, strong) NSArray<CertRows *> *rows;

@property (nonatomic,copy) NSString *msg;

@property (nonatomic, assign) NSInteger errorCode;


@end
@interface CertRows : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *content;

@end

