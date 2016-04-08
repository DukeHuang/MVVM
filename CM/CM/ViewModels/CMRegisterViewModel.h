//
//  CMRegisterViewModel.h
//  CM
//
//  Created by Duke on 3/3/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMViewModel.h"

@interface CMRegisterViewModel : CMViewModel

@property(nonatomic,copy,readonly) NSString *phoneNum;

@property(nonatomic,copy,readonly) NSString *password;

@property(nonatomic,copy,readonly) NSString *rePassword;

@property(nonatomic,copy,readonly) NSString *verifyCode;

@property(nonatomic,strong,readonly) RACSignal *validPhone;

@property(nonatomic,strong,readonly) RACCommand *validRegisterCommand;

@property(nonatomic,strong,readonly) RACCommand *getVerifyCodeCommand;

@property(nonatomic,strong,readonly) RACCommand *registerCommand;

@property(nonatomic,strong,readonly) RACCommand *forgotPwdCommand;



@end
