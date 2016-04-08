//
//  CMUploadFileDataModel.m
//  CM
//
//  Created by Duke on 1/22/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMUploadFileDataModel.h"

@implementation CMUploadFileDataModel

-(instancetype)init {
    if (self = [super init]) {
        self.filePath = [[NSURL alloc] init];
        self.dataFromPhotoLibrary = [[NSData alloc] init];
//        [RACObserve(self, mediaType) subscribeNext:^(IQMediaPickerControllerMediaType mediaType) {
//            if (mediaType == IQMediaPickerControllerMediaTypePhotoLibrary || mediaType == IQMediaPickerControllerMediaTypePhoto ) {
//                self.mimeType = MIMETYPE_PNG;
//            } else if (mediaType == IQMediaPickerControllerMediaTypeVideoLibrary || mediaType == IQMediaPickerControllerMediaTypeVideo ) {
//                self.mimeType = MIMETYPE_MP4;
//            } else if (mediaType == IQMediaPickerControllerMediaTypeAudioLibrary || mediaType == IQMediaPickerControllerMediaTypeAudio ){
//                    self.mimeType = MIMETYPE_AUDIO;
//            }
//        }];
    }
    return self;
}



@end
