//
//  CMLoginViewModel.h
//  CM
//
//  Created by Duke on 1/12/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMViewModel.h"

@interface CMLoginViewModel : CMViewModel

@property(nonatomic,copy,readonly) NSString *username;

@property(nonatomic,copy,readonly) NSString *password;

@property(nonatomic,strong,readonly) RACSignal *validLoginSignal;

@property(nonatomic,strong,readonly) RACCommand *loginCommand;

@property(nonatomic,strong,readonly) RACCommand *getCertCategroyCommand;

@property(nonatomic,strong,readonly) RACCommand *getUptokenCommand;
@end
