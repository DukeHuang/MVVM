//
//  CMHttpClient.m
//  CM
//
//  Created by Duke on 1/12/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMHttpManager.h"
//#define baseUrl @"http://120.24.76.134:8080"
#define baseUrl @"http://120.76.24.160:8080"


@implementation CMHttpManager

+(CMHttpManager *)sharedClient
{
    static CMHttpManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ self alloc] init];
    });
    
    return manager;
}

-(id)init {
    if (self = [super initWithBaseURL:[NSURL URLWithString:baseUrl]]) {
        self.requestSerializer.timeoutInterval = 10;
    }
    return  self;
}

@end

