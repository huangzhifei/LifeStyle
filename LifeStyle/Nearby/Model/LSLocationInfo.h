//
//  LSLocationInfo.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/17.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSLocationInfo : NSObject

// 国家
@property (strong, nonatomic) NSString *Country;

// 城市
@property (strong, nonatomic) NSString *City;

// 详细地地址
@property (strong, nonatomic) NSArray *FormattedAddressLines;

// 省
@property (strong, nonatomic) NSString *State;

// 街道
@property (strong, nonatomic) NSString *Street;

// 区域
@property (strong, nonatomic) NSString *SubLocality;

// 大道
@property (strong, nonatomic) NSString *Thoroughfare;

// 纬度
@property (assign, nonatomic) CGFloat latitude;

// 经度
@property (assign, nonatomic) CGFloat longitude;

@end
