//
//  CMCertMatinfMTLModel.h
//  CM
//
//  Created by Duke on 1/29/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <Mantle/Mantle.h>

@class CertMatinfRows;
@interface CMCertMatinfMTLModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) BOOL success;

@property (nonatomic, strong) NSArray<CertMatinfRows *> *rows;

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, copy)  NSString *msg;

@property (nonatomic, assign) NSInteger errorCode;


@end
@interface CertMatinfRows : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *categoryCode;

@property (nonatomic, assign) NSInteger id_CertMatinfRows;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *exPath;

@property (nonatomic, copy) NSString *uploadFileName;

@property (nonatomic, copy) NSString *downloadedURL;

@end

