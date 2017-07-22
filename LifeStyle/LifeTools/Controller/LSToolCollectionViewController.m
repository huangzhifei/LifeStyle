//
//  LSToolCollectionViewController.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/4.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSToolCollectionViewController.h"
#import "CSStickyHeaderFlowLayout.h"
#import "LSProductCollectionViewCell.h"
#import "LSProductHeaderCell.h"
#import "LSProductTopHeaderCell.h"
#import "LSProductSection.h"
#import "LSProductItem.h"
#import "LSCityListViewController.h"
#import "LSCityListViewDelegate.h"
#import "LSLifeHelper.h"
#import "MBProgressHUD+MJ.h"

#import "LSIDCardSearchController.h"
#import "LSPostCodeSearchController.h"
#import "LSIPSearchController.h"
#import "LSExpressSearchController.h"
#import "LSTelephoneSearchController.h"
#import "LSAppleSNSearchController.h"
#import "LSCoachSearchController.h"
#import "LSOilPriceSearchController.h"
#import "LSLimitSearchController.h"
#import "LSRevenueController.h"
#import "LSCurrencySearchController.h"
#import "LSWebViewController.h"
#import "LSLocationTool.h"
#import "NSString+Date.h"
#import "LSWeatherViewController.h"
#import "MJExtension.h"
#import "LSLocationTool.h"
#import "LSCodeScanViewController.h"

#import "GCDTimer.h"

#define LotteryUrl @"http://caipiao.163.com/t/"

#define WEATHERTIME (10 * 60)

@interface LSToolCollectionViewController()<LSCityListViewDelegate, LSLocationToolDelegate>

@property (strong, nonatomic) UILabel           *leftBarLabel;
@property (strong, nonatomic) NSMutableArray    *sections;
@property (assign, nonatomic) CGPoint           offY;
@property (strong, nonatomic) GCDTimer          *weatherTimer;
@property (strong, nonatomic) LSProductTopHeaderCell *weatherCell;
@property (assign, nonatomic) BOOL              localFlag;
@property (strong, nonatomic) LSWeatherData     *weatherInfo;
@property (strong, nonatomic) LSLocationTool    *locationTool;

@end

@implementation LSToolCollectionViewController

static NSString * reuseIdentifier = @"LSProductCollectionViewCell";
static NSString * reuseHeaderIdentifier = @"LSProductHeaderCell";
static NSString * reuseTopHeaderIdentifier = @"LSProductTopHeaderCell";

#pragma mark - init
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationTool = [[LSLocationTool alloc] init];
    self.locationTool.delegate = self;
    [self.locationTool startLocation];
    
    [self registerCells];

    if( _currentCity == nil )
    {
        _currentCity = @"北京";
    }
    
    self.localFlag = false;
    
    self.collectionView.backgroundColor = kCollectionHeaderColor;
    
    self.navigationItem.leftBarButtonItem = ({
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 66, 44)];
        self.leftBarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 48, 44)];
        [self.leftBarLabel setText:self.currentCity];
        self.leftBarLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self.leftBarLabel setTextAlignment:NSTextAlignmentCenter];
        [self.leftBarLabel setFont:[UIFont systemFontOfSize:14]];
        self.leftBarLabel.textColor = [UIColor colorWithRed:215/255.0f green:0 blue:0 alpha:1.0];
        [view addSubview:self.leftBarLabel];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftBarLabel.frame), 20, 12, 6)];
        [imageView setImage:[UIImage imageNamed:@"arrow_down_red"]];
        [view addSubview:imageView];
        
        UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeSystem];
        leftbutton.frame = view.frame;
        [leftbutton setTitle:@"" forState:UIControlStateNormal];
        [leftbutton addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:leftbutton];
        
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];

        barButtonItem;
    });
    
    self.navigationItem.rightBarButtonItem = ({
    
        UIImage *image = [[UIImage imageNamed:@"icon_nav_saoyisao_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(scanBarCode)];
        
        item;
        
    });
    
    // 1
    [self addSectionDaily];
    
    // 2
    [self addSectionTrip];
    
    // 3
    [self addSectionCaculate];
    
    // 4
    [self addSectionTicket];
    
    self.offY = CGPointMake(0, -64);
}

- (void)registerCells
{
    UINib *cellNib = [UINib nibWithNibName:reuseIdentifier bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];
    
    UINib *headerNib = [UINib nibWithNibName:reuseHeaderIdentifier bundle:nil];
    [self.collectionView registerNib:headerNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderIdentifier];
    
    UINib *topHeaderNib = [UINib nibWithNibName:reuseTopHeaderIdentifier bundle:nil];
    [self.collectionView registerNib:topHeaderNib forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader withReuseIdentifier:reuseTopHeaderIdentifier];
    
}

- (void)addSectionDaily
{
    // 6个 身份证、邮编、ip地址、快递查询、手机归属、苹果序列号
    
    LSProductSection *section = [LSProductSection section];
    section.headerTitle = @"日常";
    
    LSProductItem *cardIDItem = [LSProductItem itemWithTitle:@"身份证查询" icon:@"life-2"
                                          controlVCClass:[LSIDCardSearchController class]];
    LSProductItem *postCodeIDItem = [LSProductItem itemWithTitle:@"邮编查询" icon:@"life-5"
                                              controlVCClass:[LSPostCodeSearchController class]];
    LSProductItem *ipItem = [LSProductItem itemWithTitle:@"IP地址查询" icon:@"life-8"
                                          controlVCClass:[LSIPSearchController class]];
    LSProductItem *expressItem = [LSProductItem itemWithTitle:@"快递查询" icon:@"life-13"
                                               controlVCClass:[LSExpressSearchController class]];
    LSProductItem *phoneNumItem = [LSProductItem itemWithTitle:@"手机归属地" icon:@"life-9"
                                             controlVCClass:[LSTelephoneSearchController class]];
    LSProductItem *appleSNItem = [LSProductItem itemWithTitle:@"苹果SN查询" icon:@"life-4"
                                             controlVCClass:[LSAppleSNSearchController class]];
    
    [section.items addObjectsFromArray:@[cardIDItem, postCodeIDItem, ipItem, expressItem,
                                         phoneNumItem, appleSNItem]];
    [self.sections addObject:section];
}

- (void)addSectionTrip
{
    // 4个 油价、违章查询、公交车、长途汽车
    
    LSProductSection *section = [LSProductSection section];
    section.headerTitle = @"出行";
    
    LSProductItem *oilPricesItem = [LSProductItem itemWithTitle:@"油价查询" icon:@"life-12"
                                              controlVCClass:[LSOilPriceSearchController class]];
    LSProductItem *trafficLimitItem = [LSProductItem itemWithTitle:@"限行查询" icon:@"life-11"
                                                  controlVCClass:[LSLimitSearchController class]];
    LSProductItem *coachItem = [LSProductItem itemWithTitle:@"长途车查询" icon:@"life-3"
                                             controlVCClass:[LSCoachSearchController class]];
//    LSProductItem *busItem = [LSProductItem itemWithTitle:@"公交车查询" icon:@"a0"
//                                           controlVCClass:[UIViewController class]];
    
    [section.items addObjectsFromArray:@[oilPricesItem, coachItem, trafficLimitItem]];
    [self.sections addObject:section];

}

- (void)addSectionCaculate
{
    // 3个 货币汇率、房贷计算、税收计算
    
    LSProductSection *section = [LSProductSection section];
    section.headerTitle = @"货款";
    
    LSProductItem *oilPricesItem = [LSProductItem itemWithTitle:@"货币汇率" icon:@"life-6"
                                                 controlVCClass:[LSCurrencySearchController class]];
//    LSProductItem *breakRulesItem = [LSProductItem itemWithTitle:@"房贷计算" icon:@"a0"
//                                                  controlVCClass:[UIViewController class]];
    LSProductItem *busItem = [LSProductItem itemWithTitle:@"税收计算" icon:@"life-10"
                                           controlVCClass:[LSRevenueController class]];
    
    [section.items addObjectsFromArray:@[oilPricesItem, busItem]];
    [self.sections addObject:section];
}

- (void)addSectionTicket
{
    // 2个 银行卡查询、彩票
    
    LSProductSection *section = [LSProductSection section];
    section.headerTitle = @"理财";
    
    LSProductItem *lotteryItem = [LSProductItem itemWithTitle:@"网易彩票" icon:@"life-1"
                                                  controlVCClass:[LSWebViewController class]];
    
    [section.items addObjectsFromArray:@[lotteryItem]];
    [self.sections addObject:section];
}

- (void)updateWeather
{
    [self parseWeather];
    
    if( self.weatherTimer == nil )
    {
        self.weatherTimer = [GCDTimer scheduledTimerWithTimeInterval:WEATHERTIME repeats:YES block:^{
            
            [self parseWeather];
            
        }];
    }
    
}

- (void)parseWeather
{
    NSLog(@"call one");
    
    if( self.localFlag == true ) return;
    
    self.localFlag = true;
    
    // 去掉“市”字
    if( [self.currentCity length] >= 3 )
    {
        _currentCity = [_currentCity substringToIndex:2];
        self.leftBarLabel.text = _currentCity;
    }
    
    weakify(self)
    [LSLifeHelper weatherDataWithCityName:_currentCity success:^(id json) {
        
        strongify(self);
        
        NSDictionary *dict = json;
        NSLog(@"dict: %@", dict);
        
        NSString *errNum = dict[@"error"];
        
        if(errNum && errNum.integerValue==0)
        {
            NSArray *InfoArray = [LSWeatherData mj_objectArrayWithKeyValuesArray:json[@"results"]];

            self.weatherInfo = InfoArray[0];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

            [dateFormatter setDateFormat:@"yyyy年MM月dd日"];

            NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
            
            self.weatherInfo.date = currentDateStr;
            
            self.weatherCell.weatherData = self.weatherInfo;

        }
        
        self.localFlag = false;
        
    } failure:^(NSError *error) {
        
        NSLog(@"fetch error: %@", error);
        
        self.localFlag = false;
        
    } timeoutInterval:15.0f];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    LSProductSection *productSection = self.sections[section];
    return productSection.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LSProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    LSProductSection *section = self.sections[indexPath.section];
    cell.proudctItem = section.items[indexPath.item];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if( [kind isEqualToString:UICollectionElementKindSectionHeader] )
    {
        LSProductSection *section = self.sections[indexPath.section];
        LSProductHeaderCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseHeaderIdentifier forIndexPath:indexPath];
        cell.headerTitle.text = section.headerTitle;
        return cell;
    }
    else if( [kind isEqualToString:CSStickyHeaderParallaxHeader] )
    {
        LSProductTopHeaderCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseTopHeaderIdentifier forIndexPath:indexPath];
        // 添加点击事件
        [cell addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapWeatherView)]];

        self.weatherCell = cell;
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%@",indexPath);
    
    LSProductSection *section = self.sections[indexPath.section];
    LSProductItem *item = section.items[indexPath.row];
    
    if( item.controlClass )
    {
        UIViewController *destViewController = [[item.controlClass alloc] init];
            
        [self.navigationController pushViewController:destViewController animated:YES];
        
        [self settingContentOff];
    }
}

#pragma mark - LSCityListViewDelegate
- (void)cityDidSelect:(LSCityListViewController *)cityViewController city:(NSString *)city
{
    self.leftBarLabel.text = city;
    _currentCity = city;
    weakify(self)
    
    [cityViewController dismissViewControllerAnimated:YES completion:^{
        
        strongify(self)
        // 加载天气
        [self parseWeather];
        
    }];
}

#pragma mark - LSLocationToolDelegate
- (void)stopLocation:(LSLocationInfo *)cityName
{
    self.currentCity = cityName.City;
}

- (void)cityDismissViewController:(LSCityListViewController *)cityViewController
{
    [cityViewController dismissViewControllerAnimated:YES completion:^{
        
        
    }];
}

#pragma mark - getter
- (NSMutableArray *)sections
{
    if( !_sections )
    {
        _sections = [NSMutableArray array];
    }
    return _sections;
}

#pragma mark - setter
- (void)setCurrentCity:(NSString *)currentCity
{
    _currentCity = currentCity;
    
    self.leftBarLabel.text = currentCity;
    
    [self updateWeather];
}

#pragma mark - events

- (void)tapWeatherView
{
    LSWeatherViewController *weatherVC = [[LSWeatherViewController alloc]init];
    weatherVC.weatherInfo = self.weatherInfo;
    [self.navigationController pushViewController:weatherVC animated:YES];
    [self settingContentOff];
}

- (void)selectCity:(id)sender
{
    UIViewController *contentVC = [LSCityListViewController loadCityController];
    contentVC.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popVC = contentVC.popoverPresentationController;
    popVC.barButtonItem = self.navigationItem.leftBarButtonItem;
    popVC.delegate = self;
    popVC.permittedArrowDirections = UIPopoverArrowDirectionAny;
    [self presentViewController:contentVC animated:YES completion:nil];
    
    return;
    
    UINavigationController *navigation = ({
        
        LSCityListViewController *cityVC = [LSCityListViewController loadCityController];
        cityVC.delegate = self;
        cityVC.selectedCity = self.leftBarLabel.text;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cityVC];
        nav;
        
    });
    
    [self presentViewController: navigation animated:YES completion:^{
        
        [self settingContentOff];
        
    }];
}

- (void)scanBarCode
{
    NSLog(@"scanBarCode");
    
    //设置扫码区域参数设置
    
    //创建参数对象
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    //矩形区域中心上移，默认中心点为屏幕中心点
    style.centerUpOffset = 44;
    
    //扫码框周围4个角的类型,设置为外挂式
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    
    //扫码框周围4个角绘制的线条宽度
    style.photoframeLineW = 6;
    
    //扫码框周围4个角的宽度
    style.photoframeAngleW = 24;
    
    //扫码框周围4个角的高度
    style.photoframeAngleH = 24;
    
    //扫码框内 动画类型 --线条上下移动
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //线条上下移动图片
    style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    
    //SubLBXScanViewController继承自LBXScanViewController
    //添加一些扫码或相册结果处理
    LSCodeScanViewController *scanVC = [[LSCodeScanViewController alloc] init];

    scanVC.style = style;
    
    scanVC.isQQSimulator = YES;

    [self.navigationController pushViewController:scanVC animated:YES];
}

#pragma mark - private Methods
- (void)settingContentOff
{
    self.collectionView.contentOffset = self.offY;
    [self.collectionView layoutIfNeeded];
    
//    [UIView animateWithDuration:0.25f animations:^{
//        
//        self.collectionView.contentOffset = self.offY;
//        [self.collectionView layoutIfNeeded];
//        
//    }];
}

- (void)dealloc
{
    [self.weatherTimer invalidate];
    self.weatherTimer = nil;
}

@end
