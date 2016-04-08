//
//  CMModel.h
//  CM
//
//  Created by Duke on 1/13/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface CMModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) BOOL success;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic,assign) NSInteger errorCode;

@end


