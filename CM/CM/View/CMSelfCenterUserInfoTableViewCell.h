//
//  CMSelfCenterUserInfoTableViewCell.h
//  CM
//
//  Created by Duke on 1/14/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMLoginModel.h"


@interface CMSelfCenterUserInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *hasPassImageView;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UIButton *reRegisterButton;
@property (weak, nonatomic) IBOutlet UILabel *waitLabel;
@property (weak, nonatomic) IBOutlet UIButton *iconButton;


-(void)configureCellWithUser:(User *)user;


@end
