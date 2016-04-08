//
//  CMHttpManager+Compliant.h
//  CM
//
//  Created by Duke on 1/20/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMHttpManager.h"

@interface CMHttpManager (Compliant)

- (RACSignal *)getDistrictWithAccessToken:(NSString *)accessToken;

- (RACSignal *)complaintWithAccessToken:(NSString *)accessToken
                                  title:(NSString *)title
                                   date:(NSString *)date
                               location:(NSString *)location
                           districtCode:(NSString *)districtCode
                               matType0:(NSString *)matType0
                               matPath0:(NSString *)matPath0
                               matType1:(NSString *)matType1
                               matPath1:(NSString *)matPath1
                               matType2:(NSString *)matType2
                               matPath2:(NSString *)matPath2
                           categoryCode:(NSString *)categoryCode
                                content:(NSString *)content
                                  pName:(NSString *)pName
                                    pNo:(NSString *)pNo;

- (RACSignal *)getComplaintWithAccessToken:(NSString *)accessToken
                                    offset:(int)offset
                                     limit:(int)limit
                              categoryCode:(NSString *)categoryCode;

-(RACSignal *)getPenaltyWithAccessToken:(NSString *)accessToken
                                 offset:(int)offset
                                  limit:(int)limit;

-(RACSignal *)getCerWithAccessToken:(NSString *)accessToken
                                 offset:(int)offset
                                  limit:(int)limit;
-(RACSignal *)getPenaltyDetailWithAccessToken:(NSString *)accessToken
                                    penaltyId:(NSString *)penaltyId;
-(RACSignal *)getComplaintDetailWithAccessToken:(NSString *)accessToken
                                    complaintId:(NSString *)complaintId;



@end
