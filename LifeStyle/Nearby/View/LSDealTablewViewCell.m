//
//  LSDealTablewViewCell.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/17.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSDealTablewViewCell.h"
#import "UIImageView+WebCache.h"

@interface LSDealTablewViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listpriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orignalpriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchaseLabel;


@end

@implementation LSDealTablewViewCell


- (void)awakeFromNib {
    // Initialization code
    
    self.backgroundColor = kCollectionHeaderColor;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDeal:(LSDeal *)deal
{
    _deal = deal;
    
    // 标题
    self.titleLabel.text = deal.title;
    
    // 描述
    self.descriptionLabel.text = deal.desc;
    
    // 距离
    if( deal.distance <= 0 )
    {
        self.distanceLabel.text = @"<0.1km";
    }
    else
    {
        self.distanceLabel.text = [NSString stringWithFormat:@"%.1fkm",deal.distance * 1.0 / 1000];
    }
    
    // 图片
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:deal.s_image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"] options:SDWebImageLowPriority | SDWebImageRetryFailed];
    
    // 价格
    self.listpriceLabel.text = [NSString stringWithFormat:@"¥%@",deal.list_price_text];
    
    // 原价
    self.orignalpriceLabel.text = deal.current_price_text;
    
    // 销售
    if( deal.purchase_count > 9999 )
    {
        self.purchaseLabel.text = [NSString stringWithFormat:@"已售:%.1f万",deal.purchase_count*1.0/10000];
    }
    else
    {
        self.purchaseLabel.text = [NSString stringWithFormat:@"已售:%d",deal.purchase_count];
    }
}

@end
