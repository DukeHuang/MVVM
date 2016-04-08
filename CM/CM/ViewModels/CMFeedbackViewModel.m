//
//  CMFeedbackViewModel.m
//  CM
//
//  Created by Duke on 3/11/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMFeedbackViewModel.h"
#import "CMHttpManager+PublicInfo.h"

@implementation CMFeedbackViewModel


- (void)initialize {
    [super initialize];
    self.feedbackCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[CMHttpManager sharedClient] feedbackWithAccessToken:[SSKeychain accessToken] content:self.contentStr];
    }];
    [self.feedbackCommand.errors subscribe:self.errors];
}
@end
