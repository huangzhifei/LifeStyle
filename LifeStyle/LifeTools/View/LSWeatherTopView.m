//
//  LSWeatherTopView.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/14.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSWeatherTopView.h"
#import "MJExtension.h"

@interface LSWeatherTopView()

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureRangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weather;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;


@end

@implementation LSWeatherTopView

+ (instancetype)loadDIY
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    self.backgroundColor = kCollectionHeaderColor;
}

- (void)setWeatherData:(LSWeatherData *)weatherData
{
    _weatherData = weatherData;
    
    LSWeatherDetail *dataDetail = [LSWeatherDetail mj_objectWithKeyValues:weatherData.weather_data[0]] ;
    
    _cityLabel.text = weatherData.currentCity;
    _dateLabel.text = weatherData.date;
    _weekLabel.text = [dataDetail.date substringToIndex:3];
    _temperatureRangeLabel.text = dataDetail.temperature;
    NSString *temperStr = [[dataDetail.date componentsSeparatedByString:@" "] lastObject];
    NSRange range = {1, temperStr.length-2};
    temperStr = [temperStr substringWithRange:range];
    _temperatureLabel.text = temperStr;
    
    _windLabel.text = dataDetail.wind;
    
    NSString *weatherStr = dataDetail.weather;
    
    _weather.image = [UIImage imageNamed:weatherStr];
    if( _weather.image == nil )
    {
        NSUInteger strLocation = [weatherStr rangeOfString:@"转"].location;
        if (strLocation != NSNotFound) {
            weatherStr = [weatherStr substringToIndex:strLocation];
        }
        _weather.image = [UIImage imageNamed:weatherStr];
    }
    _weatherLabel.text = dataDetail.weather;
}

@end
