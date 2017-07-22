//
//  LSLocationTool.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/13.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSLocationTool.h"
#import "MJExtension.h"
#import "LSMC.h"

//#define locationUrl @"http://api.map.baidu.com/?qt=rgc&dis_poi=1&x=13407612.87&y=3550364.78"
#define locationUrl @"http://api.map.baidu.com/?qt=rgc&dis_poi=1"

@interface LSLocationTool()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *cityName;
//@property (strong, nonatomic) void(^sendLocation)(NSString *city);
@property (strong, nonatomic) CLGeocoder *geocoder;

@end

@implementation LSLocationTool

#pragma mark - init
- (instancetype)init
{
    self = [super init];
    
    if( self )
    {
        self.cityName = @"北京";
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;

        if([CLLocationManager locationServicesEnabled])
        {
            [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            self.locationManager.distanceFilter = 10;
            
            [self.locationManager requestWhenInUseAuthorization];
            //[self.locationManager requestAlwaysAuthorization];

            self.geocoder = [[CLGeocoder alloc] init];
            
             NSLog(@"---");
        }
        NSLog(@"000");
    }
    
    return self;
}

- (void)startLocation
{
    if([CLLocationManager locationServicesEnabled])
    {
        //self.sendLocation = callback;
        
        // 开启定位
        [self.locationManager startUpdatingLocation];
        
         NSLog(@"33333");
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    // 1.停止定位
    [self.locationManager stopUpdatingLocation];
    
    CLLocation *currentLocation = [locations lastObject];
    
    NSLog(@"latitude:%f \nlongitude%f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    
    MC result = convertLL2MC(currentLocation.coordinate.longitude, currentLocation.coordinate.latitude);
    
    NSLog(@"result.x: %f \nresult.y: %f", result.x, result.y);
    /**
     *  iOS系统自带的地理位置反编码实在太慢了，毕竟服务器在国外，换成国内baidu的接口，抓包可以看到此接口
     */
    //根据经纬度反向地理编译出地址信息
    [self.geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error){
        
        NSLog(@"fdfdff");
        if (array.count > 0)
        {
            CLPlacemark *placemark = [array objectAtIndex:0];
            LSLocationInfo *locaInfo = [LSLocationInfo mj_objectWithKeyValues:placemark.addressDictionary];
            locaInfo.latitude = currentLocation.coordinate.latitude;
            locaInfo.longitude = currentLocation.coordinate.longitude;
            //获取城市
            NSString *city = placemark.locality;
            //城市的区域
            NSLog(@"country: %@",placemark.subLocality);
            //国家
            NSLog(@"city: %@",placemark.country);
            if(!city)
            {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
                locaInfo.City = city;
            }
            self.cityName = city;
            NSLog(@"cityName: %@",self.cityName);
            
            if( self.delegate && [self.delegate respondsToSelector:@selector(stopLocation:)] )
            {
                [self.delegate stopLocation:locaInfo];
            }
        }
        
    }];

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒绝
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
    }
    
    // 此时发送默认城市 - 北京
    NSLog(@"error");
    
    // 1.停止定位
    [self.locationManager stopUpdatingLocation];

    LSLocationInfo *info = [[LSLocationInfo alloc] init];
    info.City = @"北京";
    
    if( self.delegate && [self.delegate respondsToSelector:@selector(stopLocation:)] )
    {
        [self.delegate stopLocation:info];
    }
}

@end

