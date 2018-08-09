//
//  NSDate+Extension.m
//  SRClimate
//
//  Created by https://github.com/guowilling on 16/11/7.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

+ (NSString *)weekdayFromDate:(NSDate *)date {
    NSArray *weekdays = @[[NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[[NSTimeZone alloc] initWithName:@"Asia/Beijing"]];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitWeekday fromDate:date];
    return [weekdays objectAtIndex:dateComponents.weekday];
}

@end
