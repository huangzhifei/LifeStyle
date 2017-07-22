//
//  LSOilPriceSearchController.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/12.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSOilPriceSearchController.h"
#import "LSLifeToolHeader.h"
#import "LSSubtitleItem.h"

@interface LSOilPriceSearchController ()

@property (strong, nonatomic) RETableViewManager *tableViewManager;
@property (strong, nonatomic) RETableViewSection *resultSection;
@property (strong, nonatomic) RETableViewSection *oilPriceSection;
@property (strong, nonatomic) RETableViewSection *searchSection;

@end

@implementation LSOilPriceSearchController

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
    self.title = @"油价查询";
    self.tableViewManager = ({
        
        RETableViewManager *manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
        manager.style.cellHeight = 44;
        
        manager;
    });
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = kCollectionHeaderColor;
    
    [self addOilPriceInputSection];
    [self addOilPriceResultSection];
    [self addOilPriceSearchSection];
}

#pragma mark - private method
- (void)addOilPriceInputSection
{
    UIImageView *IDPhoto = ({
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"a0"]];
        imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
        imageView.contentMode = UIViewContentModeCenter;
        imageView;
    });
    
    self.oilPriceSection = ({
        
        RETableViewSection *IDCardSection = [RETableViewSection sectionWithHeaderView:IDPhoto];
        IDCardSection.footerTitle = @"数据来源于国家发改委官网, 可查询全国31个省的油价";
        
        RETextItem *textItem = [RETextItem itemWithTitle:@"省份:" value:nil placeholder:@"请输入有效地区"];
        [IDCardSection addItem:textItem];
        
        IDCardSection;
    });
    [self.tableViewManager addSection:self.oilPriceSection];
}

- (void)addOilPriceResultSection
{
    self.resultSection = ({
        
        RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"查询结果: "];
        
        section;
    });
    
    [self.tableViewManager addSection:self.resultSection];
    
}

- (void)addOilPriceSearchSection
{
    self.searchSection = [RETableViewSection section];
    [self.tableViewManager addSection:self.searchSection];
    
    weakify(self)
    RETableViewItem *searchButton = [RETableViewItem itemWithTitle:@"查询"
                                                     accessoryType:UITableViewCellAccessoryNone
                                                  selectionHandler:^(RETableViewItem *item) {
                                                      
                                                      strongify(self)
                                                      
                                                      RETextItem *oilItem = [self.oilPriceSection.items firstObject];
                                                      
                                                      if( oilItem.value )
                                                      {
                                                          [self fetchOilPriceData:oilItem.value];
                                                          
                                                      }
                                                      
                                                      [item deselectRowAnimated:UITableViewRowAnimationAutomatic];
                                                  }];
    
    searchButton.textAlignment = NSTextAlignmentCenter;
    [self.searchSection addItem:searchButton];
}

- (void)fetchOilPriceData:(NSString *)prov
{
    [MBProgressHUD showMessage:@"正在查询中..."];
    
    weakify(self);
    
    [LSLifeHelper oilPriceDataWithCity:prov success:^(id json) {
        
        strongify(self);
        [self.resultSection removeAllItems];
        
        NSDictionary *dict = json;
        NSLog(@"dict: %@", dict);
        
        NSNumber *errNum = dict[@"showapi_res_code"];
        
        NSDictionary *retRes = dict[@"showapi_res_body"];
        NSDictionary *retData = [retRes[@"list"] firstObject];
        // 正确
        if( errNum && errNum.integerValue == 0 && retData )
        {
            NSString *p0 = retData[@"p0"];
            p0 = [p0 stringByAppendingString:@"元/升"];
            LSSubtitleItem *p0Item = [LSSubtitleItem itemWithTitle:@"0号  柴油:" subTitle:p0];
            [self.resultSection addItem:p0Item];
            
            NSString *p90      = retData[@"p90"];
            p90 = [p90 stringByAppendingString:@"元/升"];
            LSSubtitleItem *p90Item = [LSSubtitleItem itemWithTitle:@"90号汽油:" subTitle:p90];
            [self.resultSection addItem:p90Item];
            
            NSString *p93  = retData[@"p93"];
            p93 = [p93 stringByAppendingString:@"元/升"];
            LSSubtitleItem *p93Item = [LSSubtitleItem itemWithTitle:@"93号汽油:" subTitle:p93];
            [self.resultSection addItem:p93Item];
            
            NSString *p97  = retData[@"p97"];
            p97 = [p97 stringByAppendingString:@"元/升"];
            LSSubtitleItem *p97Item = [LSSubtitleItem itemWithTitle:@"97号汽油:" subTitle:p97];
            [self.resultSection addItem:p97Item];
            
            NSString *provName  = retData[@"prov"];
            LSSubtitleItem *provItem = [LSSubtitleItem itemWithTitle:@"省   份:" subTitle:provName];
            [self.resultSection addItem:provItem];
            
            NSString *ct  = retData[@"ct"];
            LSSubtitleItem *ctItem = [LSSubtitleItem itemWithTitle:@"更新时间:" subTitle:ct];
            [self.resultSection addItem:ctItem];
        }
        
        else if( retData == nil )
        {
            [GCDTimer scheduledTimerWithTimeInterval:0.5f repeats:NO block:^{
                
                [MBProgressHUD showError:@"地址不正确!"];
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

@end
