//
//  LSCurrencySearchController.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/12.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSCurrencySearchController.h"
#import "LSLifeToolHeader.h"
#import "LSSubtitleItem.h"
#import "RETableViewOptionsController.h"

#define ErrNum      @"errNum"
#define RetData     @"retData"

@interface LSCurrencySearchController()

@property (strong, nonatomic) RETableViewManager *tableViewManager;
@property (strong, nonatomic) RETableViewSection *resultSection;
@property (strong, nonatomic) RETableViewSection *currencySection;
@property (strong, nonatomic) RETableViewSection *searchSection;
@property (strong, nonatomic) RERadioItem        *fromCurrencyItem;
@property (strong, nonatomic) RERadioItem        *toCurrencyItem;
@property (strong, nonatomic) NSArray            *currentArray;

@end

@implementation LSCurrencySearchController

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
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Currency" ofType:@".plist"];
    self.currentArray  = [NSArray arrayWithContentsOfFile:path];
    
    self.title = @"货币汇率换算";
    self.tableViewManager = ({
        
        RETableViewManager *manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
        manager.style.cellHeight = 44;
        
        manager;
    });
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = kCollectionHeaderColor;
    
    [self addCurrencyInputSection];
    [self addCurrencyResultSection];
    [self addCurrencySearchSection];
}

#pragma mark - private method
- (void)addCurrencyInputSection
{
    UIImageView *IDPhoto = ({
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"a0"]];
        imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
        imageView.contentMode = UIViewContentModeCenter;
        imageView;
    });
    
    self.currencySection = ({
        
        RETableViewSection *IDCardSection = [RETableViewSection sectionWithHeaderView:IDPhoto];
        IDCardSection.footerTitle = @"提供当前时间的汇率下，一个币种到另一个币种之间一定金额的转换；汇率值是实时更新的, 查询次数无限制";
        
        weakify(self)
        
        self.fromCurrencyItem = [RERadioItem itemWithTitle:@"兑换币种:" value:@"CNY - 人民币" selectionHandler:^(RERadioItem *item) {
            
            RETableViewOptionsController *optionsVC = [[RETableViewOptionsController alloc] initWithItem:item options:self.currentArray multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem) {
                
                strongify(self);
                
                [self.navigationController popViewControllerAnimated:YES];
                [item reloadRowWithAnimation:UITableViewRowAnimationNone];
            }];
            
            [self.navigationController pushViewController:optionsVC animated:YES];
            
        }];
        [IDCardSection addItem:self.fromCurrencyItem];
        
        self.toCurrencyItem = [RERadioItem itemWithTitle:@"换入币种:" value:@"USD - 美元" selectionHandler:^(RERadioItem *item) {
            
            strongify(self);
            
            RETableViewOptionsController *optionsVC = [[RETableViewOptionsController alloc] initWithItem:item options:self.currentArray multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem) {
                
                strongify(self);
                
                [self.navigationController popViewControllerAnimated:YES];
                [item reloadRowWithAnimation:UITableViewRowAnimationNone];
            }];
            
            [self.navigationController pushViewController:optionsVC animated:YES];
            
        }];
        
        [IDCardSection addItem:self.toCurrencyItem];
        
        RETextItem *textItem = [RETextItem itemWithTitle:@"兑换金额:" value:nil placeholder:@""];
        textItem.keyboardType = UIKeyboardTypeDecimalPad;
        
        [IDCardSection addItem:textItem];
        
        IDCardSection;
    });
    [self.tableViewManager addSection:self.currencySection];
}

- (void)addCurrencyResultSection
{
    self.resultSection = ({
        
        RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"查询结果: "];
        
        section;
    });
    
    [self.tableViewManager addSection:self.resultSection];
    
}

- (void)addCurrencySearchSection
{
    self.searchSection = [RETableViewSection section];
    [self.tableViewManager addSection:self.searchSection];
    
    weakify(self)
    RETableViewItem *searchButton = [RETableViewItem itemWithTitle:@"查询"
                                                     accessoryType:UITableViewCellAccessoryNone
                                                  selectionHandler:^(RETableViewItem *item) {
                                                      
                                                      strongify(self);
                                                      
                                                      RETextItem *amountItem = [self.currencySection.items lastObject];
                                                      
                                                      if( amountItem.value )
                                                      {
                                                          NSArray *list = [self.fromCurrencyItem.value componentsSeparatedByString:@" - "];
                                                          NSString *fromC = [list firstObject];
                                                          
                                                          list = [self.toCurrencyItem.value componentsSeparatedByString:@" - "];
                                                          NSString *toC = [list firstObject];
                                                          
                                                          [self fetchCurrencyData:fromC to:toC amount:amountItem.value];
                                                      }
                                                      
                                                      [item deselectRowAnimated:UITableViewRowAnimationAutomatic];
                                                  }];
    
    searchButton.textAlignment = NSTextAlignmentCenter;
    [self.searchSection addItem:searchButton];
}

- (void)fetchCurrencyData:(NSString *)from to:(NSString *)to amount:(NSString *)amount
{
    [MBProgressHUD showMessage:@"正在查询中..."];
    
    weakify(self)
    
    [LSLifeHelper currencyDataWithName:from to:to amount:amount success:^(id json) {
        
        strongify(self);
        [self.resultSection removeAllItems];
        
        NSDictionary *dict = json;
        NSLog(@"dict: %@", dict);
        
        NSNumber *errNum = dict[ErrNum];
        
        // 正确
        if( errNum && errNum.integerValue == 0 )
        {
            NSDictionary *retData = dict[RetData];
            
            NSNumber *cency = retData[@"currency"];
            NSLog(@"cur %@", cency);
            NSString *currency = [[NSString alloc] initWithFormat:@"%@",cency];
            LSSubtitleItem *currencyItem = [LSSubtitleItem itemWithTitle:@"当前  汇率:" subTitle:currency];
            [self.resultSection addItem:currencyItem];
            
            NSNumber *conveamount      = retData[@"convertedamount"];
            NSString *convertedamount = [[NSString alloc] initWithFormat:@"%@", conveamount];
            LSSubtitleItem *convertedamountItem = [LSSubtitleItem itemWithTitle:@"转化后金额:" subTitle:convertedamount];
            [self.resultSection addItem:convertedamountItem];
            
            NSString *hdate  = retData[@"date"];
            NSString *htime  = retData[@"time"];
            NSString *hdatetime = [[NSString alloc] initWithFormat:@"%@ %@", hdate, htime];
            LSSubtitleItem *hdatetimeItem = [LSSubtitleItem itemWithTitle:@"汇率更新时间:" subTitle:hdatetime];
            [self.resultSection addItem:hdatetimeItem];
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

@end
