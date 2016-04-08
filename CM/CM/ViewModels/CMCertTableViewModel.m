//
//  CMCertTableViewModel.m
//  CM
//
//  Created by Duke on 1/28/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMCertTableViewModel.h"
#import "CMHttpManager+Cert.h"
#import "CMCertMatinfMTLModel.h"
#import "CMHttpSessionManager+File.h"


@implementation CMCertTableViewModel

-(void)initialize {
    [super initialize];
    self.downloadArr = [NSMutableArray new];
    self.getCertMatinfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[[CMHttpManager sharedClient] getCertMatinfoWithAccessToken:[SSKeychain accessToken] categoryCode:self.currentDataModel.categoryCode] doNext:^(CMCertMatinfMTLModel *model) {
            self.upLoadArr = [model.rows copy];
            for (CertMatinfRows *cert in self.upLoadArr) {
                if ([cert.exPath isExist]) {
                    [self.downloadArr addObject:cert];
                }
            }
        }];
    }];
    
    [self.getCertMatinfoCommand.errors subscribe:self.errors];
    self.upLoadFileCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *tuple) {
        RACTupleUnpack(CMUploadFileDataModel *data,NSNumber *index) = tuple;
        return [[CMHttpSessionManager sharedClient] uploadFileWithToken:[SSKeychain qiniuToken] dateModel:data index:[index intValue]];
    }];
    
    self.validupLoadAllFileCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        for ( CertMatinfRows *certMatinf in self.upLoadArr) {
            if (![certMatinf.uploadFileName isExist]) {
                RACSignal *validTitle = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:@"请全部上传"                                                                                                               };
                    [subscriber sendError:[NSError errorWithDomain:@"" code:0 userInfo:userinfo]];
                    return nil;
                }];
                return validTitle;
//                return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//                    [subscriber sendNext:@NO];
//                    [subscriber sendCompleted];
//                    return nil;
//                }];
            }
        }
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@YES];
            [subscriber sendCompleted];
            return nil;
        }];
        
    }];
    
    [self.validupLoadAllFileCommand.errors subscribe:self.errors];
    self.upLoadAllFileCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[CMHttpManager sharedClient] uploadCertWithAccessToken:[SSKeychain accessToken]
                                                          categoryCode:self.currentDataModel.categoryCode
                                                             certArray:self.upLoadArr];
        
    }];
    
    self.downLoadFileCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *qiniuKey) {
        NSString *savePath = [NSString createDocumentsFileWithFloderName:@"download" fileName:@""];

        return [[CMHttpSessionManager sharedClient] downloadFileURL:qiniuKey savePath:savePath fileName:qiniuKey];
    }];
    [self.downLoadFileCommand.errors subscribe:self.errors];
    
}

@end
