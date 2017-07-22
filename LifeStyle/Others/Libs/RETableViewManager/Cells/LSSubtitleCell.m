//
//  WBDetailLableCell.m
//  XinWeibo
//
//  Created by tanyang on 14/10/23.
//  Copyright (c) 2014年 tany. All rights reserved.
//

#import "LSSubtitleCell.h"

@interface LSSubtitleCell()

@property (nonatomic,weak) UILabel *subTitleLabel;

@end

@implementation LSSubtitleCell

@dynamic item;

+ (CGFloat)heightWithItem:(NSObject *)item tableViewManager:(RETableViewManager *)tableViewManager
{
    CGFloat CellHeight = ((LSSubtitleItem *)item).cellHeight;
    return CellHeight > 0 ? CellHeight : 36;
}

- (void)cellDidLoad
{
    [super cellDidLoad];
    UILabel *subTitleLabel = [[UILabel alloc]init];
    [self addSubview:subTitleLabel];
    self.subTitleLabel = subTitleLabel;
    
    self.subTitleLabel.font = [UIFont systemFontOfSize:11];
    self.subTitleLabel.textColor = [UIColor grayColor];
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = kCollectionHeaderColor;
}

- (void)cellWillAppear
{
    [super cellWillAppear];
    
    if (self.item.subtitleFont)
    {
        self.subTitleLabel.font = self.item.subtitleFont;
    }
    
    if (self.item.subtitle)
    {
        self.subTitleLabel.textAlignment = self.item.subtitleAlignment;
        self.subTitleLabel.text = self.item.subtitle;
    }

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSDictionary *attr = @{NSFontAttributeName : self.textLabel.font};
    CGFloat textLabelW = [self.textLabel.text sizeWithAttributes:attr].width;
    CGFloat subtitleLableY = self.textLabel.frame.origin.y;
    CGFloat subtitleLableH = self.textLabel.frame.size.height;
    CGFloat subtitleLableX = self.textLabel.frame.origin.x + textLabelW + 6;
    CGFloat rightInset = self.accessoryView ? 40 : 20;
    CGFloat subtitleLableW = self.frame.size.width - subtitleLableX - rightInset;

    self.subTitleLabel.frame = CGRectMake(subtitleLableX, subtitleLableY, subtitleLableW, subtitleLableH);
    
}

@end
