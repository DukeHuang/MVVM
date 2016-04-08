//
//  CMComplaintViewModel.h
//  CM
//
//  Created by Duke on 1/19/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMViewModel.h"
#import "CMDistrictMTLModel.h"
#import "CMDistrictDataModel.h"
#import "CMUploadFileDataModel.h"


@interface CMComplaintViewModel : CMViewModel

@property(nonatomic,copy,readonly) NSString *complaintTitle;

@property(nonatomic,copy,readonly) NSString *content;

@property(nonatomic,copy) NSString *categoryCode;

@property(nonatomic,copy,readonly) NSString *date;

@property(nonatomic,copy,readonly) NSString *location;

//@property(nonatomic,copy,readonly) NSString *districtCode;

@property(nonatomic,copy,readonly) NSString *pName;

@property(nonatomic,copy,readonly) NSString *pNo;



@property(nonatomic,strong) CMUploadFileDataModel *dataModel0;
@property(nonatomic,strong) CMUploadFileDataModel *dataModel1;
@property(nonatomic,strong) CMUploadFileDataModel *dataModel2;


@property(nonatomic,copy,) NSString *type0;

@property(nonatomic,copy) NSString *path0;

@property(nonatomic,copy) NSString *type1;

@property(nonatomic,copy) NSString *path1;

@property(nonatomic,copy) NSString *type2;

@property(nonatomic,copy) NSString *path2;

//如果没有二级的，以一级的提交，如果有二级的，以二级的提交
@property (nonatomic,copy) NSString *districtCodeStr;


@property(nonatomic,strong)NSArray *titles;



@property(nonatomic,strong,readonly) RACSignal *validComplaintSignal;

@property(nonatomic,strong,readonly) RACCommand *validComplaintCommand;

@property(nonatomic,strong,readonly) RACCommand *complaintCommand;

@property(nonatomic,strong,readonly) RACCommand *districtCommand;

@property(nonatomic,strong) RACCommand *transformDistrictNameToDistrictCode;
@property(nonatomic,strong) RACCommand *uploadFileCommand;

@property (nonatomic,strong) NSMutableArray<CMDistrictDataModel *> *districtArr;
@end
