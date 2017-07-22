//
//  LSCoachListController.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/11.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSCoachListController.h"
#import "LSCoachListSecondController.h"
#import "MBProgressHUD+MJ.h"

@interface LSCoachListController ()

@property (strong, nonatomic) NSArray *listDepartureTime;

@end

@implementation LSCoachListController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"列车时刻表";
    
    [MBProgressHUD showMessage:@"正在加载中..."];
    
    self.listDepartureTime = [[NSArray alloc] initWithArray:[self.listCoach allKeys]];
    self.listDepartureTime = [self.listDepartureTime sortedArrayUsingSelector:@selector(compare:)];
    
    [MBProgressHUD hideHUD];
    
    [self hiddenExtraSeparateLine:self.tableView];
    
    self.tableView.backgroundColor = kCollectionHeaderColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

- (void) hiddenExtraSeparateLine:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listDepartureTime.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *title = [self.listDepartureTime objectAtIndex:indexPath.row];
    title = [title stringByAppendingString:[[NSString alloc] initWithFormat:@"  %@-%@",self.fromCity, self.toCity]];
    cell.textLabel.text = title;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = kCollectionHeaderColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *timeKey = [self.listDepartureTime objectAtIndex:indexPath.row];
    
    NSArray *trainArray = [self.listCoach objectForKey:timeKey];
    LSCoachListSecondController *listSecondVC = [[LSCoachListSecondController alloc] init];
    listSecondVC.trainArray = trainArray;
    [self.navigationController pushViewController:listSecondVC animated:YES];
}

@end
