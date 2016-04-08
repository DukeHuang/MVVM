//
//  CMDistrictMTLModel.h
//  CM
//
//  Created by Duke on 1/20/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <Mantle/Mantle.h>

@class Rows;
@interface CMDistrictMTLModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) BOOL success;

@property (nonatomic, strong) NSArray<Rows *> *rows;

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger errorCode;

@end
@interface Rows : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *code;

@end

