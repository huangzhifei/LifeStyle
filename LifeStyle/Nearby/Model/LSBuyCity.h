//
//  LSBuyCity.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/17.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSDistricts.h"

@interface LSBuyCity : NSObject

// 城市key
@property (strong, nonatomic) NSString *cityname;
// 区域列表 -> LSDistricts
@property (strong, nonatomic) NSMutableArray *districts;

@end
