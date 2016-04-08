//
//  CMMessageMTLModel.h
//  CM
//
//  Created by Duke on 3/14/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <Mantle/Mantle.h>

@class Message_Rows;
@interface CMMessageMTLModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) BOOL success;

@property (nonatomic, strong) NSArray<Message_Rows *> *rows;

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger errorCode;
@end
@interface Message_Rows : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *readStatus;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *createBy;

@property (nonatomic, assign) NSInteger rows_id;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *sendTime;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *createTime;

@end

