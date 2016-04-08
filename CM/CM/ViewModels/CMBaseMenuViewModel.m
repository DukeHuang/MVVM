//
//  CMBaseMenuViewModel.m
//  CM
//
//  Created by Duke on 1/15/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMBaseMenuViewModel.h"

@implementation CMBaseMenuViewModel

-(instancetype)initWithServices:(id<CMViewModelServices>)services params:(NSDictionary *)params{
    self = [super init];
    if (self) {
        if (params) {
            NSNumber *number =  [params objectForKey:@"tag"];
            if ([number integerValue] == 0 ) {
                self.menusArray = [self createComplaintDataModel];
            } else  if ([number integerValue] == 1){
                self.menusArray = [self createServiceDataModel];
            } else  if ([number integerValue] == 2){
                self.menusArray = [self createCertDataModel];
            } else if ([number integerValue] == 3){
                self.menusArray = [self createPenaltyDataModel];
            }
        }
        
        
    }
    return self;
}

-(NSArray<CMBaseMenuDataModel *> *)createComplaintDataModel {
    //环境卫生
    CMBaseMenuDataModel *model21 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"0201" menuType:NULLTYPE name:@"卫生死角类" iconName:nil childMenu:nil];
    CMBaseMenuDataModel *model22 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"0202" menuType:NULLTYPE name:@"生活垃圾焚烧类" iconName:nil childMenu:nil];
    CMBaseMenuDataModel *model23 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"0203" menuType:NULLTYPE name:@"垃圾中转站点扰民类" iconName:nil childMenu:nil];
    CMBaseMenuDataModel *model24 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"0204" menuType:NULLTYPE name:@"环卫车辆扰民类" iconName:nil childMenu:nil];
    CMBaseMenuDataModel *model25 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"0205" menuType:NULLTYPE name:@"生活垃圾收集类" iconName:nil childMenu:nil];
    CMBaseMenuDataModel *model26 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"0206" menuType:NULLTYPE name:@"区直管公厕管理类" iconName:nil childMenu:nil];
    CMBaseMenuDataModel *model2 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"02" menuType:COMPLAINT_HJWS name:@"环境卫生投诉" iconName:@"环境卫生" childMenu:@[model21,model22,model23,model24,model25,model26]];
    model2.tipsStr = @"1、机关、事业单位、小区院落等非公共区域内环卫保洁类问题不在受理范围。\n2、非公共区域内不在垃圾池、不在垃圾桶内的垃圾不负责清运。";
    //噪音污染
    CMBaseMenuDataModel *model31 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"0301" menuType:NULLTYPE name:@"无夜间施工许可证单位在22:00~06:00间建筑施工噪音投诉" iconName:nil childMenu:nil];
    CMBaseMenuDataModel *model32 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"0302" menuType:NULLTYPE name:@"商业经营活动噪音" iconName:nil childMenu:nil];
    CMBaseMenuDataModel *model3 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"03" menuType:COMPLAINT_ZYWR name:@"噪音污染投诉" iconName:@"噪音污染" childMenu:@[model31,model32]];
    model3.tipsStr = @"1、无夜间施工许可证单位在22:00~06:00间建筑施工噪音。\n2、商业经营活动噪音。提示：工业噪音、交通运输噪音、社会生活噪音（含广场舞、棋牌麻将、家庭装修、家用电器等噪音）不在受理范围。";
    //违法建筑
    CMBaseMenuDataModel *model4 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"04" menuType:COMPLAINT_BUILD name:@"违法建筑投诉" iconName:@"违法建筑" childMenu:nil];
    model4.tipsStr = @"";
    //绿化园林
    CMBaseMenuDataModel *model11 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"0101" menuType:NULLTYPE name:@"占用园林绿地" iconName:nil childMenu:nil];
    CMBaseMenuDataModel *model12 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"0102" menuType:NULLTYPE name:@"破坏绿地内植被" iconName:nil childMenu:nil];
    CMBaseMenuDataModel *model1 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"01" menuType:COMPLAINT_LHYL name:@"绿化园林投诉" iconName:@"绿化园林" childMenu:@[model11,model12]];
    model1.tipsStr = @"1、社会团体、机关、事业单位、居住小区等非公共区域内，不涉及行政许可（占用园林绿化、破坏绿地内植被）的绿化管理问题，不在受理范围内\n2，尚未移交给我区城管园林局管理的绿地，不在受理范围内";
    //市容市貌
    CMBaseMenuDataModel *model51 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"0501" menuType:NULLTYPE name:@"占道经营投诉" iconName:nil childMenu:nil];
    CMBaseMenuDataModel *model52 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"0502" menuType:NULLTYPE name:@"违规设置商招店招投诉" iconName:nil childMenu:nil];
    CMBaseMenuDataModel *model53 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"0503"  menuType:NULLTYPE name:@"流动商贩投诉" iconName:nil childMenu:nil];
    CMBaseMenuDataModel *model54 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"0504" menuType:NULLTYPE name:@"乱堆乱放投诉" iconName:nil childMenu:nil];
    CMBaseMenuDataModel *model5 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"05" menuType:COMPLAINT_SRSM name:@"市容市貌投诉" iconName:@"市容市貌" childMenu:@[model51,model52,model53,model54]];
    model5.tipsStr = @"1，非公共区域内上述问题不在受理范围。";
    //政风行风投诉
    CMBaseMenuDataModel *model6 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"06"  menuType:COMPLAINT_ZFHF name:@"政风行风投诉" iconName:@"政风行风" childMenu:nil];
    model6.tipsStr = @"用于投诉金牛区城管园林局所属工作人员在行政和执法工作中存在的违法违规行为";
    //店招商招
    CMBaseMenuDataModel *model7 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"07" menuType:COMPLAINT_DZSZ name:@"商招店招投诉" iconName:@"商招店招" childMenu:nil];
    model7.tipsStr = @"1、受理公共区域内及临街立面存在的违规设置商招店招、LED屏、广告布幅等问题，主要包含一店多招、招牌污损和超大超宽、设置存在安全隐患等问题类型。\n2、机关、事业单位、小区院落等非公共区域内上述问题不在受理范围。";
    //投诉进度查询
    CMBaseMenuDataModel *model8 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"08" menuType:COMPLAINT_JDCX name:@"投诉进度查询" iconName:@"进度" childMenu:nil];
    //更多
    CMBaseMenuDataModel *model9 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:nil menuType:NULLTYPE name:@"更多待开放中" iconName:@"更多" childMenu:nil];
    return @[model2,model3,model4,model1,model5,model6,model7,model8,model9];
}
-(NSArray<CMBaseMenuDataModel *> *)createCertDataModel {
    //环境卫生
    CMBaseMenuDataModel *model1 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"02" menuType:CER_SL name:@"森林类" iconName:@"森林类" childMenu:nil];
    CMBaseMenuDataModel *model11 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"0201" menuType:NULLTYPE name:@"森林植物检疫证书" iconName:@"" childMenu:nil];
    CMBaseMenuDataModel *model12 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"0202" menuType:NULLTYPE name:@"征占用林地审批" iconName:@"" childMenu:nil];
    CMBaseMenuDataModel *model13 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"0203" menuType:NULLTYPE name:@"绿地率指标审批" iconName:@"" childMenu:nil];
    CMBaseMenuDataModel *model14 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"0204" menuType:NULLTYPE name:@"陆生野生动物驯养繁殖许可证" iconName:@"" childMenu:nil];
    CMBaseMenuDataModel *model15 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"0205" menuType:NULLTYPE name:@"陆生野生动物出售.收购.利用.加工.转让许可证" iconName:@"" childMenu:nil];
    model1.childMenu = @[model11,model12,model13,model14,model15];
    
    CMBaseMenuDataModel *model2 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"01" menuType:CER_MC name:@"木材类" iconName:@"木材类" childMenu:nil];
    CMBaseMenuDataModel *model21 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"0101" menuType:NULLTYPE name:@"木材运输证" iconName:@"" childMenu:nil];
    CMBaseMenuDataModel *model22 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"0102" menuType:NULLTYPE name:@"木材加工企业及其它木竹材经营企业的设立、扩建或变更名称、场地、法人代表的核准、审核办事指南" iconName:@"" childMenu:nil];
    CMBaseMenuDataModel *model23 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"0103" menuType:NULLTYPE name:@"林木采伐许可证" iconName:@"" childMenu:nil];
    CMBaseMenuDataModel *model24 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"0104" menuType:NULLTYPE name:@"砍伐、移植树木许可证" iconName:@"" childMenu:nil];
    model2.childMenu = @[model21,model22,model23,model24];
    
    CMBaseMenuDataModel *model3 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"03" menuType:CER_GG name:@"广告类" iconName:@"广告类" childMenu:nil];
    CMBaseMenuDataModel *model31 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"0301" menuType:NULLTYPE name:@"临时户外广告设置许可审批" iconName:@"" childMenu:nil];
    model3.childMenu = @[model31];
    
    CMBaseMenuDataModel *model4 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"04" menuType:CER_ZP name:@"招牌类" iconName:@"招牌类" childMenu:nil];
    CMBaseMenuDataModel *model41 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"0401" menuType:NULLTYPE name:@"招牌设置许可" iconName:@"" childMenu:nil];
    model4.childMenu = @[model41];
    
    CMBaseMenuDataModel *model5 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"05" menuType:CER_ZT name:@"渣土类" iconName:@"渣土类" childMenu:nil];
    CMBaseMenuDataModel *model51 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"0401" menuType:NULLTYPE name:@"建筑垃圾处置许可证" iconName:@"" childMenu:nil];
    model5.childMenu = @[model51];
    
    CMBaseMenuDataModel *model6 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"06" menuType:CER_JDCX name:@"申办进度查询" iconName:@"进度" childMenu:nil];
    CMBaseMenuDataModel *model7 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"" menuType:NULLTYPE name:@"更多待开放中" iconName:@"更多" childMenu:nil];
    
    return @[model1,model2,model3,model4,model5,model6,model7];
}
-(NSArray<CMBaseMenuDataModel *> *)createServiceDataModel {
    CMBaseMenuDataModel *model1 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"02" menuType:SER_GONGCE name:@"公厕查找" iconName:@"公厕查找" childMenu:nil];
    CMBaseMenuDataModel *model2 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"04" menuType:SER_OTHERS name:@"公园查找" iconName:@"公园查找" childMenu:nil];
    CMBaseMenuDataModel *model3 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"03" menuType:SER_CHENGGUANG name:@" 城管工作机构" iconName:@"城管便民服务点" childMenu:nil];
    CMBaseMenuDataModel *model4 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"01" menuType:SER_LAJI name:@"垃圾收运" iconName:@"垃圾收运" childMenu:nil];
    CMBaseMenuDataModel *model41 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"0101" menuType:NULLTYPE name:@"大件生活垃圾收运" iconName:@"" childMenu:nil];
     model41.tipsStr = @"1.生活垃圾包含废旧家具等大件物品，须由用户自行放置在垃圾池、垃圾桶点或垃圾定点收集处，方可收运。2.建筑垃圾等非生活垃圾不在收运范围内。3.按期缴纳过垃圾处理费用的用户，上述所有服务不再收费。";
//    CMBaseMenuDataModel *model42 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"0102" menuType:NULLTYPE name:@"餐厨垃圾收运" iconName:@"" childMenu:nil];
    model4.childMenu = @[model41];
    CMBaseMenuDataModel *model5 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"" menuType:NULLTYPE name:@"更多待开放中" iconName:@"更多" childMenu:nil];
    
    return @[model1,model2,model3,model4,model5];
}
-(NSArray<CMBaseMenuDataModel *> *)createPenaltyDataModel {
    CMBaseMenuDataModel *model1 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"01" menuType:PUNISH_PROGRESS name:@"处罚意见查询" iconName:@"处罚意见" childMenu:nil];
    CMBaseMenuDataModel *model2 = [[CMBaseMenuDataModel alloc] initWithCategoryCode:@"" menuType:NULLTYPE name:@"更多待开放中" iconName:@"更多" childMenu:nil];
    return @[model1,model2];
}


@end
