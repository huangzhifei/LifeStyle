//
//  LSProductSection.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/5.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSProductSection : NSObject

@property (strong, nonatomic) UIView    *headerView;
@property (strong, nonatomic) UIView    *footerView;
@property (strong, nonatomic) NSString  *headerTitle;
@property (strong, nonatomic) NSString  *footerTitle;
@property (strong, nonatomic) NSMutableArray *items;

+ (instancetype)section;

@end
