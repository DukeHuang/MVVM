//
//  CMUserDefault.h
//  CM
//
//  Created by Duke on 1/26/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMLoginModel.h"
#import "CMCertCategoryMTLModel.h"
#import "CMPublicInfoMTLModel.h"

@interface CMUserDefault : NSObject

+(instancetype)sharedInstance;

@property(nonatomic,strong) User *user;

@property(nonatomic,strong)NSMutableArray<PublicInfo_Rows*> *urls;

@property(nonatomic,strong) CMCertCategoryMTLModel *certCategoryModel;

- (void)writeUserToPlist:(User *)user;
- (User *)readUserFromPlist;


@end
