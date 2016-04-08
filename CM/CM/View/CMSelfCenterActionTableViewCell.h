//
//  CMSelfCenterActionTableViewCell.h
//  CM
//
//  Created by Duke on 1/14/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMSelfCenterActionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *hasTips;

@end
