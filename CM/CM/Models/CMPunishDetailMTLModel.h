//
//  CMPunishDetailMTLModel.h
//  CM
//
//  Created by Duke on 3/7/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <Mantle/Mantle.h>

@class Punish_Data,Punish_Mat;
@interface CMPunishDetailMTLModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) BOOL success;

@property (nonatomic, strong) Punish_Data *data;

@property (nonatomic, copy)  NSString *msg;

@property (nonatomic, assign) NSInteger errorCode;


@end
@interface Punish_Data : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *categoryCode;

@property (nonatomic, assign) NSInteger punish_data_id;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, strong) NSArray<Punish_Mat *> *mat;

@property (nonatomic, copy) NSString *idCardNo;

@property (nonatomic, copy) NSString *realname;

@end

@interface Punish_Mat : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) NSInteger punish_mat_id;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *docPath;

@property (nonatomic, assign) NSInteger penaltyId;

@property (nonatomic, copy) NSString *type;

@end

