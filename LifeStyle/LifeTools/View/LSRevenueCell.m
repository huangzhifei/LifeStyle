//
//  LSRevenueCell.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/12.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSRevenueCell.h"
#import "LSPersonalRevenueView.h"
#import "LSCommercialRevenueView.h"

@interface LSRevenueCell()

@property (strong, nonatomic) LSPersonalRevenueView     *personnalView;
@property (strong, nonatomic) LSCommercialRevenueView   *commercialView;

@property (strong, nonatomic) NSArray       *cache;
@property (weak, nonatomic) IBOutlet UIView *segView;
- (IBAction)revenueChoose:(id)sender;

@end

@implementation LSRevenueCell

+ (instancetype)loadCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

- (void)awakeFromNib {
    // Initialization code
    
    self.personnalView =({
        
        LSPersonalRevenueView *view = [LSPersonalRevenueView loadDIYView];
        view.frame = self.segView.bounds;
        [self.segView addSubview:view];
        view;
    });
    
    self.commercialView = ({
        
        LSCommercialRevenueView *view = [LSCommercialRevenueView loadDIYView];
        view.frame = self.segView.bounds;
        view;
        
    });
    
    self.cache = @[self.personnalView, self.commercialView];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)revenueChoose:(id)sender {
    
    UISegmentedControl *seg = (UISegmentedControl *)sender;

    NSLog(@"%ld", (long)seg.selectedSegmentIndex);
    
    [[[self.segView subviews] lastObject] removeFromSuperview];
    
    [[self.cache objectAtIndex:seg.selectedSegmentIndex] setFrame:self.segView.bounds];
    [self.segView addSubview:[self.cache objectAtIndex:seg.selectedSegmentIndex]];
}
@end
