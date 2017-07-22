//
//  LSRevenueController.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/12.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSRevenueController.h"
#import "LSLifeToolHeader.h"
#import "LSSubtitleItem.h"
#import "REPickerItem.h"

@interface LSRevenueController ()

@property (strong, nonatomic) RETableViewManager *tableViewManager;
@property (strong, nonatomic) RETableViewSection *resultSection;
@property (strong, nonatomic) RETableViewSection *revenueSection;
@property (strong, nonatomic) RETableViewSection *searchSection;
@property (strong, nonatomic) REPickerItem       *pickerItem;

// 应缴税金额
@property (nonatomic, assign) float shouldTax;
// 纳税比例
@property (nonatomic, assign) float taxRate;
// 速算扣除金额
@property (nonatomic, assign) float taxDiv;
// 税收金额
@property (nonatomic, assign) float tax;
// 税后收入
@property (nonatomic, assign) float afterTax;

@end

@implementation LSRevenueController

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
    
    self.title = @"税收计算";
    self.tableViewManager = ({
        
        RETableViewManager *manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
        manager.style.cellHeight = 44;
        
        manager;
    });
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = kCollectionHeaderColor;
    
    [self addRevenueInputSection];
    [self addRevenueResultSection];
    [self addRevenueSearchSection];
}

#pragma mark - private method
- (void)addRevenueInputSection
{
    UIImageView *IDPhoto = ({
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"a0"]];
        imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
        imageView.contentMode = UIViewContentModeCenter;
        imageView;
    });
    
    self.revenueSection = ({
        
        RETableViewSection *IDCardSection = [RETableViewSection sectionWithHeaderView:IDPhoto];
        IDCardSection.footerTitle = @"可以计算个人税收与个人商户税收，通过点击 ’收入类型‘ 来切换";
        
        self.pickerItem = [REPickerItem itemWithTitle:@"收入类型:" value:@[@"个人税收"] placeholder:nil options:@[@[@"个人税收", @"个人商户税收"]]];

        [IDCardSection addItem:self.pickerItem];
        
        IDCardSection;
    });
    [self.tableViewManager addSection:self.revenueSection];
    

    [self addPersonalType];
}

- (void)addPersonalType
{
    RETextItem *salary = [RETextItem itemWithTitle:@"收入总额:" value:nil placeholder:@"请输入总额"];
    salary.keyboardType = UIKeyboardTypeDecimalPad;
    
    RETextItem *safe    = [RETextItem itemWithTitle:@"五险一金:" value:nil placeholder:@"默认为0元"];
    safe.keyboardType    = UIKeyboardTypeDecimalPad;
    
    [self.revenueSection addItem:salary];
    [self.revenueSection addItem:safe];
    
}

- (void)addRevenueResultSection
{
    self.resultSection = ({
        
        RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"查询结果: "];
        
        section;
    });
    
    [self.tableViewManager addSection:self.resultSection];
    
}

- (void)addRevenueSearchSection
{
    self.searchSection = [RETableViewSection section];
    [self.tableViewManager addSection:self.searchSection];
    
    weakify(self)
    RETableViewItem *searchButton = [RETableViewItem itemWithTitle:@"查询"
                                                     accessoryType:UITableViewCellAccessoryNone
                                                  selectionHandler:^(RETableViewItem *item) {
                                                      
                                                      strongify(self)
                                                      
                                                      RETextItem *item1 = [self.revenueSection.items objectAtIndex:1];
                                                      RETextItem *item2 = [self.revenueSection.items objectAtIndex:2];
                                                      if( item1.value )
                                                      {
                                                          if( item2.value == nil ) item2.value = @"0";
                                                          [self fetchrevenueData:item1.value safe:item2.value];
                                                      }
                                                      
                                                      [item deselectRowAnimated:UITableViewRowAnimationAutomatic];
                                                  }];
    
    searchButton.textAlignment = NSTextAlignmentCenter;
    [self.searchSection addItem:searchButton];
}

- (void)fetchrevenueData:(NSString *)salary safe:(NSString *)safe
{
    if( [self.pickerItem.value isEqualToArray:@[@"个人税收"]] )
    {
        [self calPersonalRevenue:salary.floatValue safe:safe.floatValue];
    }
    else
    {
        [self calBusinessRevenue:salary.floatValue safe:safe.floatValue];
    }
    
    [self.resultSection removeAllItems];
    
    LSSubtitleItem *item1 = [LSSubtitleItem itemWithTitle:@"应纳税金额:"
                                                 subTitle:[NSString stringWithFormat:@"%.2f",self.shouldTax]];
    [self.resultSection addItem:item1];
    
    LSSubtitleItem *item2 = [LSSubtitleItem itemWithTitle:@"适用  税率:"
                                                 subTitle:[NSString stringWithFormat:@"%.f%%",self.taxRate*100]];
    [self.resultSection addItem:item2];
    
    LSSubtitleItem *item3 = [LSSubtitleItem itemWithTitle:@"速算扣除数:"
                                                 subTitle:[NSString stringWithFormat:@"%.2f",self.taxDiv]];
    [self.resultSection addItem:item3];
    
    LSSubtitleItem *item4 = [LSSubtitleItem itemWithTitle:@"应缴  税款:"
                                                 subTitle:[NSString stringWithFormat:@"%.2f",self.tax]];
    [self.resultSection addItem:item4];
    
    LSSubtitleItem *item5 = [LSSubtitleItem itemWithTitle:@"税后  收入:"
                                                 subTitle:[NSString stringWithFormat:@"%.2f",self.afterTax]];
    [self.resultSection addItem:item5];
    
    [self.resultSection reloadSectionWithAnimation:UITableViewRowAnimationAutomatic];
}

- (void)calPersonalRevenue:(float)salary safe:(float)safe
{
    int tax[] = { 0, 105, 555, 1005, 2755, 5505, 13505 };
    float percent[] = { 0.03, 0.1, 0.2, 0.25, 0.3, 0.35, 0.45 };
    
    float Money = salary - safe - 3500;
    float taxhand = 0;
    
    self.shouldTax = salary - safe - 3500;
    
    int i = (Money >= 1500) + (Money >= 4500) + (Money >= 9000) + (Money >= 35000) + (Money >= 55000) + (Money >= 80000);
    
    taxhand = Money * percent[i] - tax[i];
    self.tax = taxhand;
    self.taxDiv = tax[i];
    self.taxRate = percent[i];
    
    self.afterTax = salary - safe - taxhand;
}

- (void)calBusinessRevenue:(float)salary safe:(float)safe
{
    int tax[] = { 0, 750, 3750, 9750, 14750 };
    float percent[] = { 0.05, 0.1, 0.2, 0.3, 0.35 };
    
    float Money = salary - safe;
    float taxhand = 0;
    
    int i = (Money >= 15000) + (Money >= 30000) + (Money >= 60000) + (Money >= 100000) ;
    self.shouldTax = salary - safe;
    taxhand = Money * percent[i] - tax[i];
    self.taxDiv = tax[i];
    self.taxRate = percent[i];
    self.tax = taxhand;
    self.afterTax = salary - safe - taxhand;
}

@end
