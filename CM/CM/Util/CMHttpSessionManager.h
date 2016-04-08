//
//  CMHttpSessionManager.h
//  CM
//
//  Created by Duke on 1/18/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#define baseUrl @"http://120.24.76.134:8080"

@interface CMHttpSessionManager : AFHTTPSessionManager

+(CMHttpSessionManager *)sharedClient;

@end
