//
//  LSProductItem.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/5.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSProductItem.h"

@implementation LSProductItem

+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon
{
    return [[self alloc] initWithTitle:title icon:icon];
}

- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon
{
    self = [self init];
    
    if( self )
    {
        self.title = title;
        self.image = icon;
    }
    
    return self;
}


+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon controlVCClass:(Class)controlClass
{
    return [[self alloc] initWithTitle:title icon:icon VCClass:controlClass];
}

- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon VCClass:(Class)VCClass
{
    self = [self initWithTitle:title icon:icon];
    
    if( self )
    {
        self.controlClass = VCClass;
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    
    return self;
}

@end
