//
//  CMSelfCenterTableViewModel.h
//  CM
//
//  Created by Duke on 1/14/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMTableViewModel.h"
#import "CMUserNewModel.h"

@interface CMSelfCenterTableViewModel : CMTableViewModel

@property (nonatomic, strong) RACCommand *userNewCommand;
@property (nonatomic, strong) RACCommand *getProfileCommand;
@property (nonatomic, strong) CMUserNewModel *userNewModel;
@property (nonatomic,assign) BOOL isPass;
@property (nonatomic, strong) NSArray *passArr;
@property (nonatomic, strong) NSArray *noPassArr;
@property (nonatomic, strong) NSString *uploadFileName;
@property (nonatomic,strong)RACCommand *upLoadFileCommand;
@property (nonatomic,strong)RACCommand *profileOtherCommand;


@end
