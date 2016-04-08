//
//  CMHttpManager+SelfCenter.h
//  CM
//
//  Created by Duke on 1/14/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMHttpManager.h"

@interface CMHttpManager (SelfCenter)

- (RACSignal *)getUserNewWithAccessToken:(NSString *)accessToken;
-(RACSignal *)getMessageWithAccessToken:(NSString *)accessToken
                                 offset:(int)offset
                                  limit:(int)limit;
- (RACSignal *)getMessageDetailWithAccessToken:(NSString *)accessToken
                                     messageId:(NSString *)messageId;

- (RACSignal *)profileOtherWithAccessToken:(NSString *)accessToken
                                    avatar:(NSString *)avatar;
@end
