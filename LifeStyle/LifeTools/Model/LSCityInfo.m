//
//  LSCityInfo.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/6.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSCityInfo.h"

@implementation LSCityInfo

@end

@implementation LSCityGroup

- (NSMutableArray *)arrayCitys
{
    if( _arrayCitys == nil )
    {
        _arrayCitys = [[NSMutableArray alloc] init];
    }
    
    return _arrayCitys;
}

@end