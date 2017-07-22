//
//  AppDelegate.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/4.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "AppDelegate.h"
#import "LSTabBarController.h"
#import "LSLocationTool.h"
#import "LSNearbyMetaDataTool.h"

@interface AppDelegate ()

@property (strong, nonatomic) LSLocationTool *tool;
@property (strong, nonatomic) LSTabBarController *tabVC;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self initData];
    
    self.window = [[UIWindow alloc] initWithFrame:kScreen];
    self.window.backgroundColor = [UIColor whiteColor];
    self.tabVC = [[LSTabBarController alloc] init];
    self.window.rootViewController = self.tabVC;
    
    [self.window makeKeyAndVisible];
    
    [self setDIYNavigationStyle];
    
    [self setTabItemTextColor];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - private Methods
- (void)setTabItemTextColor
{
    //[[UITabBar appearance] setTintColor:[UIColor redColor]];
    
    // 设置UISearchBar cancelButton text color
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor redColor]];
    
    [UITabBarItem.appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[[UIColor whiteColor] colorWithAlphaComponent:0.85]}
                                           forState:UIControlStateNormal];
    
    // then if StateSelected should be different, you should add this code
    [UITabBarItem.appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName : [UIColor redColor]}
                                           forState:UIControlStateSelected];
    
}

- (void)setDIYNavigationStyle
{
    UINavigationBar *bar = [UINavigationBar appearance];
    
    //设置显示的颜色
    
    bar.barTintColor = [UIColor colorWithRed:21/255.0 green:90/255.0 blue:19/255.0 alpha:1.0];
    
    //设置字体颜色
    
    bar.tintColor = [UIColor whiteColor];
    
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
}

- (void)initData
{
    [[LSNearbyMetaDataTool sharedLSNearbyMetaDataTool].location startLocation];
}

@end
