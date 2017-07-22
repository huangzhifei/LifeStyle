//
//  LSNearbyHttpTool.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/18.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSNearbyHttpTool.h"
#import "DPAPI.h"
#import "DPRequest.h"
#import "MJExtension.h"
#import "LSOrder.h"
#import "LSDeal.h"
#import "LSNearbyMetaDataTool.h"

typedef void (^RequestBlock)(id result, NSError *errorObj);

@interface LSNearbyHttpTool() <DPRequestDelegate>
{
    NSMutableDictionary *_blocks;
}
@end

@implementation LSNearbyHttpTool

LSSingleton_implementation(LSNearbyHttpTool)

- (id)init
{
    if (self = [super init])
    {
        _blocks = [NSMutableDictionary dictionary];
    }
    
    return self;
}

#pragma mark 获得大批量团购
- (void)getDealsWithParams:(NSMutableDictionary *)params success:(DealsSuccessBlock)success error:(DealsErrorBlock)error
{
    [self requestWithURL:@"v1/deal/find_deals" params:params block:^(id result, NSError *errorObj) {
        
        if (errorObj)
        {
            if (error)
            {
                NSLog(@"1-error: %@", errorObj);
                
                error(errorObj);
            }
        }
        else if (success)
        {
            NSLog(@"deals: %@", result);
            
            if ([result[@"status"] isEqualToString:@"OK"])
            {
                NSArray *array = result[@"deals"];
                NSMutableArray *deals = [NSMutableArray array];
                
                for (NSDictionary *dict in array)
                {
                    LSDeal *deal = [LSDeal mj_objectWithKeyValues:dict];
                    [deals addObject:deal];
                }
                
                success(deals, [result[@"total_count"] intValue]);
            }
            else
            {
                if (error)
                {
                    NSLog(@"2-error: %@", errorObj);
                    error(errorObj);
                }
            }
        }
    }];
}

#pragma mark 获得第page页的团购数据
- (void)dealsWithPage:(int)page district:(NSString *)district category:(NSString *)category orderIndext:(NSInteger)orderIndext success:(DealsSuccessBlock)success error:(DealsErrorBlock)error
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@(10) forKey:@"limit"];

    LSLocationInfo *locatInfo = [LSNearbyMetaDataTool sharedLSNearbyMetaDataTool].locatInfo;
    [params setObject:@"5000" forKey:@"radius"];
    [params setObject:[NSNumber numberWithDouble:locatInfo.latitude] forKey:@"latitude"];
    [params setObject:[NSNumber numberWithDouble:locatInfo.longitude] forKey:@"longitude"];
    
    NSString *city = locatInfo.City;
    
    if (city)
    {
        [params setObject:[city substringToIndex:city.length - 1] forKey:@"city"];
    }
    else
    {
        [params setObject:@"深圳" forKey:@"city"];
    }
    
    if(district)
    {
        [params setObject:district forKey:@"region"];
    }
    
    if(category)
    {
        [params setObject:category forKey:@"category"];
    }
    
    if (orderIndext > 0)
    {
        [params setObject:@(orderIndext) forKey:@"sort"];
    }
    
    // 添加页码参数
    [params setObject:@(page) forKey:@"page"];
    
    // 发送请求
    [self getDealsWithParams:params success:success error:error];
}

#pragma mark 获得指定的团购数据
- (void)dealWithID:(NSString *)ID success:(DealSuccessBlock)success error:(DealErrorBlock)error
{
    [self requestWithURL:@"v1/deal/get_single_deal" params:[NSMutableDictionary dictionaryWithObject:ID forKey:@"deal_id" ] block:^(id result, NSError *errorObj) {
        
        NSDictionary *deals = result[@"deals"][0];
        
        if (deals.count > 0)
        {
            if (success)
            {
                LSDeal *deal = [LSDeal mj_objectWithKeyValues:deals];
                success(deal);
            }
        }
        else
        {
            if (error)
            {
                NSLog(@"3-error: %@", errorObj);
                error(errorObj);
            }
        }
    }];
}

#pragma mark 获得周边的团购
- (void)dealsWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude success:(DealsSuccessBlock)success error:(DealsErrorBlock)error
{
    // 获得位置城市
    NSString *city = [LSNearbyMetaDataTool sharedLSNearbyMetaDataTool].locatInfo.City;
    CGFloat lati = [LSNearbyMetaDataTool sharedLSNearbyMetaDataTool].locatInfo.latitude;
    CGFloat longi = [LSNearbyMetaDataTool sharedLSNearbyMetaDataTool].locatInfo.longitude;
    
    if (city == nil || city == nil) return;
    
    NSDictionary *dict = @{
                                  @"city" : city,
                                  @"latitude" : @(lati),
                                  @"longitude" : @(longi),
                                  @"radius" : @5000
                                  };
    
    [self getDealsWithParams:[[NSMutableDictionary alloc] initWithDictionary:dict] success:success error:error];
}

#pragma mark 封装了点评的任何请求
- (void)requestWithURL:(NSString *)url params:(NSMutableDictionary *)params block:(RequestBlock)block
{
    DPAPI *api = [DPAPI sharedDPAPI];
    /*
     1.请求成功会调用self的下面方法
     - (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
     
     2.请求失败会调用self的下面方法
     - (void)request:(DPRequest *)request didFailWithError:(NSError *)error
     */
    DPRequest *request = [api requestWithURL:url params:params delegate:self];
    // 一次请求 对应 一个block
    // 不直接用request的原因是：字典的key必须遵守NSCopying协议
    // request.description返回的是一个格式为“<类名：内存地址>”的字符串，能代表唯一的一个request对象
    [_blocks setObject:block forKey:request.description];
}

#pragma mark - 大众点评的请求方法代理
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    // 取出这次request对应的block
    RequestBlock block = _blocks[request.description];
    if (block) {
        block(result, nil);
    }
    [_blocks removeObjectForKey:request.description];
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    // 取出这次request对应的block
    RequestBlock block = _blocks[request.description];
    if (block) {
        block(nil, error);
    }
    [_blocks removeObjectForKey:request.description];
}


@end

