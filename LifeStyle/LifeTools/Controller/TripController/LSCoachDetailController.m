//
//  LSCoachDetailController.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/11.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSCoachDetailController.h"

@interface LSCoachDetailController ()

@property (weak, nonatomic) IBOutlet UITextField *startCityField;
@property (weak, nonatomic) IBOutlet UITextField *endCityField;
@property (weak, nonatomic) IBOutlet UITextField *startStationField;
@property (weak, nonatomic) IBOutlet UITextField *endStationField;
@property (weak, nonatomic) IBOutlet UITextField *priceField;
@property (weak, nonatomic) IBOutlet UITextField *busTypeField;
@property (weak, nonatomic) IBOutlet UITextField *distanceField;
@property (weak, nonatomic) IBOutlet UITextField *departureTime;

@end

@implementation LSCoachDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"列车详细";
    
    self.view.backgroundColor = kCollectionHeaderColor;
    
    _startCityField.text    = self.detailItem.startCity;
    _endCityField.text      = self.detailItem.endCity;
    _startStationField.text    = self.detailItem.startStation;
    _endStationField.text      = self.detailItem.endStation;
    _priceField.text        = self.detailItem.price;
    _busTypeField.text      = self.detailItem.busType;
    _distanceField.text     = [[NSString alloc] initWithFormat:@"%@公里",self.detailItem.distance];
    if( self.detailItem.distance == nil || [self.detailItem.distance isEqualToString:@"0"]
       || [self.detailItem.distance isEqualToString:@""] )
    {
        _distanceField.text = @"未知";
    }
    _departureTime.text     = self.detailItem.departureTime;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
