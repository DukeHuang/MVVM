//
//  CMUploadFileMTLModel.h
//  CM
//
//  Created by Duke on 1/22/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <Mantle/Mantle.h>

@class UploadFileData;
@interface CMUploadFileMTLModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) BOOL success;

@property (nonatomic, strong) UploadFileData *data;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger errorCode;



@end
@interface UploadFileData : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, copy) NSString *mimeType;

@end

