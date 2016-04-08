//
//  CMUploadFileDataModel.h
//  CM
//
//  Created by Duke on 1/22/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <IQMediaPickerController.h>

@interface CMUploadFileDataModel : NSObject
//文件的命名
@property(nonatomic,copy) NSString *fileName;
//上传到后台的mimeType
@property(nonatomic,copy) NSString *mimeType;
//当前button点击后从哪选择
@property(nonatomic, assign) NSNumber *mediaType;
//文件的路径
@property(nonatomic,strong) NSURL *filePath;
//需要显示的图片,设置成button的图片
@property(nonatomic,strong) UIImage *image;

/**
 *   如果没有路径，就直接加载成data,只IQMediaPickerControllerMediaTypeIQMediaPickerControllerMediaTypePhotoLibrary时才需要，其他的直接返回路径，通过[formData appendPartWithFileURL:filePath name:@"image" error:nil]来上传nsdata,保证内存很小
 */
@property(nonatomic,strong) NSData *dataFromPhotoLibrary;

//-(instancetype)initWithmediaType:(IQMediaPickerControllerMediaType)mediaType
//                        filePath:(NSString *)filePath;




@end
