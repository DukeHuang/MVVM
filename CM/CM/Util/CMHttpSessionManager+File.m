//
//  CMHttpSessionManager+File.m
//  CM
//
//  Created by Duke on 1/18/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMHttpSessionManager+File.h"
#import "CMModel.h"
#import "CMUploadFileMTLModel.h"
#import "CMLoginModel.h"
#define Path_File @"/jncg-api/file"
#define Path_Login  @"/jncg-api/auth/login"
#define Path_Download  @"/jncg-api/file/download"
#define Qinniu_Download_URL @"http://7xqxdp.com2.z0.glb.qiniucdn.com"

#import <QiniuSDK.h>
#import "CMHttpManager+Login.h"
#import "CMGetUpload.h"


@implementation CMHttpSessionManager (File)

- (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize]/1024.0f/1024.0f;
    }
    return 0;
}

//- (RACSignal *)uploadFileWithAccessToken:(NSString *)accessToken
//                               dateModel:(CMUploadFileDataModel*)dataModel
//                                   index:(int)index
//{
//    
//    NSString *token = accessToken;
//    QNUploadManager *upManager = [[QNUploadManager alloc] init];
////    NSLog(@"File size is : %.2f MB",(float)dataModel.data.length/1024.0f/1024.0f);
//    
//    float size;
//    if ([dataModel.mediaType integerValue] == IQMediaPickerControllerMediaTypePhotoLibrary ) {
//         size = (float)dataModel.dataFromPhotoLibrary.length/1024.0f/1024.0f;
//        
//    }
//    else {
//        size = [self fileSizeAtPath:dataModel.filePath.path];
//    }
//    if (size  > 20) {
//        NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:[NSString stringWithFormat:@"第%d个文件太大，请重新选择",index]                                                                                                          };
//        NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:userinfo];
//        return [RACSignal error:error];
//    }
//    
//    NSDictionary *dic = @{@"accessToken":accessToken
//                          };
//    return [[[[CMHttpSessionManager sharedClient] rac_POST:Path_File parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        if ([dataModel.mediaType integerValue] == IQMediaPickerControllerMediaTypePhotoLibrary ) {
//            [formData appendPartWithFileData:dataModel.dataFromPhotoLibrary name:@"file" fileName:dataModel.fileName mimeType:dataModel.mimeType];
//        }
//        else {
//            [formData appendPartWithFileURL:dataModel.filePath name:@"file" fileName:dataModel.fileName mimeType:dataModel.mimeType error:nil];
//        }
//        
//    }]
//            tryMap:^id(RACTuple *value, NSError *__autoreleasing *errorPtr) {
//                
//                NSDictionary *dic = value.first;
//                NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
//                NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                NSLog(@"%@'s jsonResponse ====> %@",Path_File,str);
//                
//                CMUploadFileMTLModel *model = [MTLJSONAdapter modelOfClass:[CMUploadFileMTLModel class] fromJSONDictionary:dic error:nil];
//                if (model.success) {
//                    return model;
//                }
//                else {
//                    if (model.msg) {
//                        NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:model.msg                                                                                                                };
//                        *errorPtr = [NSError errorWithDomain:@"" code:0 userInfo:userinfo];
//                        return nil;
//                    }
//                    else {
//                        NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:@"上传失败"                                                                                                                };
//                        *errorPtr = [NSError errorWithDomain:@"" code:0 userInfo:userinfo];
//                        return nil;
//                    }
//                }
//                return nil;
//            }]
//    catch:^RACSignal *(NSError *error) {
//        return [RACSignal error:error];
//    }];
//}



//                    [[[CMHttpManager sharedClient] getupToken:[SSKeychain accessToken]] subscribeNext:^(CMGetUpload *x) {
//                        if (x.success) {
//                            [SSKeychain setQiniuToken:x.data];
//                        }
//
//                    }];
- (RACSignal *)uploadFileWithToken:(NSString *)accessToken
                               dateModel:(CMUploadFileDataModel*)dataModel
                                   index:(int)index
{
    NSString *token = accessToken;
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    
    float size;
    if ([dataModel.mediaType integerValue] == IQMediaPickerControllerMediaTypePhotoLibrary ) {
        size = (float)dataModel.dataFromPhotoLibrary.length/1024.0f/1024.0f;
        
    }
    else {
        size = [self fileSizeAtPath:dataModel.filePath.path];
    }
    if (size  > 20) {
        NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:[NSString stringWithFormat:@"第%d个文件太大，请重新选择",index]                                                                                                          };
        NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:userinfo];
        return [RACSignal error:error];
    }
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSData *data = [[NSData alloc] init];
        //        QNUploadOption *option = [[QNUploadOption alloc] initWithMime:dataModel.mimeType progressHandler:nil params:nil checkCrc:nil cancellationSignal:nil];
        QNUploadOption *option = nil;
        if ([dataModel.mediaType integerValue] == IQMediaPickerControllerMediaTypePhotoLibrary ) {
            data = dataModel.dataFromPhotoLibrary;
            NSString *key = [[NSString qiniuKey] stringByAppendingString:[NSString stringWithFormat:@".%@",[dataModel.mimeType componentsSeparatedByString:@"/"][1]]];
            [upManager putData:data key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                if (info.statusCode == 401)
                {
                    NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:@"七牛token过期"                                                                                                                };
                    NSError *error =  [NSError errorWithDomain:@"" code:INVALID_UP_TOKEN userInfo:userinfo];
                    [subscriber sendError:error];
                }
                else if(info.statusCode == 200) {
                    UploadFileData *fileData = [[UploadFileData alloc] init];
                    fileData.fileName = key;
                    fileData.mimeType = dataModel.mimeType;
                    [subscriber sendNext:fileData];
                    [subscriber sendCompleted];
                }
                else {
                    [subscriber sendError:info.error];
                }
            } option:option];
        }
        else {
            NSString *key = [[NSString qiniuKey] stringByAppendingString:[NSString stringWithFormat:@".%@",[dataModel.mimeType componentsSeparatedByString:@"/"][1]]];
            
            NSString *path = [NSString createDocumentsFileWithFloderName:@"download" fileName:key];
            [[NSFileManager defaultManager] moveItemAtPath:[dataModel.filePath path] toPath:path error:nil];
            [upManager putFile:path
                           key:key token:token
                      complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                          if (info.statusCode == 401)
                          {
                              NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:@"七牛token过期"                                                                                                                };
                              NSError *error =  [NSError errorWithDomain:@"" code:INVALID_UP_TOKEN userInfo:userinfo];
                              [subscriber sendError:error];
                          }
                          else if(info.statusCode == 200) {
                              UploadFileData *fileData = [[UploadFileData alloc] init];
                              fileData.fileName = key;
                              fileData.mimeType = dataModel.mimeType;
                              [subscriber sendNext:fileData];
                              [subscriber sendCompleted];
                          }
                          else {
                              [subscriber sendError:info.error];
                          }
                      } option:option];
        }
        return nil;
    }];
    
    
}
- (RACSignal *)loginWithUsername:(NSString *)username
                        password:(NSString *)password
{
    NSDictionary *dic = @{@"phoneNumber":username,
                          @"password":password
                          };
    return [[[[CMHttpSessionManager sharedClient] rac_POST:Path_Login parameters:dic]
             tryMap:^id(RACTuple *value, NSError *__autoreleasing *errorPtr) {
                 
                 NSDictionary *dic = value.first;
                 NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                 NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 NSLog(@"%@'s jsonResponse ====> %@",Path_Login,str);
                 
                 CMLoginModel *model = [MTLJSONAdapter modelOfClass:[CMLoginModel class] fromJSONDictionary:dic error:nil];
                 if (model.success) {
                     return model;
                 }
                 else {
                     NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:model.msg                                                                                                                };
                     *errorPtr = [NSError errorWithDomain:@"" code:model.errorCode userInfo:userinfo];
                     return nil;
                 }
             }]
            catch:^RACSignal *(NSError *error) {
                return [RACSignal error:error];
            }];
}

- (RACSignal *)downloadFileURL:(NSString *)aUrl savePath:(NSString *)aSavePath fileName:(NSString *)aFileName
{
    NSString *fileURL = [NSString stringWithFormat:@"%@/%@",Qinniu_Download_URL,aUrl];

    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //检查本地文件是否已存在
        NSString *fileName = [NSString stringWithFormat:@"%@/%@", aSavePath, aFileName];
        //检查附件是否存在
            //创建附件存储目录
            if (![fileManager fileExistsAtPath:aSavePath]) {
                [fileManager createDirectoryAtPath:aSavePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            
            //下载附件
            NSURL *url = [[NSURL alloc] initWithString:fileURL];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            operation.inputStream   = [NSInputStream inputStreamWithURL:url];
            operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:fileName append:NO];
            
            //下载进度控制
            /*
             [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
             NSLog(@"is download：%f", (float)totalBytesRead/totalBytesExpectedToRead);
             }];
             */
            
            //已完成下载
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [[NSFileManager defaultManager] removeItemAtPath:fileName error:nil];
                [subscriber sendError:error];
            
            }];
            
            [operation start];
            return [RACDisposable disposableWithBlock:^{
                [operation cancel];
            }];
    }];
}



@end
