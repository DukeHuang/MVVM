//
//  CMSelfCenterUserInfoTableViewCell.m
//  CM
//
//  Created by Duke on 1/14/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMSelfCenterUserInfoTableViewCell.h"
#import "CMHttpSessionManager+File.h"

@implementation CMSelfCenterUserInfoTableViewCell
- (void)awakeFromNib {
    
}

-(void)configureCellWithUser:(User *)user {
//    [self.logo sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"hd"]];
    NSString *savePath = [NSString createDocumentsFileWithFloderName:@"download" fileName:@""];
    NSString *qiniuKey = user.avatar;
     [[[[CMHttpSessionManager sharedClient] downloadFileURL:qiniuKey savePath:savePath fileName:qiniuKey] deliverOnMainThread] subscribeNext:^(id x) {
        NSString *path = [NSString createDocumentsFileWithFloderName:@"download" fileName:qiniuKey];
//         [self.logo setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:path]]];
//         self.logo.layer.borderColor  = [UIColor whiteColor].CGColor;
//         self.logo.layer.borderWidth  = 1;
//         self.logo.layer.cornerRadius = CGRectGetWidth(self.logo.frame) / 2;
//         self.logo.contentMode = UIViewContentModeScaleAspectFill;
         [self.logo setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:path]]];
         self.logo.layer.shouldRasterize = YES;
         self.logo.layer.rasterizationScale = self.logo.window.screen.scale;
//         [self.logo setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:path]]]];
     }];
    self.name.text = user.realname;
    self.idLabel.text = user.idCardNo;
    [self.reRegisterButton setTitle:@"完善资料" forState:UIControlStateNormal];
//    审核状态0待审核；1通过；2未通过
    if ([user.verifyStatus isEqualToString:@"1"])
    {
        self.hasPassImageView.image = [UIImage imageNamed:@"verify_pass"];
        self.reRegisterButton.hidden = YES;
        self.waitLabel.hidden = YES;

    } else if ([user.verifyStatus isEqualToString:@"2"]){
        self.hasPassImageView.image = [UIImage imageNamed:@"verify_no_pass"];
        self.waitLabel.text = user.verifyOpinion;
        self.waitLabel.hidden = NO;

        self.reRegisterButton.hidden = NO;
    } else {
        self.hasPassImageView.hidden = YES;
        self.reRegisterButton.hidden = NO;
        self.waitLabel.text = @"等待审核";
        self.waitLabel.hidden = NO;
    }
    
    
    
}
@end
