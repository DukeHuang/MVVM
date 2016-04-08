//
//  CMServiceTableViewCell.h
//  CM
//
//  Created by Duke on 2/19/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMServiceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *goThereButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton1;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeight;

@end
