//
//  CMPunishMTLModel.h
//  CM
//
//  Created by Duke on 3/7/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <Mantle/Mantle.h>

@class Punish_Rows;
@interface CMPunishMTLModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) BOOL success;

@property (nonatomic, strong) NSArray<Punish_Rows *> *rows;

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, copy)  NSString *msg;

@property (nonatomic, assign)  NSInteger errorCode;



@end
@interface Punish_Rows : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *categoryCode;

@property (nonatomic, assign) NSInteger row_id;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *idCardNo;

@property (nonatomic, copy) NSString *row_newProgress;

@property (nonatomic, copy) NSString *realname;

@end

