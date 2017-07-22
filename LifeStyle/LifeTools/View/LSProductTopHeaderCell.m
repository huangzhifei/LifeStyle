//
//  LSProductTopHeaderCell.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/4.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSProductTopHeaderCell.h"
#import "MJExtension.h"

@interface LSProductTopHeaderCell()

@property (weak, nonatomic) IBOutlet UIImageView *weather;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureRangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;

@end

@implementation LSProductTopHeaderCell



- (void)awakeFromNib
{
    self.userInteractionEnabled = YES;
    self.backgroundColor = kCollectionTopHeaderColor;
    [self updateAlpha:0];
}

- (void)updateAlpha:(CGFloat)value
{
    self.weather.alpha = value;
    self.cityLabel.alpha = value;
    self.dateLabel.alpha = value;
    self.temperatureRangeLabel.alpha = value;
    self.temperatureLabel.alpha = value;
    self.windLabel.alpha = value;
    self.weatherLabel.alpha = value;
    self.weekLabel.alpha = value;
}

- (void)setWeatherData:(LSWeatherData *)weatherData
{
    _weatherData = weatherData;
    
    LSWeatherDetail *dataDetail = [LSWeatherDetail mj_objectWithKeyValues:weatherData.weather_data[0]] ;
    
    _cityLabel.text = weatherData.currentCity;
    _dateLabel.text = weatherData.date;
    _weekLabel.text = [dataDetail.date substringToIndex:2];
    _temperatureRangeLabel.text = dataDetail.temperature;
    NSString *temperStr = [[dataDetail.date componentsSeparatedByString:@" "] lastObject];
    NSRange range = {1, temperStr.length-2};
    temperStr = [temperStr substringWithRange:range];
    _temperatureLabel.text = temperStr;
    
    _windLabel.text = dataDetail.wind;
    
    NSString *weatherStr = dataDetail.weather;
    NSUInteger strLocation = [weatherStr rangeOfString:@"转"].location;
    if (strLocation != NSNotFound) {
        weatherStr = [weatherStr substringToIndex:strLocation];
    }
    _weather.image = [UIImage imageNamed:weatherStr];
    
    _weatherLabel.text = dataDetail.weather;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        [self updateAlpha:1];
        
    }];
}

@end
