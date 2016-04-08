//
//  CMChangePwdViewModel.h
//  CM
//
//  Created by Duke on 3/15/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMViewModel.h"

@interface CMChangePwdViewModel : CMViewModel

@property(nonatomic,copy,readonly) NSString *oldPassword;

@property(nonatomic,copy,readonly) NSString *theNewPassword;

@property(nonatomic,copy,readonly) NSString *reNewPassword;

@property(nonatomic,strong,readonly) RACCommand *validPasswordCommand;

@property(nonatomic,strong,readonly) RACCommand *changePasswordCommand;


@end
