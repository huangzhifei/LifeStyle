//
//  LSCoachSearchController.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/8.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSCoachSearchController.h"
#import "LSLifeToolHeader.h"
#import "LSCoachListController.h"
#import "LSCoachDetailItem.h"
#import "NirKxMenu.h"

#define kCoachKey   @"LSCoachKey"

@interface LSCoachSearchController()

@property (strong, nonatomic) RETableViewManager *tableViewManager;
@property (strong, nonatomic) RETableViewSection *resultSection;
@property (strong, nonatomic) RETableViewSection *cocachSection;
@property (strong, nonatomic) RETableViewSection *searchSection;

@property (strong, nonatomic) UIButton           *rightButton;
@property (strong, nonatomic) NSMutableArray     *historyArray;

@end

@implementation LSCoachSearchController

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
    
    NSArray *hisArray = [[NSUserDefaults standardUserDefaults] objectForKey:kCoachKey];
    
    if(hisArray == nil)
    {
        self.historyArray = [NSMutableArray array];
    }
    else
    {
        self.historyArray = [[NSMutableArray alloc] initWithArray:hisArray copyItems:YES];
    }
    
    self.navigationItem.rightBarButtonItem = ({
        
        UIImage *image = [[UIImage imageNamed:@"history"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        self.rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.rightButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [self.rightButton setImage:image forState:UIControlStateNormal];
        [self.rightButton addTarget:self action:@selector(popMenu) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
        
        item;
    });
    if( self.historyArray.count <= 0 )
    {
        self.rightButton.hidden = YES;
    }

    self.title = @"长途汽车查询";
    self.tableViewManager = ({
        
        RETableViewManager *manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
        manager.style.cellHeight = 44;
        
        manager;
    });
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = kCollectionHeaderColor;
    
    [self addCoachInputSection];
    [self addCoachResultSection];
    [self addCoachSearchSection];
}

#pragma mark - private method
- (void)addHistoryList:(CGRect)frame
{
    [KxMenu setTitleFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0f]];
    
    Color textColor = {0, 0, 0};
    Color bgColor   = {20/255.0, 61/255.0, 66/255.0};
    OptionalConfiguration options = { 9, 7, 9, 25, 6.5, true, false, true, false, textColor, bgColor };
    
    NSMutableArray *menuItems = [NSMutableArray array];
    for(NSString *area in self.historyArray)
    {
        KxMenuItem *kxItem = [KxMenuItem menuItem:area image:[UIImage imageNamed:@"history"] target:self action:@selector(respondOfMenu:)];
        [menuItems addObject:kxItem];
    }
    CGRect menuFrame = CGRectMake(self.rightButton.frame.origin.x,
                                  kNavigationBarHeight,
                                  self.rightButton.frame.size.width,
                                  self.rightButton.frame.size.height);
    
    [KxMenu showMenuInView:self.navigationController.view fromRect:menuFrame menuItems:menuItems withOptions:options];
}

- (void)addCoachInputSection
{
    UIImageView *IDPhoto = ({
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"a0"]];
        imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
        imageView.contentMode = UIViewContentModeCenter;
        imageView;
    });
    
    self.cocachSection = ({
        
        RETableViewSection *IDCardSection = [RETableViewSection sectionWithHeaderView:IDPhoto];
        IDCardSection.footerTitle = @"长途汽车查询, 每天查询次数只有10次";
        
        RETextItem *startCityItem = [RETextItem itemWithTitle:@"出发城市:" value:nil placeholder:@"输入城市名 - 例如:深圳"];
        [IDCardSection addItem:startCityItem];
        
        RETextItem *endCityItem = [RETextItem itemWithTitle:@"到达城市:" value:nil placeholder:@"输入城市名 - 例如:广州"];
        [IDCardSection addItem:endCityItem];
        
        IDCardSection;
    });
    [self.tableViewManager addSection:self.cocachSection];
}

- (void)addCoachResultSection
{
    self.resultSection = ({
        
        RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"查询结果: "];
        
        section;
    });
    
    [self.tableViewManager addSection:self.resultSection];
}

- (void)addCoachSearchSection
{
    self.searchSection = [RETableViewSection section];
    [self.tableViewManager addSection:self.searchSection];
    
    weakify(self)
    RETableViewItem *searchButton = [RETableViewItem itemWithTitle:@"查询"
                                                     accessoryType:UITableViewCellAccessoryNone
                                                  selectionHandler:^(RETableViewItem *item) {
                                                      
                                                      strongify(self)
                                                      
                                                      RETextItem *startCityItem = [self.cocachSection.items firstObject];
                                                      RETextItem *endCityItem = [self.cocachSection.items lastObject];
                                                      if( startCityItem.value && endCityItem.value )
                                                      {
                                                          [self fetchCocachData:startCityItem.value end:endCityItem.value];
                                                      }
                                                      
                                                      [item deselectRowAnimated:UITableViewRowAnimationAutomatic];
                                                  }];
    
    searchButton.textAlignment = NSTextAlignmentCenter;
    [self.searchSection addItem:searchButton];

}

- (void)fetchCocachData:(NSString *)startCity end:(NSString *)endCity
{
    [MBProgressHUD showMessage:@"正在查询中..."];
    
    weakify(self);
    
    [ LSLifeHelper coachDataWithName:startCity to:endCity success:^(id json) {
        
        strongify(self);
        NSDictionary *dict = json;
        NSLog(@"dict: %@", dict);
        
        NSNumber *status = dict[@"status"];
        NSNumber *errNum = dict[@"errNum"];
        
        NSMutableDictionary *Mapresult = [NSMutableDictionary dictionary];
        if( status && status.integerValue == 0 )
        {
            NSArray *resultList = dict[@"result"];
            
            NSLog(@"result count: %ld", (unsigned long)resultList.count);
            
            for( NSDictionary *dictValue in resultList )
            {
                LSCoachDetailItem *detailItem = [[LSCoachDetailItem alloc] init];
                
                detailItem.startCity        = dictValue[@"startcity"];
                detailItem.endCity          = dictValue[@"endcity"];
                detailItem.startStation     = dictValue[@"startstation"];
                detailItem.endStation       = dictValue[@"endstation"];
                detailItem.departureTime    = dictValue[@"starttime"];
                detailItem.price            = dictValue[@"price"];
                detailItem.busType          = dictValue[@"bustype"];
                detailItem.distance         = dictValue[@"distance"];
                
                NSMutableArray *MapResultValue = [Mapresult objectForKey:detailItem.departureTime];
                if( MapResultValue == nil )
                {
                    MapResultValue = [NSMutableArray array];
                }
                [MapResultValue addObject:detailItem];
                [Mapresult setObject:MapResultValue forKey:detailItem.departureTime];
            }
            
            NSString *resultString = [NSString stringWithFormat:@"%@ - %@", startCity, endCity];
            
            if( self.historyArray.count >= 5 )
            {
                [self.historyArray removeLastObject];
            }
            
            for (NSString *str in self.historyArray)
            {
                if ([resultString isEqualToString:str])
                {
                    [self.historyArray removeObject:str];
                    break;
                }
            }
            
            [self.historyArray insertObject:resultString atIndex:0];
            
            if( self.historyArray.count > 0 )
            {
                self.rightButton.hidden = NO;
            }
            
            [[NSUserDefaults standardUserDefaults] setValue:self.historyArray forKey:kCoachKey];
            [[NSUserDefaults standardUserDefaults] synchronize];

            // 跳转 list VC
            LSCoachListController *listVC = [[LSCoachListController alloc] init];
            listVC.fromCity = startCity;
            listVC.toCity   = endCity;
            listVC.listCoach = Mapresult;
            [self.navigationController pushViewController:listVC animated:YES];
            
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

    } timeoutInterval:25.0f];
}

#pragma mark - events
- (void)popMenu
{
    [self addHistoryList:CGRectMake(0, 0, 32, 32)];
}

- (void)respondOfMenu:(id)sender
{
    KxMenuItem *item = (KxMenuItem *)sender;
    
    NSLog(@"title: %@", item.title);
    
    NSArray *listItem = [item.title componentsSeparatedByString:@" - "];
    
    RETextItem *startCityItem = [self.cocachSection.items firstObject];
    startCityItem.value = [listItem firstObject];
    
    RETextItem *endCityItem = [self.cocachSection.items lastObject];
    endCityItem.value = [listItem lastObject];
    
    [self.cocachSection reloadSectionWithAnimation:UITableViewRowAnimationAutomatic];
    
    [self fetchCocachData:startCityItem.value end:endCityItem.value];
}

@end

