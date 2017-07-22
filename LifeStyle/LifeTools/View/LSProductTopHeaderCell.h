//
//  LSProductTopHeaderCell.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/4.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

/**
 *  天气
 */
#import <UIKit/UIKit.h>
#import "LSWeatherData.h"

@interface LSProductTopHeaderCell : UICollectionViewCell

@property (strong, nonatomic) LSWeatherData *weatherData;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end
