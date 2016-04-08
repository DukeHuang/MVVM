//
//  CMHttpSessionManager.m
//  CM
//
//  Created by Duke on 1/18/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMHttpSessionManager.h"


@implementation CMHttpSessionManager
+(CMHttpSessionManager *)sharedClient
{
    static CMHttpSessionManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ self alloc] init];
    });
    
    return manager;
}

-(id)init {
    if (self = [super initWithBaseURL:[NSURL URLWithString:baseUrl]]) {
        self.responseSerializer.acceptableContentTypes = [self.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
//        self.requestSerializer.timeoutInterval = 10;
    }
    return  self;
}
@end
