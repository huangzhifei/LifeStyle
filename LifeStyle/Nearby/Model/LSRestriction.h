//
//  LSRestriction.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/18.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSRestriction : NSObject

// 是否需要预约，0：不是，1：是
@property (nonatomic, assign) BOOL is_reservation_required;

// 是否支持随时退款，0：不是，1：是
@property (nonatomic, assign) BOOL is_refundable;

// （购买须知）附加信息
@property (nonatomic, copy) NSString * special_tips;

@end
