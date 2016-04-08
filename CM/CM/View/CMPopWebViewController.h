//
//  CMPopWebViewController.h
//  CM
//
//  Created by Duke on 1/29/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMPopWebViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *canelButton;


@end
