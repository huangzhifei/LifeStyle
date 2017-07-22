//
//  LSNearbyMetaDataTool.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/16.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSNearbyMetaDataTool.h"
#import "MJExtension.h"
#import "LSBuyCity.h"
#import "LSOrder.h"

@interface LSNearbyMetaDataTool()<LSLocationToolDelegate>

@end

@implementation LSNearbyMetaDataTool

LSSingleton_implementation(LSNearbyMetaDataTool)

#pragma mark - init
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.location = [[LSLocationTool alloc] init];
        self.location.delegate = self;
        [self initTotalCategories];
        [self initTotalCitys];
        [self initTotalOrder];
    }
    return self;
}

- (void)initTotalCategories
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BuyCategories" ofType:@".plist"];
    
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in array)
    {
        LSCategory *category = [[LSCategory alloc] init];
        category = [LSCategory mj_objectWithKeyValues:dict];
        
        [temp addObject:category];
    }
    
    _totalCategories = temp;
}

- (void)initTotalCitys
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BuyCities" ofType:@".plist"];
    
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for(NSDictionary *dict in array)
    {
        for(NSDictionary *dict_1 in dict[@"cities"])
        {
            LSBuyCity *cities = [[LSBuyCity alloc] init];
            cities.cityname = dict_1[@"name"];
            for( NSDictionary *dict_2 in dict_1[@"districts"] )
            {
                LSDistricts *districts = [[LSDistricts alloc] init];
                districts.district_name = dict_2[@"name"];
                if( dict_2[@"neighborhoods"] == nil )
                {
                    districts.neighborhoods = [[NSMutableArray alloc] init];
                }
                else
                {
                    districts.neighborhoods = [NSMutableArray arrayWithArray:dict_2[@"neighborhoods"]];
                    [districts.neighborhoods insertObject:districts.district_name atIndex:0];
                }
                if( cities.districts == nil )
                {
                    cities.districts = [[NSMutableArray alloc] init];
                }
                [cities.districts addObject:districts];
            }
            [temp addObject:cities];
        }
    }
    _totalCitys = temp;
    NSLog(@"totalcity %@", _totalCitys);
}

- (void)initTotalOrder
{
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BuyOrders.plist" ofType:nil]];
    NSInteger count = array.count;
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i<count; i++)
    {
        LSOrder *or = [[LSOrder alloc] init];
        or.name = array[i];
        or.index = i + 1;
        [temp addObject:or];
    }
    
    _totalOrders = temp;
}

#pragma mark - location delegate
- (void)stopLocation:(LSLocationInfo *)locaInfo
{
    self.locatInfo = locaInfo;
}

@end
