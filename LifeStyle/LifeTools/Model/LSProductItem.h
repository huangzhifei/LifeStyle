//
//  LSProductItem.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/5.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSProductItem : NSObject

@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) Class controlClass;

+(instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon;
+(instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon controlVCClass:(Class) controlClass;

@end
