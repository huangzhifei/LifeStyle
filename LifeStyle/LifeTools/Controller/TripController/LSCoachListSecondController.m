//
//  LSCoachListSecondController.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/11.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSCoachListSecondController.h"
#import "LSCoachDetailItem.h"
#import "LSCoachDetailController.h"

@interface LSCoachListSecondController ()

//@property (strong, nonatomic) NSArray *detailItems;

@end

@implementation LSCoachListSecondController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"列车站详情";
    
    [self hiddenExtraSeparateLine:self.tableView];
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = kCollectionHeaderColor;
}

- (void)didReceiveMemoryWarning
{
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
    return self.trainArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    LSCoachDetailItem *item = [self.trainArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@ - %@", item.startStation, item.endStation];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = kCollectionHeaderColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSCoachDetailItem *item = [self.trainArray objectAtIndex:indexPath.row];
    
    LSCoachDetailController *detailVC = [[LSCoachDetailController alloc] init];
    detailVC.detailItem = item;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
