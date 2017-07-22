//
//  LSWeatherData.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/5.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSWeatherData.h"

@implementation LSWeatherData

- (NSDictionary *)objectClassInArray
{
    return @{
                @"index": @"LSIndexDetail",
                @"weather_data": @"LSWeatherDetail class"
            };
}

@end


@implementation LSIndexDetail

@end


@implementation LSWeatherDetail

@end