//
//  CMHttpManager+Cert.h
//  CM
//
//  Created by Duke on 1/28/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMHttpManager.h"
#import "CMCertMatinfMTLModel.h"

@interface CMHttpManager (Cert)

- (RACSignal *)getCertCategory;

- (RACSignal *)getCertMatinfoWithAccessToken:(NSString *)accessToken
                                categoryCode:(NSString *)categoryCode;

- (RACSignal *)uploadCertWithAccessToken:(NSString *)accessToken
                            categoryCode:(NSString *)categoryCode
                               certArray:(NSMutableArray <CertMatinfRows *> *)arr;
- (RACSignal *)getCertDetailWithAccessToken:(NSString *)accessToken certId:(NSString *)certId ;

@end
