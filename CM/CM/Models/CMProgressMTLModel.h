//
//  CMProgressMTLModel.h
//  CM
//
//  Created by Duke on 3/7/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import <Mantle/Mantle.h>

@class Progress_Rows,Mat;
@interface CMProgressMTLModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) BOOL success;

@property (nonatomic, strong) NSArray<Progress_Rows *> *rows;

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, copy)  NSString *msg;

@property (nonatomic, assign) NSInteger errorCode;



@end
@interface Progress_Rows : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) NSInteger row_id;

@property (nonatomic, copy) NSString *Progress;

@property (nonatomic, copy) NSString *districtCode;

@property (nonatomic, copy) NSString *complaintTime;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *location;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *lastCategoryCode;

@property (nonatomic, copy) NSString *categoryCode;

@property (nonatomic, copy) NSString *districtName;

@property (nonatomic, strong) NSArray<Mat *> *mat;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *rejectContent;

@property (nonatomic, copy) NSString *pName;

@property (nonatomic, copy) NSString *pNo;

@property (nonatomic, copy) NSString *feedbackContent;

@end

@interface Mat : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *matPath;

@property (nonatomic, assign) NSInteger mat_id;

@property (nonatomic, copy) NSString *matType;

@property (nonatomic, assign) NSInteger complaintId;

@end

