//
//  LSTelephoneSearchController.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/8.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSTelephoneSearchController.h"
#import "LSLifeToolHeader.h"
#import "NirKxMenu.h"

#define kTelephone  @"LSTelephone"

@interface LSTelephoneSearchController()

@property (strong, nonatomic) RETableViewManager *tableViewManager;
@property (strong, nonatomic) RETableViewSection *resultSection;
@property (strong, nonatomic) RETableViewSection *telephoneSection;
@property (strong, nonatomic) RETableViewSection *searchSection;
@property (strong, nonatomic) UIButton           *rightButton;
@property (strong, nonatomic) NSMutableArray     *historyArray;

@end

@implementation LSTelephoneSearchController

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
    NSArray *hisArray = [[NSUserDefaults standardUserDefaults] objectForKey:kTelephone];
    
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

    self.title = @"电话归属地查询";
    self.tableViewManager = ({
        
        RETableViewManager *manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
        manager.style.cellHeight = 44;
        
        manager;
    });
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = kCollectionHeaderColor;
    
    [self addTelephoneInputSection];
    [self addTelephoneResultSection];
    [self addTelephoneSearchSection];
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

- (void)addTelephoneInputSection
{
    UIImageView *IDPhoto = ({
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"a0"]];
        imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
        imageView.contentMode = UIViewContentModeCenter;
        imageView;
    });
    
    self.telephoneSection = ({
        
        RETableViewSection *IDCardSection = [RETableViewSection sectionWithHeaderView:IDPhoto];
        IDCardSection.footerTitle = @"电话号码归属地查询, 查询次数无限制";
        
        RETextItem *textItem = [RETextItem itemWithTitle:@"电话号码:" value:nil placeholder:@"请输入有效电话号"];
        [IDCardSection addItem:textItem];
        textItem.keyboardType = UIKeyboardTypeNumberPad;
        IDCardSection;
    });
    [self.tableViewManager addSection:self.telephoneSection];
}

- (void)addTelephoneResultSection
{
    self.resultSection = ({
        
        RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"查询结果: "];
        
        section;
    });
    
    [self.tableViewManager addSection:self.resultSection];
    
}

- (void)addTelephoneSearchSection
{
    self.searchSection = [RETableViewSection section];
    [self.tableViewManager addSection:self.searchSection];
    
    weakify(self)
    RETableViewItem *searchButton = [RETableViewItem itemWithTitle:@"查询"
                                                     accessoryType:UITableViewCellAccessoryNone
                                                  selectionHandler:^(RETableViewItem *item) {
                                                      
                                                      strongify(self)
                                                      
                                                      RETextItem *telephoneItem = [self.telephoneSection.items lastObject];
                                                      
                                                      if( telephoneItem.value )
                                                      {
                                                          [self fetchTelephoneData: telephoneItem.value];
                                                      }
                                                      
                                                      [item deselectRowAnimated:UITableViewRowAnimationAutomatic];
                                                  }];
    
    searchButton.textAlignment = NSTextAlignmentCenter;
    [self.searchSection addItem:searchButton];
}

- (void)fetchTelephoneData:(NSString *)telephone
{
    [MBProgressHUD showMessage:@"正在查询中..."];
    
    weakify(self)
    [LSLifeHelper telephoneDataWithNum:telephone success:^(id json) {
        
        strongify(self)
        [self.resultSection removeAllItems];
        
        NSDictionary *dict = json;
        NSLog(@"dict: %@", dict);
        
        NSNumber *errNum = dict[@"errNum"];
        
        // 正确
        if( errNum.integerValue == 0 )
        {
            NSDictionary *retData = dict[@"retData"];
            
            NSString *phone = retData[@"phone"];
            LSSubtitleItem *phoneItem = [LSSubtitleItem itemWithTitle:@"电话  :" subTitle:phone];
            [self.resultSection addItem:phoneItem];
            
            NSString *province      = retData[@"province"];
            LSSubtitleItem *provinceItem = [LSSubtitleItem itemWithTitle:@"省份  :" subTitle:province];
            [self.resultSection addItem:provinceItem];
            
            NSString *city  = retData[@"city"];
            LSSubtitleItem *cityItem = [LSSubtitleItem itemWithTitle:@"城市  :" subTitle:city];
            [self.resultSection addItem:cityItem];
            
            NSString *suit = retData[@"suit"];
            LSSubtitleItem *suitItem = [LSSubtitleItem itemWithTitle:@"卡种  :" subTitle:suit];
            [self.resultSection addItem:suitItem];
            
            NSString *supplier      = retData[@"supplier"];
            LSSubtitleItem *supplierItem = [LSSubtitleItem itemWithTitle:@"运营商:" subTitle:supplier];
            [self.resultSection addItem:supplierItem];
            
            if( self.historyArray.count >= 5 )
            {
                [self.historyArray removeLastObject];
            }
            
            for (NSString *str in self.historyArray)
            {
                if ([telephone isEqualToString:str])
                {
                    [self.historyArray removeObject:str];
                    break;
                }
            }
            
            [self.historyArray insertObject:telephone atIndex:0];
            
            if( self.historyArray.count > 0 )
            {
                self.rightButton.hidden = NO;
            }
            
            [[NSUserDefaults standardUserDefaults] setValue:self.historyArray forKey:kTelephone];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        //
        else if( errNum.integerValue == -1 )
        {
            [GCDTimer scheduledTimerWithTimeInterval:0.5f repeats:NO block:^{
                
                [MBProgressHUD showError:@"此号码不是合法的手机号!"];
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
        
        [GCDTimer scheduledTimerWithTimeInterval:0.5f repeats:NO block:^{
            
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
    
    RETextItem *telephoneItem = [self.telephoneSection.items firstObject];
    telephoneItem.value = item.title;
    [self.telephoneSection reloadSectionWithAnimation:UITableViewRowAnimationAutomatic];
    
    [self fetchTelephoneData:item.title];
    
}


@end

