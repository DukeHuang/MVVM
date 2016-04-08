//
//  CMFeedbackViewModel.h
//  CM
//
//  Created by Duke on 3/11/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMViewModel.h"

@interface CMFeedbackViewModel : CMViewModel
@property (nonatomic,strong)RACCommand *feedbackCommand;
@property (nonatomic,copy)NSString *contentStr;
@end
