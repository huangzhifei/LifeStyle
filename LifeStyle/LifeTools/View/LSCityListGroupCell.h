//
//  LSCityListCell.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/6.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSCityGroupCellDelegate.h"

@interface LSCityListGroupCell : UITableViewCell

@property (weak  , nonatomic) id<LSCityGroupCellDelegate>delegate;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *nothingLabel;
@property (strong, nonatomic) NSMutableArray *cityButtons;
@property (strong, nonatomic) NSArray *cityArray;

+ (CGFloat) cellHeightOfCityArray:(NSArray *)cityArray;

@end
