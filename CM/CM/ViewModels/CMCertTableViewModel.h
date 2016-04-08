//
//  CMCertTableViewModel.h
//  CM
//
//  Created by Duke on 1/28/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMTableViewModel.h"
#import "CMBaseMenuDataModel.h"
#import "CMCertMatinfMTLModel.h"

@interface CMCertTableViewModel : CMTableViewModel

@property(nonatomic,strong)RACCommand *getCertMatinfoCommand;
@property(nonatomic,strong)RACCommand *upLoadFileCommand;

@property(nonatomic,strong)RACCommand *validupLoadAllFileCommand;
@property(nonatomic,strong)RACCommand *upLoadAllFileCommand;


@property(nonatomic,strong)RACCommand *downLoadFileCommand;

@property(nonatomic,strong)NSMutableArray<CertMatinfRows*> *upLoadArr;
@property(nonatomic,strong)NSMutableArray<CertMatinfRows*> *downloadArr;

@property(nonatomic,strong)CMBaseMenuDataModel *currentDataModel;
@property(nonatomic,strong)CMBaseMenuDataModel *preDataModel;

@property(nonatomic,assign)BOOL segmentSelectedFirst;


@end
