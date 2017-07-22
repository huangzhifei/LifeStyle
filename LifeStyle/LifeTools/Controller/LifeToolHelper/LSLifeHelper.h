//
//  LSLifeHelper.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/7.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  网络请求，http获取数据辅助类
 */
@interface LSLifeHelper : NSObject



//天气 - 城市
+ (void)weatherDataWithCityName:(NSString *)cityName
                        success:(void (^)(id json))success
                        failure:(void (^)(NSError *error))failure
                timeoutInterval:(NSTimeInterval)timeoutInterval;

// ----- 日常
// 身份证查询 - 身份证号
+ (void)identityDataWithIDCard:(NSString *)IDCard
                        success:(void (^)(id json))success
                       failure:(void (^)(NSError *error))failure
               timeoutInterval:(NSTimeInterval)timeoutInterval;

// 邮编查询  - 城市名 & areid=0
+ (void)postCodeDataWithCity:(NSString *)City
                       success:(void (^)(id json))success
                       failure:(void (^)(NSError *error))failure
             timeoutInterval:(NSTimeInterval)timeoutInterval;

// IP地址查询 - ip号
+ (void)ipDataWithPICode:(NSString *)ipCode
                     success:(void (^)(id json))success
                     failure:(void (^)(NSError *error))failure
         timeoutInterval:(NSTimeInterval)timeoutInterval;

// 快递查询  - 快递公司代号&快递号
+ (void)expressDataWithNum:(NSString *)expressName
                       num:(NSString *)expressCode
                   success:(void (^)(id json))success
                   failure:(void (^)(NSError *error))failure
           timeoutInterval:(NSTimeInterval)timeoutInterval;

// 手机归属地 - 手机号码
+ (void)telephoneDataWithNum:(NSString *)telephone
              success:(void (^)(id json))success
              failure:(void (^)(NSError *error))failure
             timeoutInterval:(NSTimeInterval)timeoutInterval;

// 苹果序列号  - 序列号
+ (void)appleIMEIDataWithSN:(NSString *)appleIMEI
                   success:(void (^)(id json))success
                   failure:(void (^)(NSError *error))failure
            timeoutInterval:(NSTimeInterval)timeoutInterval;

// ----- 出行
// 油价查询 - 省名或直辖市
+ (void)oilPriceDataWithCity:(NSString *)city
                     success:(void (^)(id json))success
                     failure:(void (^)(NSError *error))failure
             timeoutInterval:(NSTimeInterval)timeoutInterval;

// ----- 车辆限行情况
+ (void)trafficLimitDataWithCity:(NSString *)city
                            date:(NSString *)checkDate
                     success:(void (^)(id json))success
                     failure:(void (^)(NSError *error))failure
             timeoutInterval:(NSTimeInterval)timeoutInterval;

// 长途汽车查询 - 起点城市名 ： 终点城市名
+ (void)coachDataWithName:(NSString *)fromCity
                       to:(NSString *)toCity
                  success:(void (^)(id json))success
                  failure:(void (^)(NSError *error))failure
          timeoutInterval:(NSTimeInterval)timeoutInterval;

// ----- 城市公交车 - 暂时不做

// -----货款
// 货币汇率
+ (void)currencyDataWithName:(NSString *)fromCurrency
                       to:(NSString *)toCurrency
                   amount:(NSString *)amount
                  success:(void (^)(id json))success
                  failure:(void (^)(NSError *error))failure
          timeoutInterval:(NSTimeInterval)timeoutInterval;

// 房贷计算

// 税收计算

// ----- 理财

// 银行卡模糊查询

// 网易彩票



@end
