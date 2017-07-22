//
//  LSPersonalRevenueView.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/12.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSPersonalRevenueView.h"

@interface LSPersonalRevenueView()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *allSalary;
@property (weak, nonatomic) IBOutlet UITextField *safeMoney;
@property (weak, nonatomic) IBOutlet UITextField *salary_1;
@property (weak, nonatomic) IBOutlet UITextField *salary_2;
@property (weak, nonatomic) IBOutlet UITextField *salary_3;
@property (weak, nonatomic) IBOutlet UITextField *salary_4;

@end

@implementation LSPersonalRevenueView

+ (instancetype)loadDIYView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    self.allSalary.delegate = self;
    self.safeMoney.delegate = self;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"---- %@", NSStringFromCGRect(self.frame));
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
@end
