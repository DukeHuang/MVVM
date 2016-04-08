//
//  CMHttpManager+PublicInfo.h
//  CM
//
//  Created by Duke on 3/8/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMHttpManager.h"

@interface CMHttpManager (PublicInfo)
-(RACSignal *)getPublicInfoWithCategoryCode:(NSString *)code
                                      offset:(int)offset
                                      limit:(int)limit;
- (RACSignal *)feedbackWithAccessToken:(NSString *)accessToken
                               content:(NSString *)content;
@end
