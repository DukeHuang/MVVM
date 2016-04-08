//
//  CMUserDefault.m
//  CM
//
//  Created by Duke on 1/26/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMUserDefault.h"

@implementation CMUserDefault
+(instancetype)sharedInstance {
    static CMUserDefault *userDefault = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userDefault = [[ self alloc] init];
    });
    return userDefault;
}

-(instancetype)init {
    if (self = [super init]) {
        self.user = [[User alloc] init];
        self.certCategoryModel = [[CMCertCategoryMTLModel alloc] init];
        self.urls = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)writeUserToPlist:(User *)user
{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    //找到Documents文件所在的路径
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //取得第一个Documents文件夹的路径
    
    NSString *filePath = [path objectAtIndex:0];
    
    //把TestPlist文件加入
    
    NSString *plistPath = [filePath stringByAppendingPathComponent:@"CMUserList.plist"];
    
    //开始创建文件
    
    if ([fm createFileAtPath:plistPath contents:nil attributes:nil]) {
        NSLog(@"创建成功");
    } else {
        NSLog(@"创建失败");
    }
    //删除文件
    
//    [fm removeItemAtPath:plistPath error:nil];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
    }
//    @property (nonatomic, copy) NSString *idCardNo;
//    
//    @property (nonatomic, copy) NSString *idCardImg1;
//    
//    @property (nonatomic, copy) NSString *idCardImg2;
//    
//    @property (nonatomic, assign) NSInteger user_id;
//    
//    @property (nonatomic, copy) NSString *regTime;
//    
//    @property (nonatomic, copy) NSString *verifyTime;
//    
//    @property (nonatomic, copy) NSString *realname;
//    
//    @property (nonatomic, copy) NSString *verifyStatus;
//    
//    @property (nonatomic, copy) NSString *phoneNumber;

    dic[@"idCardNo"] = user.idCardNo;
    dic[@"realname"] = user.realname;
    dic[@"verifyStatus"] = user.verifyStatus;
    dic[@"phoneNumber"] = user.phoneNumber;
    dic[@"verifyOpinion"] = user.verifyOpinion;
    dic[@"avatar"] = user.avatar;
    
    
    BOOL isSucces = [dic writeToFile:plistPath atomically:YES];
    if (isSucces) {
        NSLog(@"写入成功");
    }
    else {
        NSLog(@"写入失败");
    }
//    dic[@"idCardNo"] = user.idCardNo;
//    dic[@"idCardNo"] = user.idCardNo;
//    dic[@"idCardNo"] = user.idCardNo;
}
- (User *)readUserFromPlist {
//    NSFileManager *fm = [NSFileManager defaultManager];
    
    //找到Documents文件所在的路径
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //取得第一个Documents文件夹的路径
    
    NSString *filePath = [path objectAtIndex:0];
    
    //把TestPlist文件加入
    
    NSString *plistPath = [filePath stringByAppendingPathComponent:@"CMUserList.plist"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    User *user = [[User alloc] init];
    user.idCardNo = dic[@"idCardNo"];
    user.realname = dic[@"realname"];
    user.verifyStatus = dic[@"verifyStatus"] ;
    user.phoneNumber = dic[@"phoneNumber"] ;
    user.verifyOpinion = dic[@"verifyOpinion"];
    user.avatar = dic[@"avatar"];
    return user;
}
@end
