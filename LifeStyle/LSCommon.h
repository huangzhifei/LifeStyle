//
//  LSCommon.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/4.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#ifndef LSCommon_h
#define LSCommon_h

//block
#define weakify(var) __weak typeof(var) HZFWeak_##var = var;
#define strongify(var) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong typeof(var) var = HZFWeak_##var; \
_Pragma("clang diagnostic pop")

//log
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else //release
#define NSLog(...)
#define debugMethod()
#endif

#define kPath_Of_App_Home    NSHomeDirectory()
#define kPath_Of_Temp        NSTemporaryDirectory()
#define kPath_Of_Document    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define kScreen                 [UIScreen mainScreen].bounds
#define kScreenWidth            [UIScreen mainScreen].bounds.size.width
#define kScreenHeight           [UIScreen mainScreen].bounds.size.height
#define kStatusBarHeight        [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavigationBarHeight    44
#define kLayoutCell             80

// RGB Color
#define LSColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

// color
#define kCollectionBkgColor    LSColor(240, 255, 255, 1)
#define kCollectionHeaderColor LSColor(20, 61, 66, 1)
#define kCollectionTopHeaderColor LSColor(41, 42, 42, 1)
#define kLocationNote @"location_Note"
// key
#define APIStoreKey             @"ddca128a51501ff5f01fb5246b796b2c"
#define APIStoreKeyTest         @"0aa41a9af51dad5c24de877f77ccd017"
#define kDPAppKey               @"902353788"
#define kDPAppSecret            @"9146c3fba4464c5ca7200808923d35a3"

#endif /* LSCommon_h */
