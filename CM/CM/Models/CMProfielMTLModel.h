//
//  CMProfielMTLModel.h
//  CM
//
//  Created by Duke on 3/9/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <Mantle/Mantle.h>

@class Profile_Data;
@interface CMProfielMTLModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) BOOL success;

@property (nonatomic, strong) Profile_Data *data;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger errorCode;

@end
@interface Profile_Data : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *idCardNo;

@property (nonatomic, copy) NSString *idCardImg1;

@property (nonatomic, copy) NSString *idCardImg2;

@property (nonatomic, assign) NSInteger user_id;

@property (nonatomic, copy) NSString *regTime;

@property (nonatomic, copy) NSString *verifyTime;

@property (nonatomic, copy) NSString *realname;

@property (nonatomic, copy) NSString *verifyStatus;

@property (nonatomic, copy) NSString *phoneNumber;

@property (nonatomic, copy) NSString *verifyOpinion;
@property (nonatomic, copy) NSString *avatar;

@end

