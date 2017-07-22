//
//  LSCommercialRevenueView.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/12.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSCommercialRevenueView.h"

@implementation LSCommercialRevenueView

+ (instancetype)loadDIYView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

@end
