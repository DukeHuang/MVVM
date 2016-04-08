//
//  CMConstant.h
//  CM
//
//  Created by Duke on 1/6/16.
//  Copyright © 2016 DU. All rights reserved.
//

#ifndef CMConstant_h
#define CMConstant_h
///------
/// Color
///------

#define RGB(r, g, b) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define RGBAlpha(r, g, b, a) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HexRGBAlpha(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define CM_COLOR_NAV  [UIColor colorWithRed:((18) / 255.0) green:((168) / 255.0) blue:((223) / 255.0) alpha:1.0]
#define CM_COLOR_GRAY  [UIColor colorWithRed:((248) / 255.0) green:((248) / 255.0) blue:((248) / 255.0) alpha:1.0]
///------
/// Size
///------
#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

///---------
/// App Info
///---------
#define CM_APP_NAME    ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"])
#define CM_APP_VERSION ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
#define CM_APP_BUILD   ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])

///------------
/// AppDelegate
///------------

#define CMAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
///------------
/// Storyboard
///------------
#define MainStoryboard [UIStoryboard storyboardWithName:@"Main" bundle:nil]
#define LoginRegisterStoryboard [UIStoryboard storyboardWithName:@"LoginRegister" bundle:nil]


///------------
/// identifier
///------------

#define IMainMenuToTabbar @"iMainMenuToTabbar"

///------------
/// Block
///------------
typedef void (^VoidBlock_id)(id);

///------
/// NSLog
///------

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

#define CMLogError(error) NSLog(@"Error: %@", error)

///-----------
/// SSKeychain
///-----------

#define MRC_SERVICE_NAME @"com.citymanage"
#define MRC_USERNAME     @"Username"
#define MRC_PASSWORD     @"Password"
#define MRC_ACCESS_TOKEN @"AccessToken"
//#define MRC_VERIFYSTATUS @"verifyStatus"
#define MRC_QINIU_TOKEN  @"QiniuToken"

#define MRC_USER @"User"


///-----------
/// errorCode
///-----------

#define INVALID_TOKEN 1001
#define INVALID_UP_TOKEN 1002



///-----------
/// MIMETYPE
///-----------

#define MIMETYPE_MP4 @"video/mp4"
#define MIMETYPE_PNG @"image/png"
#define MIMETYPE_AUDIO @"audio/mp3"
#define MIMITYPE_M4A @"aduio/m4a"

#endif /* CMConstant_h */
