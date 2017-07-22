//
//  LSCityListViewController.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/6.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSCityListViewDelegate.h"

typedef NS_ENUM(NSUInteger, ExtensionSection)
{
    ExtensionSectionLocal,
    ExtensionSectionRecent,
    ExtensionSectionHot,
};

@interface LSCityListViewController : UIViewController

@property (weak,   nonatomic) id<LSCityListViewDelegate>delegate;
// 所选城市
@property (strong, nonatomic) NSString  *selectedCity;

+(instancetype)loadCityController;

@end
