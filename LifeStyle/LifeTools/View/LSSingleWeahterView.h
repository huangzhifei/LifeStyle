//
//  LSSingleWeahterView.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/14.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSWeatherData.h"

@interface LSSingleWeahterView : UIView

+ (instancetype) loadDIY;

@property(strong, nonatomic) LSWeatherDetail *wdetail;

@end
