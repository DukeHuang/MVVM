//
//  CMComplaintViewModel.m
//  CM
//
//  Created by Duke on 1/19/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMComplaintViewModel.h"
#import "CMHttpManager+Compliant.h"
#import "CMDistrictDataModel.h"
#import "CMHttpSessionManager+File.h"
#import "CMUploadFileDataModel.h"
#import "CMUploadFileMTLModel.h"

@interface CMComplaintViewModel()

@property(nonatomic,strong,readwrite) RACSignal *validComplaintSignal;

@property(nonatomic,strong,readwrite) RACCommand *validComplaintCommand;


@property(nonatomic,strong,readwrite) RACCommand *complaintCommand;

@property(nonatomic,strong,readwrite) RACCommand *districtCommand;


@end

@implementation CMComplaintViewModel

-(void)initialize {
    [super initialize];
   
    
    self.dataModel0 = [[CMUploadFileDataModel alloc] init];
//    self.dataModel0.fileName = @"";
//    self.dataModel0.data = [[NSData alloc] init];
//    self.dataModel0.mimeType = @"";
    
    self.dataModel1 = [[CMUploadFileDataModel alloc] init];
//    self.dataModel1.fileName = @"";
//    self.dataModel1.data = [[NSData alloc] init];
//    self.dataModel1.mimeType = @"";
    
    self.dataModel2 = [[CMUploadFileDataModel alloc] init];
//    self.dataModel2.fileName = @"";
//    self.dataModel2.data = [[NSData alloc] init];
//    self.dataModel2.mimeType = @"";
    
    
    self.validComplaintCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [self checkoutInput];
    }];
    [self.validComplaintCommand.errors subscribe:self.errors];
    
    self.districtCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[[CMHttpManager sharedClient]
                getDistrictWithAccessToken:[SSKeychain accessToken]]  map:^id(CMDistrictMTLModel *model) {
            if (model.success) {
                NSMutableArray *arrArea = [[NSMutableArray alloc] init];
                NSMutableArray *arrAddress = [[NSMutableArray alloc] init];
                for (int i = 0; i < model.rows.count; i++) {
                    Rows *row = model.rows[i];
                    if (row.code.length == 6 || row.code.length == 9) {
                        [arrArea addObject:row];
                    } else {
                        [arrAddress addObject:row];
                    }
                }
                
                NSMutableArray<CMDistrictDataModel *> *dataArr = [[NSMutableArray alloc] init];
                for (int i = 0; i < arrArea.count; i++) {
                    Rows *rowArea = arrArea[i];
                    CMDistrictDataModel *dataModel = [CMDistrictDataModel new];
                    dataModel.area = rowArea;
                    if (rowArea.code.length != 6) {
                        for (int j = 0;  j < arrAddress.count; j++) {
                            Rows *rowAddress = arrAddress [j];
                            if ([rowAddress.code rangeOfString:rowArea.code].location != NSNotFound) {
                                [dataModel.addressArr addObject:rowAddress];
                            }
                        }
                    }
                    [dataArr addObject:dataModel];
                }
                return dataArr;
            }
            else {
                return nil;
            }
        }];
    }];
    
    RAC(self,districtArr) = [self.districtCommand.executionSignals switchToLatest];
    
    [self.districtCommand.errors subscribe:self.errors];
    
    self.uploadFileCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id x) {
        RACSignal *uploadSignal0 = [self.dataModel0.fileName isExist] ?[[[CMHttpSessionManager sharedClient] uploadFileWithToken:[SSKeychain qiniuToken] dateModel:self.dataModel0 index:1] doNext:^(UploadFileData *x) {
            if (x) {
                self.path0 = x.fileName;
                self.type0 = x.mimeType;
            }
        }] : [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            return nil;
        }];
        RACSignal *uploadSignal1 =[self.dataModel1.fileName isExist] ?[[[CMHttpSessionManager sharedClient] uploadFileWithToken:[SSKeychain qiniuToken] dateModel:self.dataModel1 index:2] doNext:^(UploadFileData *x) {
            if (x) {
                self.path1 = x.fileName;
                self.type1 = x.mimeType;
            }
            
            
        }] : [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            return nil;
        }];
        RACSignal *uploadSignal2 =[self.dataModel2.fileName isExist] ? [[[CMHttpSessionManager sharedClient] uploadFileWithToken:[SSKeychain qiniuToken] dateModel:self.dataModel2 index:3] doNext:^(UploadFileData *x) {
            if (x) {
                self.path2 = x.fileName;
                self.type2 = x.mimeType;
            }
        }] : [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            return nil;
        }];
        return  [RACSignal combineLatest:@[uploadSignal0,uploadSignal1,uploadSignal2]];
    }];
    
    [self.uploadFileCommand.errors subscribe:self.errors];
    
    RAC(self,districtCodeStr) = [RACObserve(self, titles) map:^NSString *(NSArray *titles) {
        if (titles.count == 2) {
            for (CMDistrictDataModel *district in self.districtArr) {
                if ([district.area.name isEqualToString:titles[0]]) {
                    if ([titles[1] isEqualToString:CMS_CHOOSE_AREA]) {
                        return district.area.code;
                    }
                    else {
                        for (Rows *district1 in district.addressArr ) {
                            //找到为止
                                if ([district1.name isEqualToString:titles[1]]) {
                                    return  district1.code;
                                }
                            }
                        }
                    }
                    
                }
            }
        return nil;
    }];
    
    self.complaintCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[CMHttpManager sharedClient] complaintWithAccessToken:[SSKeychain accessToken] title:self.complaintTitle date:self.date location:self.location districtCode:self.districtCodeStr matType0:self.type0 matPath0:self.path0 matType1:self.type1 matPath1:self.path1 matType2:self.type2 matPath2:self.path2 categoryCode:self.categoryCode content:self.content pName:self.pName pNo:self.pNo];
    }];
    [self.complaintCommand.errors subscribe:self.errors];

}

-(RACSignal *)checkoutInput {
    if (![self.complaintTitle isExist]) {
        RACSignal *validTitle = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:@"请输入标题"                                                                                                               };
            [subscriber sendError:[NSError errorWithDomain:@"" code:0 userInfo:userinfo]];
            return nil;
        }];
        return validTitle;
    }
    if (![self.date isExist]) {
        RACSignal *validTitle = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:@"请选择时间"                                                                                                               };
            [subscriber sendError:[NSError errorWithDomain:@"" code:0 userInfo:userinfo]];
            return nil;
        }];
        return validTitle;
    }
    if (![self.districtCodeStr isExist]) {
        RACSignal *validTitle = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:@"请选择社区和街道"                                                                                                               };
            [subscriber sendError:[NSError errorWithDomain:@"" code:0 userInfo:userinfo]];
            return nil;
        }];
        return validTitle;
    }
    if (![self.location isExist]) {
        RACSignal *validTitle = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:@"请输入具体位置"                                                                                                               };
            [subscriber sendError:[NSError errorWithDomain:@"" code:0 userInfo:userinfo]];
            return nil;
        }];
        return validTitle;
    }
    if (self.content.length < 6) {
        RACSignal *validTitle = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:@"输入内容少于6个字符"                                                                                                               };
            [subscriber sendError:[NSError errorWithDomain:@"" code:0 userInfo:userinfo]];
            return nil;
        }];
        return validTitle;
    }
    if (self.content.length > 100) {
        RACSignal *validTitle = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:@"输入内容超过100个字符"                                                                                                               };
            [subscriber sendError:[NSError errorWithDomain:@"" code:0 userInfo:userinfo]];
            return nil;
        }];
        return validTitle;
    }
    
    
    if (!([self.dataModel0.fileName isExist] || [self.dataModel1.fileName isExist] || [self.dataModel2.fileName isExist])) {
        RACSignal *validTitle = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSDictionary *userinfo = @{NSLocalizedFailureReasonErrorKey:@"至少选择一个材料"                                                                                                               };
            [subscriber sendError:[NSError errorWithDomain:@"" code:0 userInfo:userinfo]];
            return nil;
        }];
        return validTitle;
    }
    else {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@YES];
            [subscriber sendCompleted];
            return nil;
        }];
    }
}

@end
