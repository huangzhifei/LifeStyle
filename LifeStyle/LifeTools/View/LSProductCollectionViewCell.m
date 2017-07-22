//
//  LSProductCollectionViewCell.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/4.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSProductCollectionViewCell.h"

@interface LSProductCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation LSProductCollectionViewCell

- (void)awakeFromNib
{
    self.imageView.layer.cornerRadius = 8;
    self.imageView.clipsToBounds = YES;
    self.backgroundColor = kCollectionHeaderColor;
    self.clipsToBounds = YES;
}

- (void)setProudctItem:(LSProductItem *)proudctItem
{
    _proudctItem = proudctItem;
    
    self.imageView.image = [UIImage imageNamed:proudctItem.image];
    self.title.text = proudctItem.title;
}

@end
