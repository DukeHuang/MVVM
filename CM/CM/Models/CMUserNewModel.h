//
//  CMUserNewModel.h
//  CM
//
//  Created by Duke on 1/14/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMModel.h"
@class CMUserNewData;
@interface CMUserNewModel : CMModel

@property(nonatomic,strong) CMUserNewData *data;


@end

@interface CMUserNewData : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) NSInteger userNewId;

@property (nonatomic, assign) NSInteger cert;

@property (nonatomic, assign) NSInteger penalty;

@property (nonatomic, assign) NSInteger msg;

@property (nonatomic, assign) NSInteger complaint;



@end
