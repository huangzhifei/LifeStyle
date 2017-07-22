//
//  LSCoverView.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/7.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSCoverView : UIView

+ (id)cover;

+ (id)coverWithTarget:(id)target action:(SEL)action;

- (void)reset;

@end
