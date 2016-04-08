//
//  NSString+Util.h
//  CM
//
//  Created by Duke on 1/13/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Util)

-(BOOL)isExist;


+ (NSString *)mimeTypeForData:(NSData *)data;
/**
 *  创建文件
 *
 *  @param file 文件名
 *
 *  @return 返回路径
 */
+ (NSString *)createDocumentsFileWithFloderName:(NSString *)floder
                                       fileName:(NSString *)file;
+ (NSString *)fileNameWithCurrentTimeAndFileType:(NSString *)type;

+ (NSString *)currentTimestampWithLongLongFormat;

+ (NSString *)qiniuKey;

@end
