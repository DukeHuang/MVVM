//
//  CMPopWebViewController.m
//  CM
//
//  Created by Duke on 1/29/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMPopWebViewController.h"

@interface CMPopWebViewController ()

@end

@implementation CMPopWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.doneButton setCornerRadius];
    [self.canelButton setCornerRadius];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
