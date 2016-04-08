//
//  CMLoginViewModel.m
//  CM
//
//  Created by Duke on 1/12/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMLoginViewModel.h"
#import "CMHttpManager+Login.h"
#import "CMLoginModel.h"
#import "CMHttpSessionManager+File.h"
#import "CMUserDefault.h"
#import "CMHttpManager+Cert.h"

@interface CMLoginViewModel()

@property(nonatomic,strong,readwrite) RACSignal *validLoginSignal;

@property(nonatomic,strong,readwrite) RACCommand *loginCommand;

@property(nonatomic,strong,readwrite) RACCommand *getCertCategroyCommand;

@property(nonatomic,strong,readwrite) RACCommand *getUptokenCommand;

@end


@implementation CMLoginViewModel

- (void)initialize {
    [super initialize];
    @weakify(self)
    self.validLoginSignal = [[RACSignal
                             combineLatest:@[RACObserve(self, username),RACObserve(self, password)]
                             reduce:^(NSString *username,NSString *password){
                                 return @(username.length > 0 && password.length > 0);
                             }]
                             distinctUntilChanged];
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [[[[CMHttpManager sharedClient]loginWithUsername:self.username
                                                     password:self.password] doNext:^(id x) {
            if (x) {
                CMLoginModel *model = x;
                [SSKeychain setAccessToken:model.data.accessToken];
                [SSKeychain setUsername:self.username];
                [SSKeychain setPassword:self.password];
                [[CMUserDefault sharedInstance] writeUserToPlist:model.data.user];
            }
            
        }]
        doError:^(NSError *error) {
            if (error.code == 0) {
                [SSKeychain deletePassword];
            }
        }];
    }];
    [self.loginCommand.errors subscribe:self.errors];
    
    self.getCertCategroyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[CMHttpManager sharedClient] getCertCategory];
    }];
    
//    self.getUptokenCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        return [[CMHttpManager sharedClient] getupToken:[SSKeychain accessToken]];
//    }];
    self.getUptokenCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[CMHttpManager sharedClient] getupToken:[SSKeychain accessToken]];
    }];
}

@end
