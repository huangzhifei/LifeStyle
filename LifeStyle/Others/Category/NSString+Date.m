//
//  NSString+Date.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/13.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)

+(NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    
    return currentDateString;
}

@end
