//
//  LSCoachDetailItem.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/11.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSCoachDetailItem : NSObject

@property (strong, nonatomic) NSString *startCity;
@property (strong, nonatomic) NSString *endCity;
@property (strong, nonatomic) NSString *startStation;
@property (strong, nonatomic) NSString *endStation;
@property (strong, nonatomic) NSString *departureTime;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *busType;
@property (strong, nonatomic) NSString *distance;

@end
