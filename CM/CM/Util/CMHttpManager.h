//
//  CMHttpClient.h
//  CM
//
//  Created by Duke on 1/12/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMHttpManager : AFHTTPRequestOperationManager

+(CMHttpManager *)sharedClient;

@end


