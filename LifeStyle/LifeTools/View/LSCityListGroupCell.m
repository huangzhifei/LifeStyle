//
//  LSCityListCell.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/6.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#define     MIN_SPACE            8           // 城市button最小间隙
#define     MAX_SPACE            10

#define     WIDTH_LEFT           13.5        // button左边距
#define     WIDTH_RIGHT          28          // button右边距

#define     MIN_WIDTH_BUTTON     80
#define     HEIGHT_BUTTON        40
#define     MAX_CITYBUTTON_COUNT 8
#import "LSCityListGroupCell.h"
#import "LSCityInfo.h"

@interface LSCityListGroupCell()

@end

@implementation LSCityListGroupCell

#pragma mark - override
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if( self )
    {
        self.backgroundColor    = [UIColor colorWithWhite:237/255.0 alpha:1.0];
        self.selectionStyle     = UITableViewCellSelectionStyleNone;

        [self addSubview:self.titleLabel];
        [self addSubview:self.nothingLabel];
    }
    
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    float x = WIDTH_LEFT;
    float y = 5;
    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    [self.titleLabel setFrame:CGRectMake(x, y, self.frame.size.width - x, size.height)];
    y += size.height + 3;
    [self.nothingLabel setFrame:CGRectMake(x + 5, y, self.frame.size.width - x - 5, self.titleLabel.frame.size.height)];
    
    y += 7;
    float space = MIN_SPACE;
    float width = MIN_WIDTH_BUTTON;
    int t = (self.frame.size.width - WIDTH_LEFT - WIDTH_RIGHT + space) / (width + space);
    
    // 修正空隙宽度
    space = (self.frame.size.width - WIDTH_LEFT - WIDTH_RIGHT - width * t) / (t - 1);
    
    if (space > MAX_SPACE)
    {
        width += (space - MAX_SPACE) * (t - 1) / t;
        space = MAX_SPACE;
    }
    
    for( NSInteger i = 0; i < self.cityButtons.count; ++i )
    {
        UIButton *button = [self.cityButtons objectAtIndex:i];
        [button setFrame:CGRectMake(x, y, width, HEIGHT_BUTTON)];
        if ((i + 1) % t == 0)
        {
            y += HEIGHT_BUTTON + 5;
            x = WIDTH_LEFT;
        }
        else
        {
            x += width + space;
        }
    }
}

#pragma mark - getter
- (UILabel *) titleLabel
{
    if (_titleLabel == nil)
    {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    }
    return _titleLabel;
}

- (UILabel *)nothingLabel
{
    if (_nothingLabel == nil)
    {
        _nothingLabel = [[UILabel alloc] init];
        [_nothingLabel setText:@"暂无数据"];
        [_nothingLabel setTextColor:[UIColor grayColor]];
        [_nothingLabel setFont:[UIFont systemFontOfSize:17.0f]];
    }
    return _nothingLabel;
}

- (NSMutableArray *) cityButtons
{
    if (_cityButtons == nil)
    {
        _cityButtons = [[NSMutableArray alloc] init];
    }
    return _cityButtons;
}

#pragma mark - setter
- (void)setCityArray:(NSArray *)cityArray
{
    _cityArray = cityArray;
    
    self.nothingLabel.hidden = (_cityArray !=nil && _cityArray.count > 0);
    for(NSInteger i = 0; i < _cityArray.count; ++ i)
    {
        NSString *cityName = [_cityArray objectAtIndex:i];
        UIButton *button;
        if( i < self.cityButtons.count )
        {
            button = [self.cityButtons objectAtIndex:i];
        }
        else
        {
            button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.backgroundColor = [UIColor whiteColor];
            [button setTitleColor:[UIColor colorWithWhite:78/255.0 alpha:1.0] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
            button.layer.cornerRadius = 3.0f;
            button.layer.masksToBounds = YES;
            button.layer.borderWidth = 1.0f;
            button.layer.borderColor = [UIColor colorWithWhite:176/255.0 alpha:1.0].CGColor;
            [button addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
            [self.cityButtons addObject:button];
            [self addSubview:button];
        }
        [button setTitle:cityName forState:UIControlStateNormal];
        button.tag = i;
    }
    
    while(_cityArray.count < self.cityButtons.count) {
        [self.cityButtons removeLastObject];
    }
}

#pragma mark - events
- (void)buttonSelected:(UIButton *)sender
{
    NSString *cityName = [self.cityArray objectAtIndex:sender.tag];
    if(self.delegate && [self.delegate respondsToSelector:@selector(cityGroupCellDidSelectCity:)])
    {
        [self.delegate cityGroupCellDidSelectCity:cityName];
    }
}

#pragma mark - public Method
+ (CGFloat)cellHeightOfCityArray:(NSArray *)cityArray
{
    CGFloat cellHeight = 36;
    
    if( cityArray != nil && cityArray.count > 0 )
    {
        CGFloat space = MIN_SPACE;
        CGFloat width = MIN_WIDTH_BUTTON;
        
        NSInteger temp = (kScreenWidth - WIDTH_LEFT - WIDTH_RIGHT + space) / (width + space);
        
        //space = (kScreenWidth - WIDTH_LEFT - WIDTH_RIGHT - width * temp) / (temp - 1);
        
//        if(space > MAX_SPACE)
//        {
//            width += (space - MAX_SPACE) * (temp - 1) / temp;
//            space = MAX_SPACE;
//        }
        
        cellHeight += (10 + (HEIGHT_BUTTON + 5) * (cityArray.count / temp + (cityArray.count % temp == 0 ? 0 : 1)));
    }
    else
    {
        cellHeight += 17;
    }
    
    return cellHeight;
}


@end
