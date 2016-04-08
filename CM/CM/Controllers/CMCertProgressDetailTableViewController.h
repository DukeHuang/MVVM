//
//  CMCertProgressDetailTableViewController.h
//  CM
//
//  Created by Duke on 3/8/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMCertProgressMTLModel.h"

@interface CMCertProgressDetailTableViewController : UITableViewController
//@property (nonatomic,copy) NSString *desc;
@property (nonatomic, strong) CertProgress_Rows *rows;
@property (nonatomic, strong) NSArray<CertProgress_Mat *> *mat;
@end
