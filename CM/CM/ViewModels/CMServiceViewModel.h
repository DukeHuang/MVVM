//
//  CMServiceViewModel.h
//  CM
//
//  Created by Duke on 2/19/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMTableViewModel.h"
#import "CMServiceMTLModel.h"

@interface CMServiceViewModel : CMTableViewModel

@property(nonatomic,strong,readwrite) CLLocation *currentLocation;

//@property(nonatomic,strong) RACCommand *getServiceCommand;

@property(nonatomic,copy) NSString *categoryCode;

@property(nonatomic,strong) NSMutableArray<Rows_Service *> *dataSouceArr;
//@property(nonatomic,copy)   NSString *categroyCode;
@property(nonatomic,assign) NSInteger offset;
@property(nonatomic,assign) NSInteger limit;
@property(nonatomic,assign) float longtitude;
@property(nonatomic,assign) float latitude;

@end
