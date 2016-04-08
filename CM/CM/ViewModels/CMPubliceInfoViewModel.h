//
//  CMPubliceInfoViewModel.h
//  CM
//
//  Created by Duke on 3/8/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMTableViewModel.h"

@interface CMPubliceInfoViewModel : CMTableViewModel
@property(nonatomic,copy) NSString *type;
@property(nonatomic,strong) NSMutableArray *dataSouceArr;
@property(nonatomic,assign) NSInteger offset;
@property(nonatomic,assign) NSInteger limit;
@property(nonatomic,copy) NSString *categoryCode;
@end
