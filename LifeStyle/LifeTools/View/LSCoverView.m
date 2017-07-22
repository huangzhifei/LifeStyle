//
//  LSCoverView.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/7.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSCoverView.h"

#define kAlpha 0.6

@implementation LSCoverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 1.背景色
        self.backgroundColor = [UIColor blackColor];
        
        // 2.自动伸缩
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        // 3.透明度
        self.alpha = 0;
    }
    return self;
}

- (void)reset
{
    self.alpha = kAlpha;
}

+ (id)cover
{
    return [[self alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
}

+ (id)coverWithTarget:(id)target action:(SEL)action
{
    LSCoverView *cover = [self cover];
    
    [cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:target action:action]];
    
    return cover;
}


@end
