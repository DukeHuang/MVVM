//
//  CMServiceMTLModel.h
//  CM
//
//  Created by Duke on 2/22/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <Mantle/Mantle.h>

@class Rows_Service;
@interface CMServiceMTLModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) BOOL success;

@property (nonatomic, strong) NSArray<Rows_Service *> *rows;

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, copy)  NSString *msg;

@property (nonatomic, assign) NSInteger errorCode;


@end
@interface Rows_Service : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *categoryCode;

@property (nonatomic, assign) CGFloat distance;

@property (nonatomic, assign) NSInteger id_service;

@property (nonatomic, copy) NSString *addr;

@property (nonatomic, assign) CGFloat lat;

@property (nonatomic, assign) CGFloat lng;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *tel1;

@property (nonatomic, copy) NSString *tel2;



@end

