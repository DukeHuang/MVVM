//
//  CMHttpSessionManager+File.h
//  CM
//
//  Created by Duke on 1/18/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMHttpSessionManager.h"
#import "CMUploadFileDataModel.h"

@interface CMHttpSessionManager (File)
- (RACSignal *)uploadFileWithToken:(NSString *)accessToken
                               dateModel:(CMUploadFileDataModel*)dataModel
                                   index:(int)index;
- (RACSignal *)loginWithUsername:(NSString *)username
                        password:(NSString *)password;

- (RACSignal *)downloadFileURL:(NSString *)aUrl savePath:(NSString *)aSavePath fileName:(NSString *)aFileName;

@end
