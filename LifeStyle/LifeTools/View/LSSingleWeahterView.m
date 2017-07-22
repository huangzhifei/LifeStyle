//
//  LSSingleWeahterView.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/14.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSSingleWeahterView.h"

@interface LSSingleWeahterView()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempreLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;


@end

@implementation LSSingleWeahterView

+ (instancetype)loadDIY
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    self.backgroundColor = kCollectionHeaderColor;
}

- (void)setWdetail:(LSWeatherDetail *)wdetail
{
    _wdetail = wdetail;
    
    NSString *weatherStr = wdetail.weather;
    _imageView.image = [UIImage imageNamed:wdetail.weather];
    if( _imageView.image == nil )
    {
        NSUInteger strLocation = [weatherStr rangeOfString:@"转"].location;
        if (strLocation != NSNotFound) {
            weatherStr = [weatherStr substringToIndex:strLocation];
        }
        _imageView.image = [UIImage imageNamed:weatherStr];
    }

    _weekLabel.text = wdetail.weather;
    _weatherLabel.text = wdetail.date;
    _tempreLabel.text = wdetail.temperature;
    _windLabel.text = wdetail.wind;
}

@end
