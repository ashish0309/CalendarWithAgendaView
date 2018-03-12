//
//  NSDate+AS_DateHelpers.h
//  AshishCalendarApp
//
//  Created by Ashish Singh on 1/26/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (AS_DateHelpers)
- (NSInteger)numberOfMonthsTillDate:(NSDate *)endDate;
- (NSInteger)numberOfDaysTillDate:(NSDate *)endDate;
- (NSDate *)firstDayOfMonth;
- (NSDate *)dateByAddingDays:(NSInteger)days;
- (NSDate *)dateByAddingMonths:(NSInteger)months;
- (NSDate *)dateByAddingMonths:(NSInteger)months assignDays:(NSInteger)days;
- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)weekday;
- (NSInteger)day;
- (NSDate *)lastDayOfMonth;
- (NSString *)monthYearString;
- (NSString *)weekdayDayMonth;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)numberOfDaysInMonth;
- (BOOL)isEqualToDate:(NSDate *)otherDate;
- (NSDate *)assignHour:(NSInteger)hour minutes:(NSInteger)minutes;
- (NSDate *)dateByAddingHour:(NSInteger)hour minute:(NSInteger)minute;
- (NSDateComponents *)dateBySubstractingDate:(NSDate *)anotherDate;
- (NSString *)dateStringWithDayMonthYear;
+ (NSDate *)defaultEndDate;
+ (NSDate *)defaultStartDate;
+ (NSInteger)numberOfDaysInMonth:(NSInteger)month forYear:(NSInteger)year;
+ (NSArray *)weekdays;
+ (NSArray *)shortWeekDays;
+ (NSDateComponents *)currentCalendarComponents:(NSDate *)date;
+ (NSDate *)dateForDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year;
@end
