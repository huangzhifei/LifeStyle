//
//  LSIDCardSearchController.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/8.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSIDCardSearchController.h"
#import "LSLifeToolHeader.h"
#import "LSSubtitleItem.h"

#define ErrNum      @"errNum"
#define RetData     @"retData"

@interface LSIDCardSearchController()

@property (strong, nonatomic) RETableViewManager *tableViewManager;
@property (strong, nonatomic) RETableViewSection *resultSection;
@property (strong, nonatomic) RETableViewSection *cardSection;
@property (strong, nonatomic) RETableViewSection *searchSection;

@end

@implementation LSIDCardSearchController

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
    
    self.title = @"身份证查询";
    self.tableViewManager = ({
        
        RETableViewManager *manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
        manager.style.cellHeight = 44;
        
        manager;
    });
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = kCollectionHeaderColor;
    [self addIDCardInputSection];
    [self addIDCardResultSection];
    [self addIDCardSearchSection];
}

#pragma mark - private method
- (void)addIDCardInputSection
{
    UIImageView *IDPhoto = ({
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"a0"]];
        imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
        imageView.contentMode = UIViewContentModeCenter;
        imageView;
    });
    
    self.cardSection = ({
        
        RETableViewSection *IDCardSection = [RETableViewSection sectionWithHeaderView:IDPhoto];
        IDCardSection.footerTitle = @"身份证查询为模糊查询, 查询次数无限制";
        
        RETextItem *textItem = [RETextItem itemWithTitle:@"身份证号:" value:nil placeholder:@"请输入有效身份证号"];
        [IDCardSection addItem:textItem];
        
        IDCardSection;
    });
    [self.tableViewManager addSection:self.cardSection];
}

- (void)addIDCardResultSection
{
    self.resultSection = ({
        
        RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"查询结果: "];
        
        section;
    });
    
    [self.tableViewManager addSection:self.resultSection];
    
}

- (void)addIDCardSearchSection
{
    self.searchSection = [RETableViewSection section];
    [self.tableViewManager addSection:self.searchSection];
    
    weakify(self)
    RETableViewItem *searchButton = [RETableViewItem itemWithTitle:@"查询"
                                                     accessoryType:UITableViewCellAccessoryNone
                                                  selectionHandler:^(RETableViewItem *item) {
                                                      
                                                      strongify(self)
                                                      
                                                      RETextItem *IDCardItem = [self.cardSection.items firstObject];
                                                      
                                                      if( IDCardItem.value )
                                                      {
                                                          [self fetchIDCardData:IDCardItem.value];
                                                          
                                                      }
                                                      
                                                      [item deselectRowAnimated:UITableViewRowAnimationAutomatic];
                                                  }];
    
    searchButton.textAlignment = NSTextAlignmentCenter;
    [self.searchSection addItem:searchButton];
}

- (void)fetchIDCardData:(NSString *)IDCardNum
{

    [MBProgressHUD showMessage:@"正在查询中..."];
    
    weakify(self);
    
    [LSLifeHelper identityDataWithIDCard:IDCardNum success:^(id json) {
        
        strongify(self);
        [self.resultSection removeAllItems];
        
        NSDictionary *dict = json;
        NSLog(@"dict: %@", dict);
        
        NSNumber *errNum = dict[ErrNum];
        
        // 正确
        if( errNum.integerValue == 0 )
        {
            NSDictionary *retData = dict[RetData];
            
            NSString *birthday = retData[@"birthday"];
            LSSubtitleItem *birthdayItem = [LSSubtitleItem itemWithTitle:@"生日:" subTitle:birthday];
            [self.resultSection addItem:birthdayItem];
            
            NSString *sex      = retData[@"sex"];
            NSString *sexName = [sex isEqualToString:@"M"] ? @"男" : @"女";
            LSSubtitleItem *sexItem = [LSSubtitleItem itemWithTitle:@"性别:" subTitle:sexName];
            [self.resultSection addItem:sexItem];
            
            NSString *address  = retData[@"address"];
            NSLog(@"address %@", address);
            LSSubtitleItem *addressItem = [LSSubtitleItem itemWithTitle:@"地址:" subTitle:address];
            [self.resultSection addItem:addressItem];
        }
        // 身份证格式不对
        else if( errNum.integerValue == -1 )
        {
            [GCDTimer scheduledTimerWithTimeInterval:0.5f repeats:NO block:^{
                
                [MBProgressHUD showError:@"身份证格式不正确!"];
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
