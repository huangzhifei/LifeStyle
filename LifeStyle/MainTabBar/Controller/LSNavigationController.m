//
//  LSNavigationController.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/4.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSNavigationController.h"

@implementation LSNavigationController

#pragma mark - override
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if( self.viewControllers.count > 0 )
    {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

@end
