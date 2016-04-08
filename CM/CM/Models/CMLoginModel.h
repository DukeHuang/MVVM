//
//  CMLoginModel.h
//  CM
//
//  Created by Duke on 1/13/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMModel.h"
@class CMLoginData;

@class User;
@interface CMLoginModel : CMModel

@property(nonatomic,strong) CMLoginData *data;

@end

@interface CMLoginData:MTLModel<MTLJSONSerializing>

@property (nonatomic,copy) NSString *accessToken;


@property (nonatomic, strong) User *user;


@end
@interface User : MTLModel<MTLJSONSerializing>

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

