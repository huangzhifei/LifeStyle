//
//  WBDetailLableItem.h
//  XinWeibo
//
//  Created by tanyang on 14/10/23.
//  Copyright (c) 2014年 tany. All rights reserved.
//

#import "RETableViewItem.h"

@interface LSSubtitleItem : RETableViewItem

@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) UIFont *subtitleFont;
@property (nonatomic, assign) NSTextAlignment subtitleAlignment;

+ (LSSubtitleItem *)itemWithTitle:(NSString *)title subTitle:(NSString *)subtitle;

+ (LSSubtitleItem *)itemWithTitle:(NSString *)title rightSubTitle:(NSString *)subtitle;

@end
