//
//  LSCityListViewController.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/6.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSCityListViewController.h"
#import "LSCityListGroupCell.h"
#import "LSCityListHeaderView.h"
#import "LSCityInfo.h"
#import "LSCoverView.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define RECENT_CITY_KEY         @"RecentCity"
#define MAX_RECENT_CITY_COUNT   8
#define EXTENSION_SECTION       3

@interface LSCityListViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, LSCityGroupCellDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarTopLayout;

@property (strong, nonatomic) LSCoverView *coverView;

// 最近城市(city name)
@property (strong, nonatomic)  NSMutableArray   *recentCitys;
// 热门城市(city name)
@property (strong, nonatomic)  NSMutableArray   *hotCitys;
// 当前定位城市(city name)
@property (strong, nonatomic)  NSMutableArray   *locateCity;
// 搜索城市数据(city name)
@property (strong, nonatomic)  NSMutableArray   *searchCitys;
// 所有城市的数据(cityInfo)
@property (strong, nonatomic)  NSMutableArray   *cityInfos;
// 所有城市的数据及索引(cityGroup(section & cityInfo))
@property (strong, nonatomic)  NSMutableArray   *groupCityInfos;
// section分类(A-Z)
@property (strong, nonatomic)  NSMutableArray   *sectionArray;

@property (assign, nonatomic)  BOOL             isSearch;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

NSString * const reuseCellIdentify = @"cell";
NSString * const reuseHeaderCellIdentify = @"headerCell";
NSString * const reuseGroupCellIdentify  = @"groupCell";

@implementation LSCityListViewController

+ (instancetype)loadCityController
{
    return [[LSCityListViewController alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if( self.selectedCity == nil )
    {
        self.selectedCity = @"深圳";
        [self.locateCity addObject: @"深圳"];
    }
    else
    {
        [self.locateCity addObject: self.selectedCity];
    }
    [self.navigationItem setTitle:[NSString stringWithFormat:@"当前城市 - %@", self.selectedCity]];
    self.navigationItem.leftBarButtonItem = ({
        
        UIImage *image = [[UIImage imageNamed:@"icon_nav_quxiao_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithImage:image
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(cancelSelect)];
        cancel;
    });
    
    self.searchBar.placeholder = @"输入城市汉字或拼音";
    //self.searchBar.tintColor = [UIColor redColor];
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionIndexColor = [UIColor redColor];
    
    [self registerCells];
}

- (void)registerCells
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseCellIdentify];
    [self.tableView registerClass:[LSCityListGroupCell class] forCellReuseIdentifier:reuseGroupCellIdentify];
    [self.tableView registerClass:[LSCityListHeaderView class] forHeaderFooterViewReuseIdentifier:reuseHeaderCellIdentify];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - events
- (void)cancelSelect
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cityDismissViewController:)])
    {
        [self.delegate cityDismissViewController:self];
    }
}

- (void)coverDisapper
{
    [self.searchBar setShowsCancelButton:NO animated:YES];
    self.searchBar.text=@"";
    self.isSearch = NO;
    self.searchBarTopLayout.constant = 60;
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
        self.navigationController.navigationBarHidden = NO;
    }];

    // 移除遮罩
    [UIView animateWithDuration:0.3 animations:^{
        
        self.coverView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [self.coverView removeFromSuperview];
        
    }];
    
    // 键盘消失
    [self.searchBar resignFirstResponder];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if( self.isSearch )
    {
        return 1;
    }
    else
    {
        return self.groupCityInfos.count + EXTENSION_SECTION;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( self.isSearch )
    {
        return self.searchCitys.count;
    }
    else if(section < EXTENSION_SECTION)
    {
        return 1;
    }
    else
    {
        LSCityGroup *group = [self.groupCityInfos objectAtIndex:section - EXTENSION_SECTION];
        
        return group.arrayCitys.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( self.isSearch )
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellIdentify];
        NSString *cityName =  [self.searchCitys objectAtIndex:indexPath.row];
        [cell.textLabel setText:cityName];
        return cell;
    }
    
    else if( indexPath.section < EXTENSION_SECTION )
    {
        LSCityListGroupCell *groupCell = [tableView dequeueReusableCellWithIdentifier:reuseGroupCellIdentify];
        switch( indexPath.section )
        {
            case ExtensionSectionLocal:
            {
                groupCell.titleLabel.text = @"当前城市";
                groupCell.nothingLabel.text = @"正在定位...";
                groupCell.cityArray = self.locateCity;
            }
                break;
            
            case ExtensionSectionRecent:
            {
                groupCell.titleLabel.text = @"最近访问城市";
                groupCell.nothingLabel.text = @"暂无记录...";
                groupCell.cityArray = self.recentCitys;
            }
                break;
                
            case ExtensionSectionHot:
            {
                groupCell.titleLabel.text = @"热门城市";
                groupCell.cityArray = self.hotCitys;
            }
                break;
                
            default:
                break;
        }
        groupCell.delegate = self;
        return groupCell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellIdentify];
    LSCityGroup *groupInfo = [self.groupCityInfos objectAtIndex:indexPath.section - EXTENSION_SECTION];
    LSCityInfo  *cityInfo =  [groupInfo.arrayCitys objectAtIndex:indexPath.row];
    [cell.textLabel setText:cityInfo.shortName];
    
    return cell;
}

- (NSArray <NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if( self.isSearch )
    {
        return nil;
    }
    
    return self.sectionArray;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if( self.isSearch || section < EXTENSION_SECTION )
    {
        return nil;
    }
    
    LSCityListHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseHeaderCellIdentify];
    headerView.titleLabel.text = [self.sectionArray objectAtIndex:section];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( self.isSearch )
    {
        return 44.0f;
    }
    
    switch(indexPath.section)
    {
        case ExtensionSectionLocal:
        {
            return [LSCityListGroupCell cellHeightOfCityArray:self.locateCity];
        }
            
        case ExtensionSectionRecent:
        {
            return [LSCityListGroupCell cellHeightOfCityArray:self.recentCitys];
        }
        
        case ExtensionSectionHot:
        {
            return [LSCityListGroupCell cellHeightOfCityArray:self.hotCitys];
        }
        
        default:
            return 44.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section < EXTENSION_SECTION || self.isSearch)
    {
        return 0.0f;
    }
    
    return 23.5f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *cityName = nil;
    
    if( self.isSearch )
    {
        cityName =  [self.searchCitys objectAtIndex:indexPath.row];
    }
    else
    {
        if( indexPath.section < EXTENSION_SECTION )
        {
            if( indexPath.section == 0 && self.locateCity.count <= 0 )
            {
                //[self locationStart];
            }
            return;
        }
        
        LSCityGroup *group = [self.groupCityInfos objectAtIndex:indexPath.section - EXTENSION_SECTION];
        LSCityInfo *cityInfo =  [group.arrayCitys objectAtIndex:indexPath.row];
        cityName = cityInfo.shortName;
    }
    
    [self.searchBar resignFirstResponder];
    
    [self didSelctedCity:cityName];

}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    UIButton *cancelButton = [searchBar valueForKey:@"_cancelButton"];
    
    self.searchBarTopLayout.constant = 20;
    [UIView animateWithDuration:0.3f animations:^{
        
        [self.view layoutIfNeeded];
        self.navigationController.navigationBarHidden = YES;
        
        [self addCover];
        
    }];

    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self coverDisapper];
    
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.searchCitys removeAllObjects];
    
    if( searchText.length == 0 )
    {
        self.isSearch = NO;
        [self addCover];
    }
    else
    {
        [self.coverView removeFromSuperview];
        self.isSearch = YES;
        for( LSCityInfo *cityInfo in self.cityInfos )
        {
            NSRange chinese     = [cityInfo.shortName rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSRange letters     = [cityInfo.cityPinyin rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSRange initials    = [cityInfo.initials rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (chinese.location != NSNotFound || letters.location != NSNotFound || initials.location != NSNotFound)
            {
                [self.searchCitys addObject:cityInfo.shortName];
            }
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - LSCityGroupCellDelegate
- (void)cityGroupCellDidSelectCity:(NSString *)city
{
    [self didSelctedCity:city];
}

#pragma mark - getter
- (NSMutableArray *)groupCityInfos
{
    if( _groupCityInfos == nil )
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CityData" ofType:@".plist"];
        NSArray *array = [NSMutableArray arrayWithContentsOfFile:filePath];
        
        _groupCityInfos = [[NSMutableArray alloc] init];
        
        for( NSDictionary *groupDic in array )
        {
            LSCityGroup *group = [[LSCityGroup alloc] init];
            
            group.groupName = [groupDic objectForKey:@"initial"];
            
            for( NSDictionary *dic in [groupDic objectForKey:@"citys"] )
            {
                LSCityInfo *cityInfo    = ({
                
                    LSCityInfo *city    = [[LSCityInfo alloc] init];
                    city.cityID         = [dic objectForKey:@"city_key"];
                    city.cityName       = [dic objectForKey:@"city_name"];
                    city.shortName      = [dic objectForKey:@"short_name"];
                    city.cityPinyin     = [dic objectForKey:@"pinyin"];
                    city.initials       = [dic objectForKey:@"initials"];
                    city;
                });
                [group.arrayCitys addObject:cityInfo];
                [self.cityInfos addObject:cityInfo];
            }
            [self.sectionArray addObject:group.groupName];
            [_groupCityInfos addObject:group];
        }
    }
    
    return _groupCityInfos;
}

- (NSMutableArray *)cityInfos
{
    if( _cityInfos == nil )
    {
        _cityInfos = [[NSMutableArray alloc] init];
    }
    
    return _cityInfos;
}

- (NSMutableArray *)searchCitys
{
    if( _searchCitys == nil )
    {
        _searchCitys = [[NSMutableArray alloc] init];
    }
    
    return _searchCitys;
}

- (NSMutableArray *)sectionArray
{
    if( _sectionArray == nil )
    {
        _sectionArray = [[NSMutableArray alloc] initWithObjects: @"#", @"*", @"$", nil];
    }
    
    return _sectionArray;
}

- (NSMutableArray *)recentCitys
{
    if( _recentCitys == nil )
    {
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:RECENT_CITY_KEY];
        if( array == nil )
        {
            _recentCitys = [[NSMutableArray alloc] initWithObjects:self.selectedCity, nil];
        }
        else
        {
            _recentCitys = [[NSMutableArray alloc] initWithArray:array copyItems:YES];
        }
    }
    
    return _recentCitys;
}

- (NSMutableArray *)hotCitys
{
    if( _hotCitys == nil )
    {
//        LSCityInfo *city1 = [[LSCityInfo alloc] init];
//        city1.cityName = @"上海市";
//        LSCityInfo *city2 = [[LSCityInfo alloc] init];
//        city2.cityName = @"北京市";
//        LSCityInfo *city3 = [[LSCityInfo alloc] init];
//        city3.cityName = @"广州市";
//        LSCityInfo *city4 = [[LSCityInfo alloc] init];
//        city4.cityName = @"深圳市";
//        LSCityInfo *city5 = [[LSCityInfo alloc] init];
//        city5.cityName = @"武汉市";
//        LSCityInfo *city6 = [[LSCityInfo alloc] init];
//        city6.cityName = @"天津市";
//        LSCityInfo *city7 = [[LSCityInfo alloc] init];
//        city7.cityName = @"西安市";
//        LSCityInfo *city8 = [[LSCityInfo alloc] init];
//        city8.cityName = @"南京市";
//        LSCityInfo *city9 = [[LSCityInfo alloc] init];
//        city9.cityName = @"杭州市";
//        _hotCitys = [[NSMutableArray alloc] initWithObjects:city1, city2, city3, city4,
//                     city5, city6, city7, city8, city9, nil];
        _hotCitys = [[NSMutableArray alloc] initWithObjects:@"上海", @"北京", @"广州", @"深圳",
                     @"武汉", @"天津", @"西安", @"南京", @"杭州", nil];
    }
    
    return _hotCitys;
}

- (NSMutableArray *)locateCity
{
    if( _locateCity == nil )
    {
        _locateCity = [[NSMutableArray alloc] init];
    }
    
    return _locateCity;
}

#pragma mark - private Method
- (void)addCover
{
    if( self.coverView == nil )
    {
        self.coverView = [LSCoverView coverWithTarget:self action:@selector(coverDisapper)];
    }
    self.coverView.alpha = 0.0;
    self.coverView.frame = self.tableView.frame;
    [self.view addSubview:self.coverView];
    
    [UIView animateWithDuration:0.2f animations:^{
        
        [self.coverView reset];
    }];
}

- (void)locationStart
{
    //判断定位操作是否被允许
    
    if([CLLocationManager locationServicesEnabled])
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        //设置定位精度
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //每隔多少米定位一次（这里的设置为每隔百米)
        self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;

        [self.locationManager requestWhenInUseAuthorization];
        
        // 开始定位
        [self.locationManager startUpdatingLocation];
    }
    else
    {
        //提示用户无法进行定位操作
        NSLog(@"%@",@"定位服务当前可能尚未打开，请设置打开！");
    }

}

- (void)didSelctedCity:(NSString *)cityName
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cityDidSelect:city:)])
    {
        [self.delegate cityDidSelect:self city:cityName];
    }
    
    // 这里我们最多保存8个
    if( self.recentCitys.count >= MAX_RECENT_CITY_COUNT )
    {
        [self.recentCitys removeLastObject];
    }
    
    for (NSString *str in self.recentCitys)
    {
        if ([cityName isEqualToString:str])
        {
            [self.recentCitys removeObject:str];
            break;
        }
    }
    
    [self.recentCitys insertObject:cityName atIndex:0];
    
    [[NSUserDefaults standardUserDefaults] setValue:self.recentCitys forKey:RECENT_CITY_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

#pragma mark - CoreLocation Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations

{
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [self.locationManager stopUpdatingLocation];
    
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，
    //则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    
    //获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count >0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //获取城市
             NSString *currCity = placemark.locality;
             if (!currCity)
             {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 currCity = placemark.administrativeArea;
             }
             if (self.locateCity.count <= 0)
             {
                 LSCityInfo *cityInfo = [[LSCityInfo alloc] init];
                 cityInfo.cityName = currCity;
                 cityInfo.shortName = currCity;
                 
                 [self.locateCity addObject:cityInfo];
                 
                 [self.tableView reloadData];
             }
             
         }
         else if (error ==nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }
         else if (error !=nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
         
     }];
    
}

@end


