//
//  LSNearbyHttpTool.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/18.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSSingleton.h"

@class LSDeal;

// deals里面装的都是模型数据
typedef void (^DealsSuccessBlock)(NSArray *deals, int totalCount);

typedef void (^DealsErrorBlock)(NSError *error);

// deal里面装的都是模型数据
typedef void (^DealSuccessBlock)(LSDeal *deal);

typedef void (^DealErrorBlock)(NSError *error);

typedef void (^RequestBlock)(id result, NSError *errorObj);


@interface LSNearbyHttpTool : NSObject

LSSingleton_interface(LSNearbyHttpTool)

// 基本封装
- (void)requestWithURL:(NSString *)url params:(NSMutableDictionary *)params block:(RequestBlock)block;

// 获得第page页的团购数据
- (void)dealsWithPage:(int)page district:(NSString *)district category:(NSString *)category orderIndext:(NSInteger)orderIndext success:(DealsSuccessBlock)success error:(DealsErrorBlock)error;

// 获得指定团购数据
- (void)dealWithID:(NSString *)ID success:(DealSuccessBlock)success error:(DealErrorBlock)error;

// 获得周边团购数据
- (void)dealsWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude success:(DealsSuccessBlock)success error:(DealsErrorBlock)error;

@end
