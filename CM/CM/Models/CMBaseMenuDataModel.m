//
//  CMBaseMenuDataModel.m
//  CM
//
//  Created by Duke on 1/19/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMBaseMenuDataModel.h"

@implementation CMBaseMenuDataModel

-(CMBaseMenuDataModel *)initWithCategoryCode:(NSString *)category
                                    menuType:(BASEMENUTYPE)menuType
                                        name:(NSString *)name
                                    iconName:(NSString *)iconName
                                   childMenu:(NSArray<CMBaseMenuDataModel *> *)childMenu
{
    if (self = [super init]) {
        self.categoryCode = category;
        self.name = name;
        self.iconName = iconName;
        self.childMenu = [childMenu copy];
        self.menuType = menuType;
    }
    return self;
}
@end
