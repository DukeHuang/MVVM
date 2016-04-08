//
//  CMHttpManager+Service.h
//  CM
//
//  Created by Duke on 2/22/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMHttpManager.h"

@interface CMHttpManager (Service)

-(RACSignal *)getConvenienceWithCategoryCode:(NSString *)code
                                      offset:(int)offset
                                       limit:(int)limit
                                         lng:(float)longtitude
                                         lat:(float)latitude;

@end
