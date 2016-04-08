//
//  SSKeychain+Util.m
//  CM
//
//  Created by Duke on 1/13/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "SSKeychain+Util.h"
#import "CMUserDefault.h"

@implementation SSKeychain (Util)
+ (NSString *)username {
    return [[NSUserDefaults standardUserDefaults] objectForKey:MRC_USERNAME];
}

+ (NSString *)password {
    return [self passwordForService:MRC_SERVICE_NAME account:MRC_PASSWORD];
}

+ (NSString *)accessToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:MRC_ACCESS_TOKEN];
//    return [self passwordForService:MRC_SERVICE_NAME account:MRC_ACCESS_TOKEN];
}
+ (NSString *)qiniuToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:MRC_QINIU_TOKEN];
}

+ (User *)user {
    return [[CMUserDefault sharedInstance] readUserFromPlist];
}

+ (BOOL)setUsername:(NSString *)username{
    if (username == nil) NSLog(@"+setUsername: %@", username);
    
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:MRC_USERNAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

+ (BOOL)setPassword:(NSString *)password {
    return [self setPassword:password forService:MRC_SERVICE_NAME account:MRC_PASSWORD];
}

+ (BOOL)setAccessToken:(NSString *)accessToken {
//    return [self setPassword:accessToken forService:MRC_SERVICE_NAME account:MRC_ACCESS_TOKEN];
    if (accessToken == nil) NSLog(@"+setUsername: %@", accessToken);
    
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:MRC_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}
+ (BOOL)setQiniuToken:(NSString *)qiniuToken {
    //    return [self setPassword:accessToken forService:MRC_SERVICE_NAME account:MRC_ACCESS_TOKEN];
    if (qiniuToken == nil) NSLog(@"+setUsername: %@", qiniuToken);
    
    [[NSUserDefaults standardUserDefaults] setObject:qiniuToken forKey:MRC_QINIU_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}


+ (BOOL)setUser:(User *)u {
    if (u == nil) NSLog(@"+setUsername: %@", u);

    [CMUserDefault sharedInstance].user = u;
    
    return YES;
}
+ (BOOL)deleteUsername {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MRC_USERNAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

+ (BOOL)deletePassword {
    return [self deletePasswordForService:MRC_SERVICE_NAME account:MRC_PASSWORD];
}

+ (BOOL)deleteAccessToken {
//    return [self deletePasswordForService:MRC_SERVICE_NAME account:MRC_ACCESS_TOKEN];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MRC_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}
+ (BOOL)deleteQiniuToken {
    //    return [self deletePasswordForService:MRC_SERVICE_NAME account:MRC_ACCESS_TOKEN];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MRC_QINIU_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}
+ (BOOL)deleteUser {
    [[CMUserDefault sharedInstance] writeUserToPlist:[[User alloc] init]];
    return YES;
}

//+ (BOOL)deleteUser {
//    
//    return YES;
//}

@end
