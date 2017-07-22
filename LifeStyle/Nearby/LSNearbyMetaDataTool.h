//
//  LSNearbyMetaDataTool.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/16.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSSingleton.h"
#import "LSCategory.h"
#import "LSLocationInfo.h"
#import "LSLocationTool.h"

@interface LSNearbyMetaDataTool : NSObject

LSSingleton_interface(LSNearbyMetaDataTool)
// 所有附近分类数据
@property (nonatomic, strong, readonly) NSArray *totalCategories;
// 所有的排序数据
@property (nonatomic, strong, readonly) NSArray *totalOrders;
// 所有城市区域数据(eg:深圳-宝安区-西乡)
@property (nonatomic, strong, readonly) NSArray *totalCitys;

// 当前选择的分类
@property (nonatomic, strong) LSCategory *currentCategory;

@property (nonatomic, strong) LSLocationInfo *locatInfo;

@property (nonatomic, strong) LSLocationTool *location;

@end
