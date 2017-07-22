//
//  LSWeatherViewController.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/14.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSWeatherViewController.h"
#import "RETableViewOptionsController.h"
#import "LSWeatherTopView.h"
#import "LSSingleWeahterView.h"
#import "MJExtension.h"

@interface LSWeatherViewController ()

@property (strong, nonatomic) RETableViewManager *tableViewManager;

@end

@implementation LSWeatherViewController

#pragma mark - init
- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if( self )
    {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"天气详情";
    self.tableViewManager = ({
        
        RETableViewManager *manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
        manager.style.cellHeight = 44;
        
        manager;
    });
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = kCollectionHeaderColor;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    
    [self addFirstSection];
    [self addSecondSection];
    //[self addThirdSection];
}

- (void)addFirstSection
{
    LSWeatherTopView *topView = [LSWeatherTopView loadDIY];
    topView.bounds = CGRectMake(0, 0, kScreenWidth, 200);
    topView.weatherData = self.weatherInfo;
    
    RETableViewSection *topSection = ({
        
        RETableViewSection *section = [RETableViewSection sectionWithHeaderView:topView];
        
        section;
    });
    
    [self.tableViewManager addSection:topSection];
}

- (void)addSecondSection
{
    const NSInteger leftDist = 8;
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.bounds = CGRectMake(0, 0, kScreenWidth, 250);
    bottomView.backgroundColor = kCollectionHeaderColor;
    
    NSInteger dayCount = [self.weatherInfo.weather_data count];
    
    CGFloat singleWidth = (kScreenWidth - leftDist*2) * 1.0 / (dayCount - 1);
    CGFloat singleHeight = 240;
    
    for(NSInteger index = 1; index < dayCount; ++ index)
    {
        LSSingleWeahterView *singleView = [LSSingleWeahterView loadDIY];
        singleView.wdetail = [LSWeatherDetail mj_objectWithKeyValues:self.weatherInfo.weather_data[index]];
        
        [bottomView addSubview:singleView];

        CGFloat w = leftDist + singleWidth * ( index - 1 );
        singleView.frame = CGRectMake(w, leftDist, singleWidth, singleHeight);
    }
    
    RETableViewSection *bottomSection = ({
        
        RETableViewSection *section = [RETableViewSection sectionWithHeaderView:bottomView];
        
        section;
    });
    
    [self.tableViewManager addSection:bottomSection];
}


- (void)addThirdSection
{
    UIView * view = [[UIView alloc] init];
    view.bounds = CGRectMake(8, 0, kScreenWidth, 60);
    view.backgroundColor = [UIColor clearColor];
    LSIndexDetail *detail = [LSIndexDetail mj_objectWithKeyValues:self.weatherInfo.index[0]];
    
    UILabel *label = [[UILabel alloc] init];
    [label setTextColor:[UIColor grayColor]];
    label.numberOfLines = 0;
    [label setText:detail.des];
    label.frame = view.bounds;
    [view addSubview:label];
    label.backgroundColor = [UIColor clearColor];
    
    RETableViewSection *tipSection = [RETableViewSection sectionWithHeaderView:view];
    
    [self.tableViewManager addSection:tipSection];
}

@end
