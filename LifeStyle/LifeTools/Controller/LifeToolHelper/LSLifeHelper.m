//
//  LSLifeHelper.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/7.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSLifeHelper.h"
#import "LSHttpTool.h"

#define IDCardUrl       @"http://apis.baidu.com/apistore/idservice/id"
#define PostCodeUrl     @"http://apis.baidu.com/netpopo/zipcode/addr2code"
#define IPUrl           @"http://apis.baidu.com/apistore/iplookupservice/iplookup"
#define ExpressUrl      @"http://apis.baidu.com/netpopo/express/express1"
#define TelephoneUrl    @"http://apis.baidu.com/apistore/mobilenumber/mobilenumber"
#define AppleSNUrl      @"http://apis.baidu.com/3023/apple/apple"
#define CoachUrl        @"http://apis.baidu.com/netpopo/bus/city2c"
#define OilPriceUrl     @"http://apis.baidu.com/showapi_open_bus/oil_price/find"
#define LimitUrl        @"http://apis.baidu.com/netpopo/vehiclelimit/query"
#define CurrencyUrl     @"http://apis.baidu.com/apistore/currencyservice/currency"
#define WeatherUrl      @"http://api.map.baidu.com/telematics/v3/weather"
#define weatherKey     @"FK9mkfdQsloEngodbFl4FeY3"

@implementation LSLifeHelper

//天气
+ (void)weatherDataWithCityName:(NSString *)cityName
                        success:(void (^)(id json))success
                        failure:(void (^)(NSError *error))failure
                timeoutInterval:(NSTimeInterval)timeoutInterval
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:cityName forKey:@"location"];
    [paramDict setObject:weatherKey forKey:@"ak"];
    [paramDict setObject:@"json" forKey:@"output"];
    
    LSHttpTool *httpTool = [LSHttpTool sharedInstance];
    httpTool.requestSerializer.timeoutInterval = timeoutInterval;
    
    [httpTool getWithURL:WeatherUrl params:paramDict success:^(id json) {
        
        if( success )
        {
            success(json);
        }
        
    } failure:^(NSError *error) {
        
        if( failure )
        {
            failure(error);
        }
        
    }];
}

// ----- 日常
// 身份证查询 - 身份证号
+ (void)identityDataWithIDCard:(NSString *)IDCard
                       success:(void (^)(id json))success
                       failure:(void (^)(NSError *error))failure
               timeoutInterval:(NSTimeInterval)timeoutInterval
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:IDCard forKey:@"id"];
    
    LSHttpTool *httpTool = [LSHttpTool sharedInstance];
    httpTool.requestSerializer.timeoutInterval = timeoutInterval;
    
    [httpTool getWithURL:IDCardUrl params:paramDict success:^(id json) {
        
        if( success )
        {
            success(json);
        }
        
    } failure:^(NSError *error) {
        
        if( failure )
        {
            failure(error);
        }
        
    }];
}

// 邮编查询  - 城市 & 0
+ (void)postCodeDataWithCity:(NSString *)City
                     success:(void (^)(id json))success
                     failure:(void (^)(NSError *error))failure
             timeoutInterval:(NSTimeInterval)timeoutInterval
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:City forKey:@"address"];
    [paramDict setObject:@"0" forKey:@"areaid"];
    
    LSHttpTool *httpTool = [LSHttpTool sharedInstance];
    httpTool.requestSerializer.timeoutInterval = timeoutInterval;
    
    [httpTool getWithURL:PostCodeUrl params:paramDict success:^(id json) {
        
        if( success )
        {
            success(json);
        }
        
    } failure:^(NSError *error) {
        
        if( failure )
        {
            failure(error);
        }
        
    }];

}

// IP地址查询 - ip地址
+ (void)ipDataWithPICode:(NSString *)ipCode
                 success:(void (^)(id json))success
                 failure:(void (^)(NSError *error))failure
         timeoutInterval:(NSTimeInterval)timeoutInterval
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:ipCode forKey:@"ip"];
    
    LSHttpTool *httpTool = [LSHttpTool sharedInstance];
    httpTool.requestSerializer.timeoutInterval = timeoutInterval;
    
    [httpTool getWithURL:IPUrl params:paramDict success:^(id json) {
        
        if( success )
        {
            success(json);
        }
        
    } failure:^(NSError *error) {
        
        if( failure )
        {
            failure(error);
        }
        
    }];

}

// 快递查询  - 快递公司代号&快递号
+ (void)expressDataWithNum:(NSString *)expressName
                       num:(NSString *)expressCode
                   success:(void (^)(id json))success
                   failure:(void (^)(NSError *error))failure
           timeoutInterval:(NSTimeInterval)timeoutInterval
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:expressName forKey:@"type"];
    [paramDict setObject:expressCode forKey:@"number"];
    
    LSHttpTool *httpTool = [LSHttpTool sharedInstance];
    httpTool.requestSerializer.timeoutInterval = timeoutInterval;
    
    [httpTool getWithURL:ExpressUrl params:paramDict success:^(id json) {
        
        if( success )
        {
            success(json);
        }
        
    } failure:^(NSError *error) {
        
        if( failure )
        {
            failure(error);
        }
        
    }];

}

// 手机归属地 - 手机号码
+ (void)telephoneDataWithNum:(NSString *)telephone
                   success:(void (^)(id json))success
                   failure:(void (^)(NSError *error))failure
             timeoutInterval:(NSTimeInterval)timeoutInterval
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:telephone forKey:@"phone"];
    
    LSHttpTool *httpTool = [LSHttpTool sharedInstance];
    httpTool.requestSerializer.timeoutInterval = timeoutInterval;
    
    [httpTool getWithURL:TelephoneUrl params:paramDict success:^(id json) {
        
        if( success )
        {
            success(json);
        }
        
    } failure:^(NSError *error) {
        
        if( failure )
        {
            failure(error);
        }
        
    }];

}

// 苹果序列号  - 序列号
+ (void)appleIMEIDataWithSN:(NSString *)appleIMEI
                     success:(void (^)(id json))success
                     failure:(void (^)(NSError *error))failure
             timeoutInterval:(NSTimeInterval)timeoutInterval
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:appleIMEI forKey:@"sn"];
    
    LSHttpTool *httpTool = [LSHttpTool sharedInstance];
    httpTool.requestSerializer.timeoutInterval = timeoutInterval;
    
    [httpTool getWithURL:AppleSNUrl params:paramDict success:^(id json) {
        
        if( success )
        {
            success(json);
        }
        
    } failure:^(NSError *error) {
        
        if( failure )
        {
            failure(error);
        }
        
    }];

}

// ----- 出行
// 长途汽车查询 - 起点城市名 ： 终点城市名
+ (void)coachDataWithName:(NSString *)fromCity
                       to:(NSString *)toCity
                  success:(void (^)(id json))success
                  failure:(void (^)(NSError *error))failure
          timeoutInterval:(NSTimeInterval)timeoutInterval
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:fromCity forKey:@"start"];
    [paramDict setObject:toCity forKey:@"end"];
    
    LSHttpTool *httpTool = [LSHttpTool sharedInstance];
    httpTool.requestSerializer.timeoutInterval = timeoutInterval;
    
    [httpTool getWithURL:CoachUrl params:paramDict success:^(id json) {
        
        if( success )
        {
            success(json);
        }
        
    } failure:^(NSError *error) {
        
        if( failure )
        {
            failure(error);
        }
        
    }];

}

// 油价查询 - 省名或直辖市
+ (void)oilPriceDataWithCity:(NSString *)city
                     success:(void (^)(id json))success
                     failure:(void (^)(NSError *error))failure
             timeoutInterval:(NSTimeInterval)timeoutInterval
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:city forKey:@"prov"];
    
    LSHttpTool *httpTool = [LSHttpTool sharedInstance];
    httpTool.requestSerializer.timeoutInterval = timeoutInterval;
    
    [httpTool getWithURL:OilPriceUrl params:paramDict success:^(id json) {
        
        if( success )
        {
            success(json);
        }
        
    } failure:^(NSError *error) {
        
        if( failure )
        {
            failure(error);
        }
        
    }];

}

// ----- 车辆限行情况
+ (void)trafficLimitDataWithCity:(NSString *)city
                            date:(NSString *)checkDate
                         success:(void (^)(id json))success
                         failure:(void (^)(NSError *error))failure
                 timeoutInterval:(NSTimeInterval)timeoutInterval
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:city forKey:@"city"];
    [paramDict setObject:checkDate forKey:@"date"];
    
    LSHttpTool *httpTool = [LSHttpTool sharedInstance];
    httpTool.requestSerializer.timeoutInterval = timeoutInterval;
    
    [httpTool getWithURL:LimitUrl params:paramDict success:^(id json) {
        
        if( success )
        {
            success(json);
        }
        
    } failure:^(NSError *error) {
        
        if( failure )
        {
            failure(error);
        }
        
    }];

}

+ (void)currencyDataWithName:(NSString *)fromCurrency
                          to:(NSString *)toCurrency
                      amount:(NSString *)amount
                     success:(void (^)(id))success
                     failure:(void (^)(NSError *))failure
             timeoutInterval:(NSTimeInterval)timeoutInterval
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:fromCurrency forKey:@"fromCurrency"];
    [paramDict setObject:toCurrency forKey:@"toCurrency"];
    [paramDict setObject:amount forKey:@"amount"];
    
    LSHttpTool *httpTool = [LSHttpTool sharedInstance];
    httpTool.requestSerializer.timeoutInterval = timeoutInterval;
    
    [httpTool getWithURL:CurrencyUrl params:paramDict success:^(id json) {
        
        if( success )
        {
            success(json);
        }
        
    } failure:^(NSError *error) {
        
        if( failure )
        {
            failure(error);
        }
        
    }];

}

@end
