//
//  LSExpressSearchController.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/8.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSExpressSearchController.h"
#import "LSLifeToolHeader.h"
#import "RETableViewOptionsController.h"
#import "RELongTextItem.h"
#import "NirKxMenu.h"

#define kExpressKey @"LSExpressKey"

@interface LSExpressSearchController()

@property (strong, nonatomic) RETableViewManager *tableViewManager;
@property (strong, nonatomic) RETableViewSection *resultSection;
@property (strong, nonatomic) RETableViewSection *expressSection;
@property (strong, nonatomic) RETableViewSection *searchSection;
@property (strong, nonatomic) RERadioItem        *expressTypeItem;

@property (strong, nonatomic) NSMutableArray     *historyArray;
@property (strong, nonatomic) NSArray            *expressChinese;
@property (strong, nonatomic) NSArray            *expressType;
@property (strong, nonatomic) NSDictionary       *expressInfoDict;
@property (strong, nonatomic) UIButton           *rightButton;
@property (assign, nonatomic) CGPoint            offY;

@end

@implementation LSExpressSearchController

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
    
    [self initExpressInfo];
    
    NSArray *hisArray = [[NSUserDefaults standardUserDefaults] objectForKey:kExpressKey];
    
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
    
    self.title = @"快递查询";
    self.tableViewManager = ({
        
        RETableViewManager *manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
        manager.style.cellHeight = 44;
        
        manager;
    });
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = kCollectionHeaderColor;

    [self addExpressInputSection];
    [self addExpressResultSection];
    [self addExpressSearchSection];
    
    self.offY =  CGPointMake(0, -64);
}

- (void)initExpressInfo
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"expressCode" ofType:@".plist"];
    NSArray  *array  = [NSArray arrayWithContentsOfFile:path];

    NSMutableArray *exChinese = [[NSMutableArray alloc] init];
    NSMutableArray *exType    = [[NSMutableArray alloc] init];
    
    for(NSDictionary *element in array)
    {
        [exChinese addObject:[element valueForKey:@"name"]];
        [exType    addObject:[element objectForKey:@"code"]];
    }
    self.expressChinese = [NSArray arrayWithArray:exChinese];
    self.expressType    = [NSArray arrayWithArray:exType];
    self.expressInfoDict = [[NSDictionary alloc] initWithObjects:self.expressType forKeys:self.expressChinese];
    
}

#pragma mark - private method
- (void)addHistoryList:(CGRect)frame
{
    [KxMenu setTitleFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0f]];
    
    Color textColor = {0, 0, 0};
    Color bgColor   = {20/255.0, 61/255.0, 66/255.0};
    OptionalConfiguration options = { 9, 7, 9, 25, 6.5, true, false, true, false, textColor, bgColor };

    NSMutableArray *menuItems = [NSMutableArray array];
    for(NSString *express in self.historyArray)
    {
        KxMenuItem *kxItem = [KxMenuItem menuItem:express image:[UIImage imageNamed:@"history"] target:self action:@selector(respondOfMenu:)];
        [menuItems addObject:kxItem];
    }
    CGRect menuFrame = CGRectMake(self.rightButton.frame.origin.x,
                                  kNavigationBarHeight,
                                  self.rightButton.frame.size.width,
                                  self.rightButton.frame.size.height);
    
    [KxMenu showMenuInView:self.navigationController.view fromRect:menuFrame menuItems:menuItems withOptions:options];
}

- (void)addExpressInputSection
{
    UIImageView *IDPhoto = ({
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"a0"]];
        imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
        imageView.contentMode = UIViewContentModeCenter;
        imageView;
    });
    
    self.expressSection = ({
        
        RETableViewSection *IDCardSection = [RETableViewSection sectionWithHeaderView:IDPhoto];
        IDCardSection.footerTitle = @"提供20多个主流快递物流单号查询, 每天只可以查询10次";
        
        weakify(self)
        RERadioItem *radioItem = [RERadioItem itemWithTitle:@"快递公司:" value:@"顺丰" selectionHandler:^(RERadioItem *item) {
           
            RETableViewOptionsController *optionsVC = [[RETableViewOptionsController alloc] initWithItem:item options:self.expressChinese multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem) {
                
                strongify(self);
                
                [self.navigationController popViewControllerAnimated:YES];
                [item reloadRowWithAnimation:UITableViewRowAnimationNone];
            }];
            
            [self.navigationController pushViewController:optionsVC animated:YES];
        }];
        radioItem.textAlignment = NSTextAlignmentCenter;
        [IDCardSection addItem:radioItem];
        self.expressTypeItem = radioItem;
        
        RETextItem *textItem = [RETextItem itemWithTitle:@"快递单号:" value:nil placeholder:@"请输入有效快递单号"];
        [IDCardSection addItem:textItem];
        
        IDCardSection;
    });
    [self.tableViewManager addSection:self.expressSection];
}

- (void)addExpressResultSection
{
    self.resultSection = ({
        
        RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"查询结果: "];
        
        section;
    });
    
    [self.tableViewManager addSection:self.resultSection];
    
}

- (void)addExpressSearchSection
{
    self.searchSection = [RETableViewSection section];
    [self.tableViewManager addSection:self.searchSection];
    
    weakify(self)
    RETableViewItem *searchButton = [RETableViewItem itemWithTitle:@"查询"
                                                     accessoryType:UITableViewCellAccessoryNone
                                                  selectionHandler:^(RETableViewItem *item) {
                                                      
                                                      strongify(self);
                                                      
                                                      RETextItem *expressItem = [self.expressSection.items lastObject];
                                                      
                                                      if( expressItem.value )
                                                      {
                                                          [self fetchExpressData:self.expressTypeItem.value expressCode:expressItem.value];
                                                          
                                                      }
                                                      
                                                      [item deselectRowAnimated:UITableViewRowAnimationAutomatic];
                                                  }];
    
    searchButton.textAlignment = NSTextAlignmentCenter;
    [self.searchSection addItem:searchButton];
}

- (void)fetchExpressData:(NSString *)expressType expressCode:(NSString *)code
{
    [MBProgressHUD showMessage:@"正在查询中..."];
    
    weakify(self)
    NSString *exType = self.expressInfoDict[expressType];
    [LSLifeHelper expressDataWithNum:exType num:code success:^(id json) {
        
        strongify(self)
        [self.resultSection removeAllItems];
        
        NSDictionary *dict = json;
        NSLog(@"dict: %@", dict);
        
        NSNumber *errNum = dict[@"status"];
        
        if( errNum == nil )
        {
            [GCDTimer scheduledTimerWithTimeInterval:0.5f repeats:NO block:^{
                
                [MBProgressHUD showError:@"使用已经超过限制!"];
            }];
        }
        else
        {
            // 正确
            if( errNum.integerValue == 0 )
            {
                [self formatResult:dict];
                
                NSString *resultString = [NSString stringWithFormat:@"%@ - %@", expressType, code];
                
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
                
                [[NSUserDefaults standardUserDefaults] setValue:self.historyArray forKey:kExpressKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            //
            else if( errNum.integerValue == 203 )
            {
                [GCDTimer scheduledTimerWithTimeInterval:1.0f repeats:NO block:^{
                    
                    [MBProgressHUD showError:@"没有相应快递公司"];
                }];
            }
            //
            else if( errNum.integerValue == 205 )
            {
                [GCDTimer scheduledTimerWithTimeInterval:0.5f repeats:NO block:^{
                    
                    [MBProgressHUD showError:@"快递号&公司出错"];
                }];
            }

            else
            {
                // 服务出错，稍后重试
                
                [GCDTimer scheduledTimerWithTimeInterval:1.0f repeats:NO block:^{
                    
                    [MBProgressHUD showError:@"服务出错，稍后重试!"];
                }];
            }
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

- (void)formatResult:(NSDictionary *)dict
{
    NSDictionary *retData = [dict[@"result"] objectForKey:@"list"];
    
    NSLog(@"retData: %@", retData);
    
    NSMutableString *longText = [[NSMutableString alloc] init];
    for(NSDictionary *info in retData)
    {
        NSString *exTime = info[@"time"];
        NSString *exContent = info[@"status"];
        [longText appendString:@" ●   "];
        [longText appendString:exTime];
        [longText appendString:@"\n"];
        
        [longText appendString:@"\t"];
        [longText appendString:exContent];
        [longText appendString:@"\n"];
        
        [longText appendString:@"-------------------------------------------"];
        [longText appendString:@"\n"];
    }
    
    NSLog(@"longText %@", longText);
    RELongTextItem *exItem = [RELongTextItem itemWithTitle:nil value:longText];
    exItem.cellHeight = kScreenHeight * 0.34;
    exItem.editable = NO;
    [self.resultSection addItem:exItem];
    
    [UIView animateWithDuration:0.2f animations:^{
        
        self.tableView.contentOffset = CGPointMake(self.offY.x, self.offY.y + 54);
        
    }];
    
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
    
    NSArray *list = [item.title componentsSeparatedByString:@" - "];
    
    NSLog(@"title: %@", list);
    
    RERadioItem *exTypeItem = [self.expressSection.items firstObject];
    exTypeItem.value = [list firstObject];
    
    RETextItem *exCodeItem = [self.expressSection.items lastObject];
    exCodeItem.value = [list lastObject];
    
    [self.expressSection reloadSectionWithAnimation:UITableViewRowAnimationAutomatic];
    
    [self fetchExpressData:exTypeItem.value expressCode:exCodeItem.value];
}

@end
