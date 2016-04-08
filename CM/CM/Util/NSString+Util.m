//
//  NSString+Util.m
//  CM
//
//  Created by Duke on 1/13/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "NSString+Util.h"

@implementation NSString (Util)

-(BOOL)isExist {
    return self && ![self isEqualToString:@""];
}

+ (NSString *)mimeTypeForData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
            break;
        case 0x89:
            return @"image/png";
            break;
        case 0x47:
            return @"image/gif";
            break;
        case 0x49:
        case 0x4D:
            return @"image/tiff";
            break;
        case 0x25:
            return @"application/pdf";
            break;
        case 0xD0:
            return @"application/vnd";
            break;
        case 0x46:
            return @"text/plain";
            break;
        default:
            return @"application/octet-stream";
    }
    return nil;
}
/**
 *  创建文件
 *
 *  @param file 文件名
 *
 *  @return 返回路径
 */
+ (NSString *)createDocumentsFileWithFloderName:(NSString *)floder
                            fileName:(NSString *)file
{
    
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:floder];
    BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    NSAssert(bo,@"创建目录失败");
    
    NSString *result = [path stringByAppendingPathComponent:file];
    
    return result;
    
}
+ (NSString *)fileNameWithCurrentTimeAndFileType:(NSString *)type {
    [[NSDate date] timeIntervalSince1970];
    NSTimeInterval seconds = [[NSDate date] timeIntervalSince1970];
    NSString *intervalSeconds = [NSString stringWithFormat:@"%0.0f",seconds];
    
    NSString * fileName = [NSString stringWithFormat:@"%@%@",intervalSeconds,type];
    return fileName;
}

+ (NSString *)currentTimestampWithLongLongFormat
{
    double timeStamp = ceil([[NSDate date] timeIntervalSince1970] * 1000);
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setGeneratesDecimalNumbers:false];
    NSNumber *timeNumber = [NSNumber numberWithDouble:timeStamp];
    NSString *timeString = [formatter stringFromNumber:timeNumber];
    
    // NSTimeInterval is defined as double
    return timeString;
}

+(NSString *)qiniuKey {
    return [[SSKeychain username] stringByAppendingString:[NSString currentTimestampWithLongLongFormat]];
}

@end
