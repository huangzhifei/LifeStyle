//
//  LSCityListDelegate.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/6.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LSCityListViewController;
@class LSCityInfo;

@protocol LSCityListViewDelegate <NSObject>

@required

- (void)cityDismissViewController:(LSCityListViewController *)cityViewController;

- (void)cityDidSelect:(LSCityListViewController *)cityViewController city:(NSString *)cityName;

@end

