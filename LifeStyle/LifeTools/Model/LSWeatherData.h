//
//  LSWeatherData.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/5.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LSIndexDetail;
@class LSWeatherDetail;

// json
@interface LSWeatherData : NSObject

// 城市
@property (strong, nonatomic) NSString *currentCity;
@property (strong, nonatomic) NSString *pm25;
// 日期
@property (strong, nonatomic) NSString *date;
// 细节信息
@property (nonatomic, strong) NSArray *index;
// 数据
@property (strong, nonatomic) NSArray  *weather_data;

@end

// detail suggest
@interface LSIndexDetail : NSObject
// 标题
@property (nonatomic, copy) NSString *title;
// 内容
@property (nonatomic, copy) NSString *zs;
// 指数
@property (nonatomic, copy) NSString *tipt;
// 细节
@property (nonatomic, copy) NSString *des;

@end

// detail weather
@interface LSWeatherDetail : NSObject
// 日期
@property (nonatomic, copy) NSString *date;
// 天气
@property (nonatomic, copy) NSString *weather;
// 风力
@property (nonatomic, copy) NSString *wind;
// 温度范围
@property (nonatomic, strong) NSString *temperature;

@end

