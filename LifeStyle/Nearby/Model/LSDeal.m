//
//  LSDeal.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/18.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSDeal.h"
#import "NSString+buy.h"
#import "LSBusiness.h"

@implementation LSDeal

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"desc" : @"description"
            };
}

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"businesses":[LSBusiness class]
            };
}

- (void)setList_price:(double)list_price
{
    _list_price = list_price;
    
    _list_price_text = [NSString stringWithDouble:list_price fractionCount:2];
}

- (void)setCurrent_price:(double)current_price
{
    _current_price = current_price;
    
    _current_price_text = [NSString stringWithDouble:current_price fractionCount:2];
}

@end
