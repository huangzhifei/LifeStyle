//
//  WBDetailLableItem.m
//  XinWeibo
//
//  Created by tanyang on 14/10/23.
//  Copyright (c) 2014年 tany. All rights reserved.
//

#import "LSSubtitleItem.h"

@implementation LSSubtitleItem

+ (LSSubtitleItem *)itemWithTitle:(NSString *)title subTitle:(NSString *)subtitle
{
    LSSubtitleItem *item = [[LSSubtitleItem alloc]init];
    item.title = title;
    item.subtitle = subtitle;
    item.subtitleFont = [UIFont systemFontOfSize:15];
    item.subtitleAlignment = NSTextAlignmentCenter;
    
    return item;
}

+ (LSSubtitleItem *)itemWithTitle:(NSString *)title rightSubTitle:(NSString *)subtitle
{
    LSSubtitleItem *item = [LSSubtitleItem itemWithTitle:title subTitle:subtitle];
    item.subtitleFont = [UIFont systemFontOfSize:15];
    item.subtitleAlignment = NSTextAlignmentRight;
    return item;
}

@end
