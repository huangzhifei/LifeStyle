//
//  LSCityListCellDelegate.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/6.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LSCityInfo;

@protocol LSCityGroupCellDelegate <NSObject>

@required

- (void)cityGroupCellDidSelectCity:(NSString *)cityName;

@end
