//
//  LSPostCodeSearchController.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/8.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSPostCodeSearchController.h"
#import "LSLifeToolHeader.h"
#import "LSSubtitleItem.h"
#import "NirKxMenu.h"

#define kPostKey    @"LSPostKey"

@interface LSPostCodeSearchController()

@property (strong, nonatomic) RETableViewManager *tableViewManager;
@property (strong, nonatomic) RETableViewSection *resultSection;
@property (strong, nonatomic) RETableViewSection *areaSection;
@property (strong, nonatomic) RETableViewSection *searchSection;

@property (strong, nonatomic) UIButton           *rightButton;
@property (strong, nonatomic) NSMutableArray     *historyArray;

@end

@implementation LSPostCodeSearchController

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
    
    NSArray *hisArray = [[NSUserDefaults standardUserDefaults] objectForKey:kPostKey];
    
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
    
    self.title = @"邮编查询";
    self.tableViewManager = ({
        
        RETableViewManager *manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
        manager.style.cellHeight = 44;
        
        manager;
    });

    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = kCollectionHeaderColor;
    
    [self addAreaInputSection];
    [self addAreaResultSection];
    [self addAreaSearchSection];
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

- (void)addAreaInputSection
{
    UIImageView *IDPhoto = ({
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"a0"]];
        imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
        imageView.contentMode = UIViewContentModeCenter;
        imageView;
    });
    
    self.areaSection = ({
        
        RETableViewSection *IDCardSection = [RETableViewSection sectionWithHeaderView:IDPhoto];
        IDCardSection.footerTitle = @"全国30多个省市县的邮编号码查询，精确到区、县、街道。支持按模糊地址查询邮编。每天只可以查询10次";
        
        RETextItem *textItem = [RETextItem itemWithTitle:@"查询地址:" value:nil placeholder:@"请尽量输入有效查询地址"];
        [IDCardSection addItem:textItem];
        
        IDCardSection;
    });
    [self.tableViewManager addSection:self.areaSection];
}

- (void)addAreaResultSection
{
    self.resultSection = ({
        
        RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"查询结果: "];
        
        section;
    });
    
    [self.tableViewManager addSection:self.resultSection];
    
}

- (void)addAreaSearchSection
{
    self.searchSection = [RETableViewSection section];
    [self.tableViewManager addSection:self.searchSection];
    
    weakify(self)
    RETableViewItem *searchButton = [RETableViewItem itemWithTitle:@"查询"
                                                     accessoryType:UITableViewCellAccessoryNone
                                                  selectionHandler:^(RETableViewItem *item) {
                                                      
                                                      strongify(self)
                                                      
                                                      RETextItem *AreaItem = [self.areaSection.items firstObject];
                                                      
                                                      if( AreaItem.value )
                                                      {
                                                          [self fetchPostCodeData:AreaItem.value];
                                                      }
                                                      
                                                      [item deselectRowAnimated:UITableViewRowAnimationAutomatic];
                                                  }];
    
    searchButton.textAlignment = NSTextAlignmentCenter;
    [self.searchSection addItem:searchButton];
}

- (void)fetchPostCodeData:(NSString *)AreaName
{
    [MBProgressHUD showMessage:@"正在查询中..."];
    
    weakify(self)
    
    [LSLifeHelper postCodeDataWithCity:AreaName success:^(id json) {
        
        strongify(self)
        [self.resultSection removeAllItems];
        
        NSDictionary *dict = json;
        NSLog(@"dict: %@", dict);
        
        NSNumber *status = dict[@"status"];
        NSNumber *errNum = dict[@"errNum"];
        // 正确
        if( status && status.integerValue == 0 )
        {
            NSDictionary *retData = [dict[@"result"] firstObject];
            
            NSString *province = retData[@"province"];
            if( ![province isEqualToString:@""] )
            {
                LSSubtitleItem *provinceItem = [LSSubtitleItem itemWithTitle:@"省份:" subTitle:province];
                [self.resultSection addItem:provinceItem];
            }
            
            NSString *city      = retData[@"city"];
            LSSubtitleItem *cityItem = [LSSubtitleItem itemWithTitle:@"城市:" subTitle:city];
            [self.resultSection addItem:cityItem];
            
            NSString *town      = retData[@"town"];
            NSLog(@"town: %@", town);
            if( ![town isEqualToString:@""] )
            {
                town = (town == nil) ? @"未知" : town;
                LSSubtitleItem *townItem = [LSSubtitleItem itemWithTitle:@"县镇:" subTitle:town];
                [self.resultSection addItem:townItem];
            }
            
            NSString *address  = retData[@"address"];
            NSLog(@"address: %@", address);
            if( ![address isEqualToString:@""] )
            {
                address = (address == nil) ? @"未知" : address;
                LSSubtitleItem *addressItem = [LSSubtitleItem itemWithTitle:@"地址:" subTitle:address];
                [self.resultSection addItem:addressItem];
            }
            NSString *postCode = retData[@"zipcode"];
            postCode = ([postCode isEqualToString:@""]) ? @"未知" : postCode;
            LSSubtitleItem *postCodeItem = [LSSubtitleItem itemWithTitle:@"邮编:" subTitle:postCode];
            [self.resultSection addItem:postCodeItem];
            
            if( self.historyArray.count >= 5 )
            {
                [self.historyArray removeLastObject];
            }

            for (NSString *str in self.historyArray)
            {
                if ([AreaName isEqualToString:str])
                {
                    [self.historyArray removeObject:str];
                    break;
                }
            }
            
            [self.historyArray insertObject:AreaName atIndex:0];
            
            if( self.historyArray.count > 0 )
            {
                self.rightButton.hidden = NO;
            }
            
            [[NSUserDefaults standardUserDefaults] setValue:self.historyArray forKey:kPostKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
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

#pragma mark - events
- (void)popMenu
{
    [self addHistoryList:CGRectMake(0, 0, 32, 32)];
}

- (void)respondOfMenu:(id)sender
{
    NSLog(@"sender: %@", sender);
    
    KxMenuItem *item = (KxMenuItem *)sender;
    
    NSLog(@"title: %@", item.title);
    
    RETextItem *AreaItem = [self.areaSection.items firstObject];
    AreaItem.value = item.title;
    [self.areaSection reloadSectionWithAnimation:UITableViewRowAnimationAutomatic];
    
    [self fetchPostCodeData:item.title];
}

@end
