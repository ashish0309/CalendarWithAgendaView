//
//  NSDate+AS_DateHelpers.m
//  AshishCalendarApp
//
//  Created by Ashish Singh on 1/26/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

#import "NSDate+AS_DateHelpers.h"

@implementation NSDate (AS_DateHelpers)

- (NSInteger)numberOfMonthsTillDate:(NSDate *)endDate {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitMonth fromDate:self toDate:endDate options:0];
    return components.month;
}

- (NSDate *)firstDayOfMonth {
    NSDateComponents* dateComponents = [[self class] currentCalendarComponents:self];
    [dateComponents setDay:1];
    return [[self class] currentCalendarDateFromComponents:dateComponents];
}

- (NSDate *)dateByAddingMonths:(NSInteger)months {
    NSDateComponents *components = [NSDateComponents new];
    components.month = months;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingDays:(NSInteger)days {
    NSDateComponents *components = [NSDateComponents new];
    components.day = days;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingMonths:(NSInteger)months assignDays:(NSInteger)days {
    NSDate* newDate = [self dateByAddingMonths:months];
    NSDateComponents *components = [[self class] currentCalendarComponents:newDate];
    components.day = days;
    newDate = [[self class] currentCalendarDateFromComponents:components];
    return newDate;
}

- (NSDate *)assignHour:(NSInteger)hour minutes:(NSInteger)minutes {
    NSDateComponents *components = [[self class] currentCalendarComponents:self];
    components.hour = hour;
    components.minute = minutes;
    components.second = 0;
    return [[self class] currentCalendarDateFromComponents:components];
}

- (NSDate *)dateByAddingHour:(NSInteger)hour minute:(NSInteger)minute {
    NSDateComponents *components = [NSDateComponents new];
    components.hour = hour;
    components.minute = minute;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDateComponents *)dateBySubstractingDate:(NSDate *)anotherDate {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekday|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:anotherDate toDate:self options:0];
    return components;
}

- (NSInteger)numberOfDaysTillDate:(NSDate *)endDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:self toDate:endDate options:0];
    return [components day];
}

- (NSInteger)weekday {
    NSDateComponents *components = [[self class] currentCalendarComponents:self];
    return [components weekday];
}

- (NSInteger)month {
    NSDateComponents *components = [[self class] currentCalendarComponents:self];
    return [components month];
}

- (NSInteger)year {
    NSDateComponents *components = [[self class] currentCalendarComponents:self];
    return [components year];
}

- (NSInteger)day {
    NSDateComponents *components = [[self class] currentCalendarComponents:self];
    return [components day];
}

- (NSInteger)hour {
    NSCalendar* currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [currentCalendar components:NSCalendarUnitHour fromDate:self];
    return [components hour];
}

- (NSInteger)minute {
    NSCalendar* currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [currentCalendar components:NSCalendarUnitMinute fromDate:self];
    return [components minute];
}

- (NSDate *)lastDayOfMonth {
    NSDateComponents *components = [[self class] currentCalendarComponents:self];
    NSInteger month = [components month];
    [components setMonth:month+1];
    [components setDay:0];
    return [[self class] currentCalendarDateFromComponents:components];
}

- (BOOL)isEqualToDate:(NSDate *)otherDate {
    if (self.day == otherDate.day &&
        self.month == otherDate.month &&
        self.year == otherDate.year) {
        return YES;
    }
    return NO;
}

- (NSString *)monthYearString {
    NSDateComponents *components = [[self class] currentCalendarComponents:self];
    NSString *monthYear = [NSString stringWithFormat:@"%@, %d",[[self class] monthNames][components.month], (int)components.year];
    return monthYear;
}

- (NSString *)weekdayDayMonth {
    NSDateComponents *components = [[self class] currentCalendarComponents:self];
    NSString *weekdayDayMonth = [NSString stringWithFormat:@"%@, %d %@",[[self class] weekdays][components.weekday], (int)components.day, [[self class] monthNames][components.month]];
    return weekdayDayMonth;
}

- (NSString *)dateStringWithDayMonthYear {
    NSString *day = [self day] < 10 ? [NSString stringWithFormat:@"0%d", (int)[self day]] : [NSString stringWithFormat:@"%d", (int)[self day]];
    NSString *month = [self month] < 10 ? [NSString stringWithFormat:@"0%d", (int)[self month]] : [NSString stringWithFormat:@"%d", (int)[self month]];
    return [NSString stringWithFormat:@"%@%@%d",day, month, (int)[self year]];
    
}

#pragma mark Helpers
+ (NSDate *)defaultEndDate {
    //return [[NSDate date] dateByAddingMonths:60];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:31];
    [comps setMonth:12];
    [comps setYear:2020];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

+ (NSDate *)defaultStartDate {
    //return [[NSDate date] dateByAddingMonths:-60];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    [comps setMonth:1];
    [comps setYear:2013];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

+ (NSDateComponents *)currentCalendarComponents:(NSDate *)date {
    NSCalendar* currentCalendar = [NSCalendar currentCalendar];
    return [currentCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekday|NSCalendarUnitDay fromDate:date];
}

+ (NSDate *)currentCalendarDateFromComponents:(NSDateComponents *)components {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateFromComponents:components];
}

- (NSInteger)numberOfDaysInMonth {
    return [[self class] numberOfDaysInMonth:[self month] forYear:[self year]];
}

+ (NSInteger)numberOfDaysInMonth:(NSInteger)month forYear:(NSInteger)year {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [NSDateComponents new];
    [components setMonth:month];
    [components setYear:year];
    NSDate *date = [calendar dateFromComponents:components];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}

+ (NSArray *)weekdays {
    return @[@"NotApplicable",
             @"Sunday",
             @"Monday",
             @"Tuesday",
             @"Wednesday",
             @"Thursday",
             @"Friday",
             @"Saturday"];
}

+ (NSArray *)shortWeekDays {
    return @[@"S",
             @"M",
             @"T",
             @"W",
             @"T",
             @"F",
             @"S"];
}

+ (NSArray *)monthNames {
    return @[@"NotApplicable",
             @"January",
             @"February",
             @"March",
             @"April",
             @"May",
             @"June",
             @"July",
             @"August",
             @"September",
             @"October",
             @"November",
             @"December"];
}

+ (NSArray *)shortMonthNames {
    return @[@"NotApplicable",
             @"Jan",
             @"Feb",
             @"Mar",
             @"Apr",
             @"May",
             @"Jun",
             @"Jul",
             @"Aug",
             @"Sep",
             @"Oct",
             @"Nov",
             @"Dec"];
}

+ (NSDate *)dateForDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:day];
    [components setMonth:month];
    [components setYear:year];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

@end
