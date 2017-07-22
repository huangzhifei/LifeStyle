//
//  LSAppleSNSearchController.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/8.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSAppleSNSearchController.h"
#import "LSLifeToolHeader.h"
#import "NirKxMenu.h"

#define kAppleSNKey @"LSAppleSNKey"

@interface LSAppleSNSearchController()

@property (strong, nonatomic) RETableViewManager *tableViewManager;
@property (strong, nonatomic) RETableViewSection *resultSection;
@property (strong, nonatomic) RETableViewSection *appleSNSection;
@property (strong, nonatomic) RETableViewSection *searchSection;
@property (assign, nonatomic) CGPoint            offY;
@property (strong, nonatomic) UIButton           *rightButton;
@property (strong, nonatomic) NSMutableArray     *historyArray;

@end

@implementation LSAppleSNSearchController

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
    
    NSArray *hisArray = [[NSUserDefaults standardUserDefaults] objectForKey:kAppleSNKey];
    
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

    self.title = @"苹果序列号查询";
    self.tableViewManager = ({
        
        RETableViewManager *manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
        manager.style.cellHeight = 44;
        
        manager;
    });
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = kCollectionHeaderColor;
    
    [self addSNInputSection];
    [self addSNResultSection];
    [self addSNSearchSection];
    
    self.offY =  CGPointMake(0, -64);
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

- (void)addSNInputSection
{
    UIImageView *IDPhoto = ({
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"a0"]];
        imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
        imageView.contentMode = UIViewContentModeCenter;
        imageView;
    });
    
    self.appleSNSection = ({
        
        RETableViewSection *IDCardSection = [RETableViewSection sectionWithHeaderView:IDPhoto];
        IDCardSection.footerTitle = @"苹果设备的序列号, 每天只能查询50次";
        
        RETextItem *textItem = [RETextItem itemWithTitle:@"设备序列号:" value:nil placeholder:@"请输入有效序列号"];
        [IDCardSection addItem:textItem];
        
        IDCardSection;
    });
    [self.tableViewManager addSection:self.appleSNSection];
}

- (void)addSNResultSection
{
    self.resultSection = ({
        
        RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"查询结果: "];
        
        section;
    });
    
    [self.tableViewManager addSection:self.resultSection];
    
}

- (void)addSNSearchSection
{
    self.searchSection = [RETableViewSection section];
    [self.tableViewManager addSection:self.searchSection];
    
    weakify(self)
    RETableViewItem *searchButton = [RETableViewItem itemWithTitle:@"查询"
                                                     accessoryType:UITableViewCellAccessoryNone
                                                  selectionHandler:^(RETableViewItem *item) {
                                                      
                                                      strongify(self)
                                                      
                                                      RETextItem *SNItem = [self.appleSNSection.items lastObject];
                                                      
                                                      if( SNItem.value )
                                                      {
                                                          [self fetchSNData: SNItem.value];
                                                      }
                                                      
                                                      [item deselectRowAnimated:UITableViewRowAnimationAutomatic];
                                                  }];
    
    searchButton.textAlignment = NSTextAlignmentCenter;
    [self.searchSection addItem:searchButton];
}

- (void)fetchSNData:(NSString *)SNCode
{
    [MBProgressHUD showMessage:@"正在查询中..."];
    
    weakify(self)
    [LSLifeHelper appleIMEIDataWithSN:SNCode success:^(id json) {
        
        strongify(self);
        [self.resultSection removeAllItems];
        
        NSDictionary *retData = json;
        NSLog(@"dict: %@", retData);
        
        NSString *model = retData[@"model"];
        LSSubtitleItem *modelItem = [LSSubtitleItem itemWithTitle:@"设备类型  :" subTitle:model];
        [self.resultSection addItem:modelItem];
        
        NSString *capacity = retData[@"capacity"];
        LSSubtitleItem *capacityItem = [LSSubtitleItem itemWithTitle:@"设备容量  :" subTitle:capacity];
        [self.resultSection addItem:capacityItem];
        
        NSString *productColor = retData[@"color"];
        LSSubtitleItem *productColorItem = [LSSubtitleItem itemWithTitle:@"设备颜色  :" subTitle:productColor];
        [self.resultSection addItem:productColorItem];
        
        NSString *product = retData[@"product"];
        LSSubtitleItem *productItem = [LSSubtitleItem itemWithTitle:@"产品类型  :" subTitle:product];
        [self.resultSection addItem:productItem];
        
        NSString *activated      = retData[@"activated"];
        activated = ([activated isEqualToString:@"0"]) ? @"未激活" : @"已激活";
        LSSubtitleItem *activatedItem = [LSSubtitleItem itemWithTitle:@"激活状态  :" subTitle:activated];
        [self.resultSection addItem:activatedItem];
        
        NSString *activatedtime  = retData[@"time"];
        LSSubtitleItem *activatedtimeItem = [LSSubtitleItem itemWithTitle:@"激活时间  :" subTitle:activatedtime];
        [self.resultSection addItem:activatedtimeItem];
        
        NSString *startTime = retData[@"start"];
        NSString *endTime   = retData[@"end"];
        NSString *start4end = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
        LSSubtitleItem *start4endItem = [LSSubtitleItem itemWithTitle:@"出场日期  :" subTitle:start4end];
        [self.resultSection addItem:start4endItem];
        
        NSString *warranty      = retData[@"warranty"];
        warranty = ([warranty isEqualToString:@"0"]) ? @"已经过保修期" : warranty;
        LSSubtitleItem *warrantyItem = [LSSubtitleItem itemWithTitle:@"保修时间  :" subTitle:warranty];
        [self.resultSection addItem:warrantyItem];
        
        NSString *origin = retData[@"origin"];
        LSSubtitleItem *originItem = [LSSubtitleItem itemWithTitle:@"生产产地  :" subTitle:origin];
        [self.resultSection addItem:originItem];
        
        NSString *mlocked = retData[@"locked"];
        mlocked = ([mlocked isEqualToString:@"0"]) ? @"关闭" : @"锁定";
        LSSubtitleItem *lockedItem = [LSSubtitleItem itemWithTitle:@"激活锁状态:" subTitle:mlocked];
        [self.resultSection addItem:lockedItem];
        
        if( self.historyArray.count >= 5 )
        {
            [self.historyArray removeLastObject];
        }
        
        for (NSString *str in self.historyArray)
        {
            if ([SNCode isEqualToString:str])
            {
                [self.historyArray removeObject:SNCode];
                break;
            }
        }
        
        [self.historyArray insertObject:SNCode atIndex:0];
        
        if( self.historyArray.count > 0 )
        {
            self.rightButton.hidden = NO;
        }

        [self.resultSection reloadSectionWithAnimation:UITableViewRowAnimationAutomatic];
        
        [[NSUserDefaults standardUserDefaults] setValue:self.historyArray forKey:kAppleSNKey];
        [[NSUserDefaults standardUserDefaults] synchronize];

//        [UIView animateWithDuration:0.2f animations:^{
//            
//            self.tableView.contentOffset = CGPointMake(self.offY.x, self.offY.y + 186);
//            
//        }];
        
        [MBProgressHUD hideHUD];
        
    } failure:^(NSError *error) {
        // 网络异常, 请检查一下网络
        
        NSLog(@"fetch error: %@", error);
        
        [MBProgressHUD hideHUD];
        
        [self.resultSection removeAllItems];
        [self.resultSection reloadSectionWithAnimation:UITableViewRowAnimationAutomatic];
        
        NSString *showMessage;
        if( [error.localizedDescription containsString:@"The Internet connection appears to be offline"] )
        {
            showMessage = @"网络异常!";
        }
        else if( [error.localizedDescription containsString:@"it isn’t in the correct format"] )
        {
            showMessage = @"服务端异常";
        }
        [GCDTimer scheduledTimerWithTimeInterval:0.5f repeats:NO block:^{
            
            [MBProgressHUD showError:showMessage];
        }];
        
    } timeoutInterval:15.0f];
    
}

- (void)viewWillLayoutSubviews
{
    NSLog(@"offY %@", NSStringFromCGPoint(self.tableView.contentOffset));
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
    
    RETextItem *SNItem = [self.appleSNSection.items firstObject];
    SNItem.value = item.title;
    [self.appleSNSection reloadSectionWithAnimation:UITableViewRowAnimationAutomatic];
    
    [self fetchSNData:item.title];
}

@end

