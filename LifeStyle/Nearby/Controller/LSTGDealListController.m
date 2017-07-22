//
//  LSTGDealListController.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/15.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSTGDealListController.h"
#import "DOPDropDownMenu.h"
#import "MJRefresh.h"
#import "LSLocationTool.h"
#import "LSOrder.h"
#import "LSDealTablewViewCell.h"
#import "LSNearbyMetaDataTool.h"
#import "LSCategory.h"
#import "LSSubCategorie.h"
#import "LSBuyCity.h"
#import "LSLocationInfo.h"
#import "LSNearbyHttpTool.h"
#import "GCDTimer.h"
#import "LSWebViewController.h"

#define timeout 20

@interface LSTGDealListController ()<DOPDropDownMenuDataSource, DOPDropDownMenuDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) GCDTimer *refreshTimer;

// 分类
@property (nonatomic, strong) NSMutableArray *currentCategories;
// 地区
@property (nonatomic, strong) LSBuyCity *citycategories;
// 排序
@property (nonatomic, strong) NSArray *orders;

@property (nonatomic, strong) UITableView *tableView;

// 商户
@property (nonatomic, strong) NSMutableArray *businesses;

// 商户下的团信息
@property (nonatomic, strong) NSMutableArray *deals;

// 当前选中的类别
@property (nonatomic, strong) NSString *currentSubcategorie;
// 当前选中的区域
@property (nonatomic, strong) NSString *currentDistrict;
// 当前选中的排序
@property (nonatomic, strong) LSOrder *currentOrder;
// 检索页
@property (nonatomic, assign) int page;

@property (nonatomic, strong) DOPDropDownMenu *dopMenu;

@end

@implementation LSTGDealListController

typedef NS_ENUM(NSUInteger, TGDetailMenu)
{
    kCategorys,
    kDistrics,
    kOrders,
};

static NSString *reuseIdentifierCell = @"LSDealTablewViewCell";
const CGFloat menuHeight = 36;

#pragma mark - init
- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = kCollectionHeaderColor;
    
    [self setAllSubcategories];
    
    [self addTopMenu];
    
    [self addTableView];
    
    [self registerCells];
    
    self.page = 1;
    
    [self addRefresh];
    
    [self.tableView headerBeginRefreshing];
    
    self.refreshTimer = [GCDTimer scheduledTimerWithTimeInterval:timeout repeats:NO block:^{
        
        [self.tableView headerEndRefreshing];
        
    }];
}

- (void)addRefresh
{
    // 下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(getNewRefreshData)];
    
    // 上拉刷新
    [self.tableView addFooterWithTarget:self action:@selector(getMoreRefreshData)];
}

- (void)addTopMenu
{
    self.dopMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:menuHeight];
    self.dopMenu.delegate = self;
    self.dopMenu.dataSource= self;
    [self.view addSubview:self.dopMenu];
    // 创建menu 第一次显示 不会调用点击代理，可以用这个手动调用
    [self.dopMenu selectDefalutIndexPath];
}

- (void)addTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, menuHeight, kScreenWidth, kScreenHeight - 66 - menuHeight)
                                                  style:UITableViewStyleGrouped];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.tableView];
}

- (void)setAllSubcategories
{
    // 保存选择的分类
    for(LSCategory *category in [LSNearbyMetaDataTool sharedLSNearbyMetaDataTool].totalCategories)
    {
        if ([category.category_name isEqualToString:self.title])
        {
            [LSNearbyMetaDataTool sharedLSNearbyMetaDataTool].currentCategory = category;
            
            self.currentCategories = [NSMutableArray arrayWithArray:category.subcategories];
            LSCategory *cate = [[LSCategory alloc] init];
            cate.category_name = self.title;
            cate.subcategories = [[NSArray alloc] init];
            [self.currentCategories insertObject:cate atIndex:0];
            break;
        }
    }

    LSLocationInfo *info = [LSNearbyMetaDataTool sharedLSNearbyMetaDataTool].locatInfo;
    // 保存全部地区
    for(LSBuyCity *buyCity in [LSNearbyMetaDataTool sharedLSNearbyMetaDataTool].totalCitys)
    {
        if( [buyCity.cityname isEqualToString: [info.City substringToIndex:2]] )
        {
            self.citycategories = buyCity;
            
            LSDistricts *fujing = [self.citycategories.districts objectAtIndex:0];
            if( ![fujing.district_name isEqualToString:@"附近"] )
            {
                fujing = [[LSDistricts alloc] init];
                fujing.district_name = @"附近";
                fujing.neighborhoods = [[NSMutableArray alloc] init];
                [self.citycategories.districts insertObject:fujing atIndex:0];
            }
            
            LSDistricts *districts = [self.citycategories.districts objectAtIndex:1];;
            if( ![districts.district_name isEqualToString:@"全城"] )
            {
                districts = [[LSDistricts alloc] init];
                districts.district_name = @"全城";
                districts.neighborhoods = [[NSMutableArray alloc] init];
                [self.citycategories.districts insertObject:districts atIndex:1];
            }
            
            break;
        }
    }
    
    // 保存排序
    self.orders = [LSNearbyMetaDataTool sharedLSNearbyMetaDataTool].totalOrders;
}

- (void)registerCells
{
    UINib *nib = [UINib nibWithNibName:reuseIdentifierCell bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:reuseIdentifierCell];
}

#pragma mark - private method
- (void)getNewRefreshData
{
    if (!self.currentDistrict || [self.currentDistrict isEqualToString:@"全城"])
    {
        self.currentDistrict = nil;
    }
    
    if (!self.currentDistrict || [self.currentDistrict isEqualToString:@"附近"])
    {
        self.currentDistrict = [LSNearbyMetaDataTool sharedLSNearbyMetaDataTool].locatInfo.SubLocality;
    }
    
    NSInteger orderIndex = 1;
    if (self.currentOrder )
    {
        orderIndex = self.currentOrder.index;
    }
    
    weakify(self)
    
    // 页面为1最新一页
    _page = 1;
    
    [[LSNearbyHttpTool sharedLSNearbyHttpTool] dealsWithPage:_page district:self.currentDistrict category:self.currentSubcategorie orderIndext:orderIndex success:^(NSArray *deals, int totalCount) {
        
        strongify(self)
        
        // 添加数据
        self.deals = [NSMutableArray arrayWithArray:deals];
        
        // 重新加载
        [self.tableView reloadData];
        
        // 停止刷新
        [self.tableView headerEndRefreshing];
        
        [self.refreshTimer invalidate];
        
        self.refreshTimer = nil;
        
    } error:^(NSError *error) {
        
        strongify(self)
        
        // 停止刷新
        [self.tableView headerEndRefreshing];
        
        [self.refreshTimer invalidate];
        
        self.refreshTimer = nil;
    }];
}

- (void)getMoreRefreshData
{
    if (!self.currentDistrict || [self.currentDistrict isEqualToString:@"全城"])
    {
        self.currentDistrict = nil;
    }
    
    if (!self.currentDistrict || [self.currentDistrict isEqualToString:@"附近"])
    {
        self.currentDistrict = [LSNearbyMetaDataTool sharedLSNearbyMetaDataTool].locatInfo.SubLocality;
    }
    
    NSInteger orderIndex = 1;
    if (self.currentOrder )
    {
        orderIndex = self.currentOrder.index;
    }
    
    weakify(self)
    
    ++ _page;
    
    [[LSNearbyHttpTool sharedLSNearbyHttpTool] dealsWithPage:_page district:self.currentDistrict category:self.currentSubcategorie orderIndext:orderIndex success:^(NSArray *deals, int totalCount) {
        
        strongify(self)
        
        // 添加数据
        self.deals = [NSMutableArray arrayWithArray:deals];
        
        // 重新加载
        [self.tableView reloadData];
        
        // 停止刷新
        [self.tableView footerEndRefreshing];
        
    } error:^(NSError *error) {
        
        strongify(self)
        
        // 停止刷新
        [self.tableView footerEndRefreshing];
    }];

}

#pragma mark - tableview dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.deals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSDealTablewViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierCell forIndexPath:indexPath];
    
    LSDeal *deal = self.deals[indexPath.section];
    
    cell.deal = deal;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //section头部高度
    return 2;
}

//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 2)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}

//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 2)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSDeal *deal = self.deals[indexPath.section];
    LSWebViewController *webVC = [[LSWebViewController alloc] initWithUrl:deal.deal_h5_url];
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - DOPMenu delegate
/**
 *  返回 menu 第column列有多少行
 */
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    switch(column)
    {
        case kCategorys:
            return self.currentCategories.count;
            
        case kDistrics:
            return self.citycategories.districts.count;
            
        case kOrders:
            return self.orders.count;
            
        default:
            return 0;
    }
    return 0;
}

/**
 *  返回 menu 第column列 每行title
 */
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
 
    if (indexPath.column == kCategorys)
    {
        LSSubCategorie *subCategorie = self.currentCategories[indexPath.row];
        return subCategorie.category_name;
    }
    else if (indexPath.column == kDistrics)
    {
        LSDistricts *distric = self.citycategories.districts[indexPath.row];
        return distric.district_name;
    }
    else if (indexPath.column == kOrders)
    {
        LSOrder *order = self.orders[indexPath.row];
        return order.name;
    }
    else
    {
        return nil;
    }
}

/**
 *  返回 menu 有多少列 ，默认1列
 */
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 3;
}

/** 新增
 *  当有column列 row 行 返回有多少个item ，如果>0，说明有二级列表 ，=0 没有二级列表
 *  如果都没有可以不实现该协议
 */
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    if( column == kDistrics )
    {
        LSDistricts *district = self.citycategories.districts[row];
        return district.neighborhoods.count;
    }
    
    return 0;
}

/** 新增
 *  当有column列 row 行 item项 title
 *  如果都没有可以不实现该协议
 */
- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if(indexPath.column == kDistrics)
    {
        LSDistricts *district = self.citycategories.districts[indexPath.row];
        return district.neighborhoods[indexPath.item];
    }
    return nil;
}

/**
 *  点击代理，点击了第column 第row 或者item项，如果 item >=0
 */
- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if( indexPath.item > 0 )
    {
        if (indexPath.column == kDistrics)
        {
            NSLog(@"点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.item);
            // 记录当前分区
            LSDistricts *distric = self.citycategories.districts[indexPath.row];
            self.currentDistrict = distric.neighborhoods[indexPath.item];
            
            [self.tableView headerBeginRefreshing];
            
            if(self.refreshTimer)
            {
                [self.refreshTimer invalidate];
            }
            
            self.refreshTimer = [GCDTimer scheduledTimerWithTimeInterval:timeout repeats:NO block:^{
                
                [self.tableView headerEndRefreshing];
            }];
        }
    }
    else
    {
        NSLog(@"点击了 %ld - %ld 项目",indexPath.column,indexPath.row);
        if (indexPath.column == kCategorys)
        {
            // 记录当前分类
            LSSubCategorie *subCategorie = self.currentCategories[indexPath.row];
            self.currentSubcategorie= subCategorie.category_name;
            [self.tableView headerBeginRefreshing];
            if(self.refreshTimer)
            {
                [self.refreshTimer invalidate];
            }
            
            self.refreshTimer = [GCDTimer scheduledTimerWithTimeInterval:timeout repeats:NO block:^{
                
                [self.tableView headerEndRefreshing];
            }];
        }
        else if (indexPath.column == kDistrics)
        {
            // 记录当前分区
            LSDistricts *distric = self.citycategories.districts[indexPath.row];
            self.currentDistrict = distric.district_name;
            if( [self.currentDistrict isEqualToString:@"全城"] || [self.currentDistrict isEqualToString:@"附近"] )
            {
                [self.tableView headerBeginRefreshing];
                if(self.refreshTimer)
                {
                    [self.refreshTimer invalidate];
                }
                
                self.refreshTimer = [GCDTimer scheduledTimerWithTimeInterval:timeout repeats:NO block:^{
                    
                    [self.tableView headerEndRefreshing];
                }];
            }
        }
        else if (indexPath.column == kOrders)
        {
            self.currentOrder =self.orders[indexPath.row];
            [self.tableView headerBeginRefreshing];
            if(self.refreshTimer)
            {
                [self.refreshTimer invalidate];
            }
            
            self.refreshTimer = [GCDTimer scheduledTimerWithTimeInterval:timeout repeats:NO block:^{
                
                [self.tableView headerEndRefreshing];
            }];
        }
    }
    
    NSLog(@"%@ - %@ - %@",self.currentSubcategorie,self.currentDistrict,self.currentOrder.name);
    
}

@end
