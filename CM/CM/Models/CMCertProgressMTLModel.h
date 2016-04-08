//
//  CMCertProgressMTLModel.h
//  CM
//
//  Created by Duke on 3/8/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <Mantle/Mantle.h>

@class CertProgress_Rows,CertProgress_Category,CertProgress_Mat;
@interface CMCertProgressMTLModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign) BOOL success;

@property (nonatomic, strong) NSArray<CertProgress_Rows *> *rows;

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger errorCode;

@end
@interface CertProgress_Rows : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *categoryCode;

@property (nonatomic, assign) NSInteger CertProgress_Rows_id;

@property (nonatomic,copy) NSString *status;

@property (nonatomic, strong) NSArray<CertProgress_Mat *> *mat;

@property (nonatomic, copy) NSString *bidTime;

@property (nonatomic, strong) CertProgress_Category *category;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *desc;

@end

@interface CertProgress_Category : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *code;

@end

@interface CertProgress_Mat : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign) NSInteger certBidId;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, assign) NSInteger matInfId;

@property (nonatomic, assign) NSInteger CertProgress_Mat_id;

@property (nonatomic, copy) NSString *matPath;

@property (nonatomic, copy) NSString *matType;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *verifyBy;
@property (nonatomic, copy) NSString *verifyTime;
@property (nonatomic, copy) NSString *verifyOpinion;

@end

