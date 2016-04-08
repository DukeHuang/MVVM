//
//  CMBaseMenuDataModel.h
//  CM
//
//  Created by Duke on 1/19/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum  BASEMENUTYPE  {
    NULLTYPE = -1,
    COMPLAINT = 0,
    SERVICE = 1,
    BID = 2,
    PUNISH = 3,
    NOTIFICATION = 4,
    
    
    COMPLAINT_BUILD = 10,//违法建筑投诉
    COMPLAINT_ZFHF = 11,//政风行风
    COMPLAINT_DZSZ = 12,//店招商招
    COMPLAINT_JDCX = 13,//进度查询
    COMPLAINT_HJWS = 14,//
    COMPLAINT_ZYWR = 15,//
    COMPLAINT_LHYL = 16,//
    COMPLAINT_SRSM = 17,
    
    CER_SL = 20,
    CER_MC = 21,
    CER_GG = 22,
    CER_ZP = 23,
    CER_ZT = 24,
    CER_JDCX = 25,
    
    SER_GONGCE = 30,//公厕查找
    SER_OTHERS = 31,//其他公共服务
    SER_CHENGGUANG = 32,//城管便民服务
    SER_LAJI = 33,//垃圾收运
    
    PUNISH_PROGRESS = 40,//处罚意见查询
    
}BASEMENUTYPE;

@interface CMBaseMenuDataModel : NSObject


@property(nonatomic,assign) BASEMENUTYPE menuType;
@property(nonatomic,copy) NSString *categoryCode;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *iconName;
@property(nonatomic,copy) NSString *tipsStr;
@property(nonatomic,strong) NSArray<CMBaseMenuDataModel*> *childMenu;


-(CMBaseMenuDataModel *)initWithCategoryCode:(NSString *)category
                                    menuType:(BASEMENUTYPE)menuType
                                        name:(NSString *)name
                                    iconName:(NSString *)iconName
                                   childMenu:(NSArray<CMBaseMenuDataModel *> *)childMenu;

@end
