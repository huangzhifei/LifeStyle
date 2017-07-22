//
//  LSCategory.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/16.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSCategory.h"
#import "MJExtension.h"
#import "LSSubCategorie.h"

@implementation LSCategory

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"subcategories":[LSSubCategorie class]
            };
}

@end
