//
//  CMPublicInfoMTLModel.h
//  CM
//
//  Created by Duke on 3/8/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <Mantle/Mantle.h>

@class PublicInfo_Rows;
@interface CMPublicInfoMTLModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) BOOL success;

@property (nonatomic, assign) NSInteger errorCode;

@property (nonatomic, strong) NSArray<PublicInfo_Rows *> *rows;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger total;



@end
@interface PublicInfo_Rows : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *categoryCode;

@property (nonatomic, copy) NSString *createBy;

@property (nonatomic, copy) NSString *deleted;

@property (nonatomic, assign) NSInteger rows_id;

@property (nonatomic, copy) NSString *lastUpdateTime;

@property (nonatomic, copy) NSString *summary;

@property (nonatomic, copy) NSString *lastUpdateBy;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *createTime;

@end

