//
//  LSProductSection.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/5.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSProductSection.h"

@implementation LSProductSection

+ (instancetype)section
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if( self )
    {
        self.items = [NSMutableArray array];
    }
    
    return self;
}

@end
