//
//  CMUploadTableViewCell.h
//  CM
//
//  Created by Duke on 1/29/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMUploadTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;

@end
