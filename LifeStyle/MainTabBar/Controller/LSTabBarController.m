//
//  LSTabBarController.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/4.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSTabBarController.h"
#import "CSStickyHeaderFlowLayout.h"
#import "LSNavigationController.h"
#import "LSToolCollectionViewController.h"
#import "LSNewsViewContorller.h"
#import "LSSettingsViewController.h"
#import "LSNearbySearchController.h"

@interface LSTabBarController ()

@property (strong, nonatomic) LSToolCollectionViewController *lifeTool;
@property (strong, nonatomic) LSNewsViewContorller           *news;

@end

@implementation LSTabBarController

#pragma mark - init
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self testGCD];
    
    NSMutableArray *mutable = [NSMutableArray array];
    NSArray *arr = [[NSArray alloc] init];
    for(int i = 0; i < 5; ++ i)
    {
        arr = @[[NSString stringWithFormat:@"test %d",i]];
        [mutable addObject:arr];
    }
    
    [self initCommon];
}

- (void)testGCD
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSLog(@"----- 1 -----");
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            NSLog(@"----- 2 -----");
        });
        
        NSLog(@"---- 3 -----");
    });
    
    NSLog(@"------ 4 ------");
    
    while (1) {
        
    }
    
    NSLog(@" ----- 5 ------");
}

- (void)initCommon
{
    [self customBarbg];
    
    self.lifeTool = ({
        
        // 创建布局
        CSStickyHeaderFlowLayout *layout = [[CSStickyHeaderFlowLayout alloc]init];
        // 设置cell尺寸
        layout.itemSize = CGSizeMake(kLayoutCell, kLayoutCell);
        // 设置水平间距
        layout.minimumInteritemSpacing = 0;
        // 设置垂直间距
        layout.minimumLineSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
        layout.parallaxHeaderReferenceSize = CGSizeMake(self.view.frame.size.width, kLayoutCell * 2);
        layout.headerReferenceSize = CGSizeMake(200, 50);
        
        LSToolCollectionViewController *collection = [[LSToolCollectionViewController alloc] initWithCollectionViewLayout:layout];
        
        collection;
        
    });
    [self addBarItems:self.lifeTool title:@"工具" normalImage:@"icon_tab_life_normal" selectImageName:@"icon_tab_life_highlight"];
    
    // 新闻控制器
    self.news = [[LSNewsViewContorller alloc]init];
    [self addBarItems:self.news title:@"新闻" normalImage:@"icon_tab_new_normal" selectImageName:@"icon_tab_new_highlight"];
    
    // 团购控制器
    LSNearbySearchController *discover = [[LSNearbySearchController alloc]init];
    [self addBarItems:discover title:@"附近" normalImage:@"icon_tab_buy_normal" selectImageName:@"icon_tab_buy_highlight"];
    
    // 更多控制器
    LSSettingsViewController *more = [[LSSettingsViewController alloc]init];
    [self addBarItems:more title:@"我的" normalImage:@"icon_tab_setting_normal" selectImageName:@"icon_tab_setting_highlight"];

}

- (void)customBarbg
{
    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    bgView.backgroundColor = [kCollectionHeaderColor colorWithAlphaComponent:0.9];
    [self.tabBar insertSubview:bgView atIndex:0];
    self.tabBar.opaque = YES;
}

- (void)addBarItems:(UIViewController *)controller
                      title:(NSString *)title
                normalImage:(NSString *)normalImageName
            selectImageName:(NSString *)selectImageName
{
    
    // UIImageRenderingModeAlwaysOriginal render image color
    controller.title = title;
    controller.tabBarItem.image = [[UIImage imageNamed:normalImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 添加到导航控制器
    LSNavigationController *nav = [[LSNavigationController alloc] initWithRootViewController:controller];
    [self addChildViewController:nav];
}

#pragma mark - setter
- (void) setLocationCity:(NSString *)locationCity
{
    _locationCity = locationCity;
    
    //self.lifeTool.currentCity = locationCity;
}

#pragma mark - lifecycle
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
