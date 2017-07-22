//
//  HZActivity.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/8.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HZActivityDelegate <NSObject>

@required
- (void)didClickOnImageIndex:(NSInteger *)imageIndex;

@optional
- (void)didClickOnCancelButton;

@end

@interface HZActivity : UIView

- (instancetype)initWithTitle:(NSString *)title
                     delegate:(id<HZActivityDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
            shareButtonTitles:(NSArray *)shareButtonTitles
        shareButtonImagesName:(NSArray *)shareButtonImagesName;

- (void)show;

@end

