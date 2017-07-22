//
//  LSLimitSearchController.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/12.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSLimitSearchController.h"
#import "LSLifeToolHeader.h"
#import "LSSubtitleItem.h"
#import "RETableViewOptionsController.h"
#import "RELongTextItem.h"

@interface LSLimitSearchController ()

@property (strong, nonatomic) RETableViewManager *tableViewManager;
@property (strong, nonatomic) RETableViewSection *resultSection;
@property (strong, nonatomic) RETableViewSection *limitSection;
@property (strong, nonatomic) RETableViewSection *searchSection;
@property (strong, nonatomic) RERadioItem        *cityItem;
@property (strong, nonatomic) REDateTimeItem     *dateItem;

@property (strong, nonatomic) NSArray            *limitCity; // 拼音
@property (strong, nonatomic) NSArray            *limitCityname; // 中文
@property (strong, nonatomic) NSDictionary       *limitCityInfo;
@property (assign, nonatomic) CGPoint            offY;

@end

@implementation LSLimitSearchController

#pragma mark - init
- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if( self )
    {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initLimitInfo];
    
    self.title = @"限号查询";
    self.tableViewManager = ({
        
        RETableViewManager *manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
        manager.style.cellHeight = 44;
        
        manager;
    });
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = kCollectionHeaderColor;;
    
    [self addLimitInputSection];
    [self addLimitResultSection];
    [self addLimitSearchSection];
    
    self.offY= CGPointMake(0, -64);
}

#pragma mark - private method
- (void)initLimitInfo
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"limit" ofType:@".plist"];
    NSArray  *array  = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *limitChinese = [[NSMutableArray alloc] init];
    NSMutableArray *limitType    = [[NSMutableArray alloc] init];
    
    for(NSDictionary *element in array)
    {
        [limitChinese addObject:[element valueForKey:@"cityname"]];
        [limitType    addObject:[element objectForKey:@"city"]];
    }
    self.limitCityname = [NSArray arrayWithArray:limitChinese];
    self.limitCity    = [NSArray arrayWithArray:limitType];
    self.limitCityInfo = [[NSDictionary alloc] initWithObjects:self.limitCity forKeys:self.limitCityname];
    
}

- (void)addLimitInputSection
{
    UIImageView *IDPhoto = ({
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"a0"]];
        imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
        imageView.contentMode = UIViewContentModeCenter;
        imageView;
    });
    
    self.limitSection = ({
        
        RETableViewSection *IDCardSection = [RETableViewSection sectionWithHeaderView:IDPhoto];
        IDCardSection.footerTitle = @"提供北京、上海、深圳等10多个城市的车辆限行时间、区域、尾号等查询，每天查询次数只有10次。";
        
        weakify(self)
        self.cityItem = [RERadioItem itemWithTitle:@"查询城市:" value:@"北京" selectionHandler:^(RERadioItem *item) {
           
            strongify(self)
            RETableViewOptionsController *optionsVC = [[RETableViewOptionsController alloc] initWithItem:item options:self.limitCityname multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem) {
                
                [self.navigationController popViewControllerAnimated:YES];
                [item reloadRowWithAnimation:UITableViewRowAnimationNone];
            }];
            
            [self.navigationController pushViewController:optionsVC animated:YES];
        }];
        [IDCardSection addItem:self.cityItem];
        
        self.dateItem = [REDateTimeItem itemWithTitle:@"查询日期:" value:[NSDate date] placeholder:nil
                                               format:@"yyyy-MM-dd" datePickerMode:UIDatePickerModeDate];
        
        [IDCardSection addItem:self.dateItem];
        
        IDCardSection;
    });
    [self.tableViewManager addSection:self.limitSection];
}

- (void)addLimitResultSection
{
    self.resultSection = ({
        
        RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"查询结果: "];
        
        section;
    });
    
    [self.tableViewManager addSection:self.resultSection];
    
}

- (void)addLimitSearchSection
{
    self.searchSection = [RETableViewSection section];
    [self.tableViewManager addSection:self.searchSection];
    
    weakify(self)
    RETableViewItem *searchButton = [RETableViewItem itemWithTitle:@"查询"
                                                     accessoryType:UITableViewCellAccessoryNone
                                                  selectionHandler:^(RETableViewItem *item) {
                                                      
                                                      strongify(self)
                                                      
                                                      NSString *city = self.cityItem.value;
                                                      NSString *checkDate = [self stringFromDate:self.dateItem.value];
                                                      
                                                      if( city && checkDate )
                                                      {
                                                          [self fetchLimitData:city date:checkDate];
                                                      }
                                                      
                                                      [item deselectRowAnimated:UITableViewRowAnimationAutomatic];
                                                  }];
    
    searchButton.textAlignment = NSTextAlignmentCenter;
    [self.searchSection addItem:searchButton];
}

- (void)fetchLimitData:(NSString *)city date:(NSString *)checkDate
{
    [MBProgressHUD showMessage:@"正在查询中..."];
    
    weakify(self)
    
    [LSLifeHelper trafficLimitDataWithCity:[self.limitCityInfo objectForKey:city] date:checkDate success:^(id json) {
        
        strongify(self);
        [self.resultSection removeAllItems];
        
        NSDictionary *dict = json;
        NSLog(@"dict: %@", dict);
        
        NSNumber *status = dict[@"status"];
        NSNumber *errNum = dict[@"errNum"];
        // 正确
        if( status && status.integerValue == 0 )
        {
            NSDictionary *retData = dict[@"result"];
            
            LSSubtitleItem *cityItem = [LSSubtitleItem itemWithTitle:@"城  市:" subTitle:city];
            [self.resultSection addItem:cityItem];
            
            LSSubtitleItem *checkDateItem = [LSSubtitleItem itemWithTitle:@"日  期:" subTitle:checkDate];
            [self.resultSection addItem:checkDateItem];
            
            NSString *week = retData[@"week"];
            LSSubtitleItem *weekItem = [LSSubtitleItem itemWithTitle:@"星  期:" subTitle:week];
            [self.resultSection addItem:weekItem];
            
            NSString *limittime      = [retData[@"time"] componentsJoinedByString:@","];
            if( [limittime isEqualToString:@""] )
            {
                limittime = @"无限制";
            }
            LSSubtitleItem *limittimeItem = [LSSubtitleItem itemWithTitle:@"限行时间:" subTitle:limittime];
            [self.resultSection addItem:limittimeItem];
            
            NSString *areaContent  = retData[@"area"];
            if( [areaContent isEqualToString:@""] )
            {
                areaContent = @"无限制";
                LSSubtitleItem *areasubItem = [LSSubtitleItem itemWithTitle:@"限行区域:" rightSubTitle:areaContent];
                [self.resultSection addItem:areasubItem];
            }
            else
            {
                RETableViewItem *areItem = [RETableViewItem itemWithTitle:@"限行区域:"];
                [self.resultSection addItem:areItem];
                
                areaContent = [[NSString alloc] initWithFormat:@"\t %@",areaContent];
                RELongTextItem *areaContentItem = [RELongTextItem itemWithValue:areaContent placeholder:nil];
                areaContentItem.cellHeight = 70;
                areaContentItem.editable = NO;
                [self.resultSection addItem:areaContentItem];
            }
            
            NSString *summary = retData[@"summary"];
            if( [summary isEqualToString:@""] )
            {
                summary = @"无";
                LSSubtitleItem *summaryItem = [LSSubtitleItem itemWithTitle:@"限行摘要:" rightSubTitle:summary];
                [self.resultSection addItem:summaryItem];
            }
            else
            {
                RETableViewItem *summaryItem = [RETableViewItem itemWithTitle:@"限行摘要:"];
                [self.resultSection addItem:summaryItem];
                
                summary = [[NSString alloc] initWithFormat:@"\t %@",summary];
                RELongTextItem *summaryContentItem = [RELongTextItem itemWithValue:summary placeholder:nil];
                summaryContentItem.cellHeight = 60;
                summaryContentItem.editable = NO;
                [self.resultSection addItem:summaryContentItem];
            }
            
            NSString *numberrule = retData[@"numberrule"];
            if( [numberrule isEqualToString:@""] )
            {
                numberrule = @"无";
            }
            LSSubtitleItem *numberruleItem = [LSSubtitleItem itemWithTitle:@"尾号规则:" subTitle:numberrule];
            [self.resultSection addItem:numberruleItem];
            
            NSString *linumber = retData[@"number"];
            if( [linumber isEqualToString:@""] )
            {
                linumber = @"无";
            }
            LSSubtitleItem *linumberItem = [LSSubtitleItem itemWithTitle:@"限行尾号:" subTitle:linumber];
            [self.resultSection addItem:linumberItem];
            
            [UIView animateWithDuration:0.2f animations:^{
                
                self.tableView.contentOffset = CGPointMake(self.offY.x, self.offY.y + 220);
                
            }];
        }
        else if( errNum && errNum.integerValue == 300207 )
        {
            // 超过每天10次
            [GCDTimer scheduledTimerWithTimeInterval:0.5f repeats:NO block:^{
                
                [MBProgressHUD showError:@"您今天使用已经超过10次"];
            }];
        }
        else
        {
            // 服务出错，稍后重试
            
            [GCDTimer scheduledTimerWithTimeInterval:0.5f repeats:NO block:^{
                
                [MBProgressHUD showError:@"服务出错，稍后重试!"];
            }];
        }
        
        [self.resultSection reloadSectionWithAnimation:UITableViewRowAnimationAutomatic];
        
        [MBProgressHUD hideHUD];
        
    } failure:^(NSError *error) {
        // 网络异常, 请检查一下网络
        
        NSLog(@"fetch error: %@", error);
        
        [MBProgressHUD hideHUD];
        
        [self.resultSection removeAllItems];
        [self.resultSection reloadSectionWithAnimation:UITableViewRowAnimationAutomatic];
        
        [GCDTimer scheduledTimerWithTimeInterval:0.3f repeats:NO block:^{
            
            [MBProgressHUD showError:@"网络异常!"];
        }];
    } timeoutInterval:15.0f];
    
}

- (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSString *currentDateString = [dateFormatter stringFromDate:date];

    return currentDateString;
}

//- (void)viewWillLayoutSubviews
//{
//    NSLog(@" %@ ", NSStringFromCGPoint(self.tableView.contentOffset));
//}

@end
