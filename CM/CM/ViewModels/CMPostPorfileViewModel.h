//
//  CMPostPorfileViewModel.h
//  CM
//
//  Created by Duke on 3/4/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMViewModel.h"

@interface CMPostPorfileViewModel : CMViewModel

@property(nonatomic,copy) NSString *accessToken;

@property(nonatomic,copy,readonly) NSString *realname;

@property(nonatomic,copy,readonly) NSString *idCardNo;

@property(nonatomic,copy,readonly) NSString *idCardImg1;

@property(nonatomic,copy,readonly) NSString *idCardImg2;

@property(nonatomic,strong) UIImage *idCardImage1;
@property(nonatomic,strong) UIImage *idCardImage2;

@property(nonatomic,strong,readonly) RACCommand *validPostCommand;

@property(nonatomic,strong,readonly) RACCommand *postProfileCommand;

@property(nonatomic,strong,readonly) RACCommand *getUpTokenCommand;

@property(nonatomic,strong,readonly) RACCommand *uploadFileCommand;

@end
