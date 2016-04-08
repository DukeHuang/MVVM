//
//  CMSelfCenterTableViewModel.m
//  CM
//
//  Created by Duke on 1/14/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMSelfCenterTableViewModel.h"
#import "CMHttpManager+SelfCenter.h"
#import "CMSelfCenterCell.h"
#import "NSString+Util.h"
#import "CMHttpManager+Login.h"
#import "CMHttpSessionManager.h"
#import "CMHttpSessionManager+File.h"

@implementation CMSelfCenterTableViewModel

- (void)initialize {
    [super initialize];
    self.title = @"个人中心";
    
    CMSelfCenterCell *report = [[CMSelfCenterCell alloc] init];
    report.iconName = @"myreport";
    report.title = @"我的投诉";
    report.hasTips = NO;
    
    CMSelfCenterCell *bid = [[CMSelfCenterCell alloc] init];
    bid.iconName = @"mybid";
    bid.title = @"我的证件申办";
    bid.hasTips = NO;
    
    CMSelfCenterCell *pulishment = [[CMSelfCenterCell alloc] init];
    pulishment.iconName = @"mypulishment";
    pulishment.title = @"我的行政处罚";
    pulishment.hasTips = NO;
    
    CMSelfCenterCell *message = [[CMSelfCenterCell alloc] init];
    message.iconName = @"ms";
    message.title = @"我的消息";
    message.hasTips = NO;
    
    CMSelfCenterCell *password = [[CMSelfCenterCell alloc] init];
    password.iconName = @"pw";
    password.title = @"修改密码";
    password.hasTips = NO;
    
    
//    self.passArr = @[@[@""],@[report,bid,pulishment],@[message],@[password],@[@""]];
//    self.noPassArr = @[@[@""],@[report,bid,pulishment],@[message]];
    
    @weakify(self)
    self.userNewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [[[[CMHttpManager sharedClient] getUserNewWithAccessToken:[SSKeychain accessToken]]
        doNext:^(id x) {
            self.userNewModel = x;
        }]
        doError:^(NSError *error) {
            ;
        }];
    }];
    [self.userNewCommand.errors subscribe:self.errors];
    
    self.getProfileCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[CMHttpManager sharedClient] getProfileWithAccessToken:[SSKeychain accessToken]];
    }];
    [self.getProfileCommand.errors subscribe:self.errors];
    [RACObserve(self, userNewModel.data)  subscribeNext:^(CMUserNewData *data) {
        @strongify(self)
        report.hasTips = data.complaint > 0;
        message.hasTips = data.msg > 0;
        pulishment.hasTips = data.penalty > 0;
        bid.hasTips = data.cert > 0;
        self.passArr = @[@[@""],@[report,bid,pulishment],@[message],@[password],@[@""]];
        self.noPassArr = @[@[@""],@[report,bid,pulishment],@[message]];
    }];
    RAC(self,isPass) = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        BOOL b = [SSKeychain accessToken].isExist;
        [subscriber sendNext:b?@YES:@NO];
        return [RACDisposable disposableWithBlock:^{
        }];
    }];
    
    self.upLoadFileCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *tuple) {
        RACTupleUnpack(CMUploadFileDataModel *data,NSNumber *index) = tuple;
        return [[CMHttpSessionManager sharedClient] uploadFileWithToken:[SSKeychain qiniuToken] dateModel:data index:[index intValue]];
    }];
    [self.upLoadFileCommand.errors subscribe:self.errors];
    
    self.profileOtherCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[CMHttpManager sharedClient] profileOtherWithAccessToken:[SSKeychain accessToken] avatar:self.uploadFileName];
    }];
    [self.profileOtherCommand.errors subscribe:self.errors];
}

@end
