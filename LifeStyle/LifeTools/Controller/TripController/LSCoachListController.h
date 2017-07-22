//
//  LSCoachListController.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/11.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import <UIKit/UIKit.h>

// 以时间作为 cell 
@interface LSCoachListController : UITableViewController

@property (strong, nonatomic) NSDictionary *listCoach;
@property (strong, nonatomic) NSString *fromCity;
@property (strong, nonatomic) NSString *toCity;

@end
