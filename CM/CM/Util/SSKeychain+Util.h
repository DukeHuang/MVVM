//
//  SSKeychain+Util.h
//  CM
//
//  Created by Duke on 1/13/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <SSKeychain/SSKeychain.h>
#import "CMLoginModel.h"
@interface SSKeychain (Util)


+ (NSString *)username;
+ (NSString *)password;
+ (NSString *)accessToken;
+ (NSString *)qiniuToken;
+ (User *)user;

+ (BOOL)setUsername:(NSString *)username;
+ (BOOL)setPassword:(NSString *)password;
+ (BOOL)setAccessToken:(NSString *)accessToken;
+ (BOOL)setQiniuToken:(NSString *)qiniuToken;
+ (BOOL)setUser:(User *)u;

+ (BOOL)deleteUsername;
+ (BOOL)deletePassword;
+ (BOOL)deleteAccessToken;
+ (BOOL)deleteQiniuToken;
+ (BOOL)deleteUser;
//+ (BOOL)deleteUser;



@end
