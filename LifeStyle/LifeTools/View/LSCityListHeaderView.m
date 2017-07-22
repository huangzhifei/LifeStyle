//
//  LSCityListHeaderView.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/6.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSCityListHeaderView.h"

@interface LSCityListHeaderView()

@property (strong, nonatomic) UIView *seperatorView;

@end

@implementation LSCityListHeaderView

//UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
//CGRect sepFrame = CGRectMake(0, view.frame.size.height-1, 320, 1);
//UIView *seperatorView =[[UIView alloc] initWithFrame:sepFrame];
//seperatorView.backgroundColor = [UIColor colorWithWhite:224.0/255.0 alpha:1.0];
//[header addSubview:seperatorView];

#pragma mark - init
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if( self )
    {
        self.contentView.backgroundColor = [UIColor colorWithWhite:224/255.0 alpha:1.0];
        self.seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2.0,
                                                                      self.frame.size.width - 10, 1)];
        
        [self addSubview:self.seperatorView];
        [self addSubview:self.titleLabel];
    }
    
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel setFrame:CGRectMake(10, 0, 60, self.frame.size.height)];
    
}

#pragma mark - getter
- (UILabel *) titleLabel
{
    if (_titleLabel == nil)
    {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [_titleLabel setTextColor:[UIColor colorWithWhite:0.3 alpha:1.0]];
    }
    
    return _titleLabel;
}

@end
