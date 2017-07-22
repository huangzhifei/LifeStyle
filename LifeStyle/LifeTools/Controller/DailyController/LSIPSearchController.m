//
//  LSIPSearchController.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/8.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSIPSearchController.h"
#import "LSLifeToolHeader.h"
#import "NirKxMenu.h"

#define kIPKey  @"LSIPKey"

@interface LSIPSearchController()

@property (strong, nonatomic) RETableViewManager *tableViewManager;
@property (strong, nonatomic) RETableViewSection *resultSection;
@property (strong, nonatomic) RETableViewSection *IPSection;
@property (strong, nonatomic) RETableViewSection *searchSection;
@property (strong, nonatomic) UIButton           *rightButton;
@property (strong, nonatomic) NSMutableArray     *historyArray;

@end

@implementation LSIPSearchController

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
    
    NSArray *hisArray = [[NSUserDefaults standardUserDefaults] objectForKey:kIPKey];
    
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

    self.title = @"IP地址查询";
    self.tableViewManager = ({
        
        RETableViewManager *manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
        manager.style.cellHeight = 44;
        
        manager;
    });
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = kCollectionHeaderColor;
    
    [self addIPInputSection];
    [self addIPResultSection];
    [self addIPSearchSection];
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

- (void)addIPInputSection
{
    UIImageView *IDPhoto = ({
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"a0"]];
        imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
        imageView.contentMode = UIViewContentModeCenter;
        imageView;
    });
    
    self.IPSection = ({
        
        RETableViewSection *IDCardSection = [RETableViewSection sectionWithHeaderView:IDPhoto];
        IDCardSection.footerTitle = @"提供国内大部分IP，特殊IP(保留IP、私有地址、广播地址、组播地址等) 国家显示为未知，运营商也为未知, 查询次数无限制";
        
        RETextItem *textItem = [RETextItem itemWithTitle:@"IP地址:" value:nil placeholder:@"请输入有效的IP地址"];
        textItem.keyboardType = UIKeyboardTypeDecimalPad;
        [IDCardSection addItem:textItem];
        
        IDCardSection;
    });
    [self.tableViewManager addSection:self.IPSection];
}

- (void)addIPResultSection
{
    self.resultSection = ({
        
        RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"查询结果: "];
        
        section;
    });
    
    [self.tableViewManager addSection:self.resultSection];
    
}

- (void)addIPSearchSection
{
    self.searchSection = [RETableViewSection section];
    [self.tableViewManager addSection:self.searchSection];
    
    weakify(self)
    RETableViewItem *searchButton = [RETableViewItem itemWithTitle:@"查询"
                                                     accessoryType:UITableViewCellAccessoryNone
                                                  selectionHandler:^(RETableViewItem *item) {
                                                      
                                                      strongify(self);
                                                      
                                                      RETextItem *IDCardItem = [self.IPSection.items firstObject];
                                                      
                                                      if( IDCardItem.value )
                                                      {
                                                          [self fetchIPData:IDCardItem.value];
                                                      }
                                                      
                                                      [item deselectRowAnimated:UITableViewRowAnimationAutomatic];
                                                  }];
    
    searchButton.textAlignment = NSTextAlignmentCenter;
    [self.searchSection addItem:searchButton];
}

- (void)fetchIPData:(NSString *)IPNum
{
    [MBProgressHUD showMessage:@"正在查询中..."];
    
    weakify(self)
    
    [LSLifeHelper ipDataWithPICode:IPNum success:^(id json) {
        
        strongify(self)
        [self.resultSection removeAllItems];
        
        NSDictionary *dict = json;
        NSLog(@"dict: %@", dict);
        
        NSNumber *errNum = dict[@"errNum"];
        
        // 正确
        if( errNum && errNum.integerValue == 0 )
        {
            NSDictionary *retData = dict[@"retData"];
            
            NSString *ipString = retData[@"ip"];
            LSSubtitleItem *ipStringItem = [LSSubtitleItem itemWithTitle:@"ip :" subTitle:ipString];
            [self.resultSection addItem:ipStringItem];
            
            NSString *country      = retData[@"country"];
            NSString *countryName = ([country isEqualToString:@"None"]) ? @"未知" : country;
            LSSubtitleItem *countryItem = [LSSubtitleItem itemWithTitle:@"国 家: " subTitle:countryName];
            [self.resultSection addItem:countryItem];
            
            NSString *province  = retData[@"province"];
            NSString *provinceName = ([province isEqualToString:@"None"]) ? @"未知" : province;
            LSSubtitleItem *provinceItem = [LSSubtitleItem itemWithTitle:@"省 份:" subTitle:provinceName];
            [self.resultSection addItem:provinceItem];
            
            NSString *city = retData[@"city"];
            NSString *cityName = ([city isEqualToString: @"None"]) ? @"未知" : city;
            LSSubtitleItem *cityItem = [LSSubtitleItem itemWithTitle:@"城 市: " subTitle:cityName];
            [self.resultSection addItem:cityItem];
            
            NSString *district = retData[@"district"];
            NSString *districtName = ([district isEqualToString: @"None"]) ? @"未知" : district;
            LSSubtitleItem *districtItem = [LSSubtitleItem itemWithTitle:@"地 区: " subTitle:districtName];
            [self.resultSection addItem:districtItem];
            
            NSString *carrier = retData[@"carrier"];
            NSString *carrierName = (carrier == nil) ? @"未知" : carrier;
            LSSubtitleItem *carrierItem = [LSSubtitleItem itemWithTitle:@"运营商:" subTitle:carrierName];
            [self.resultSection addItem:carrierItem];
            
            if( self.historyArray.count >= 5 )
            {
                [self.historyArray removeObject:IPNum];
            }
            
            for (NSString *str in self.historyArray)
            {
                if ([IPNum isEqualToString:str])
                {
                    [self.historyArray removeLastObject];
                    break;
                }
            }
            
            [self.historyArray insertObject:IPNum atIndex:0];
            
            if( self.historyArray.count > 0 )
            {
                self.rightButton.hidden = NO;
            }
            
            [[NSUserDefaults standardUserDefaults] setValue:self.historyArray forKey:kIPKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        // 身份证格式不对
        else if( errNum.integerValue == 1 )
        {
            [GCDTimer scheduledTimerWithTimeInterval:0.5f repeats:NO block:^{
                
                [MBProgressHUD showError:@"无效的IP地址!"];
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
    
    RETextItem *IPItem = [self.IPSection.items firstObject];
    IPItem.value = item.title;
    [self.IPSection reloadSectionWithAnimation:UITableViewRowAnimationAutomatic];
    
    [self fetchIPData:item.title];
}

@end
