//
//  CMGetUpload.h
//  CM
//
//  Created by Duke on 3/2/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface CMGetUpload : MTLModel <MTLJSONSerializing>
@property (nonatomic, assign) BOOL success;

@property (nonatomic, strong) NSString *data;

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, copy)  NSString *msg;

@property (nonatomic, assign) NSInteger errorCode;


@end
