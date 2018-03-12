//
//  NSDate+ASTest.m
//  AshishCalendarAppTests
//
//  Created by Ashish Singh on 2/6/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSDate+AS_DateHelpers.h"
@interface NSDate_ASTest : XCTestCase

@end

@implementation NSDate_ASTest

- (void)setUp {
    [super setUp];
}

- (void)testCountOfMonthsTillDate {
    NSDate *dateStart = [[NSDate class] dateForDay:1 month:1 year:2018];
    NSDate *endDate = [[NSDate class] dateForDay:31 month:12 year:2018];
    XCTAssertEqual([dateStart numberOfMonthsTillDate:endDate] + 1, 12);
    
    dateStart = [[NSDate class] dateForDay:1 month:1 year:2018];
    endDate = [[NSDate class] dateForDay:20 month:1 year:2018];
    XCTAssertEqual([dateStart numberOfMonthsTillDate:endDate], 0);
    
    dateStart = [[NSDate class] dateForDay:1 month:1 year:2018];
    endDate = [[NSDate class] dateForDay:20 month:2 year:2018];
    XCTAssertEqual([dateStart numberOfMonthsTillDate:endDate], 1);
}

- (void)testFirstDayOfMonth {
    NSDate *date = [[NSDate class] dateForDay:12 month:3 year:2018];
    NSDate *sutFirstDayDate = [date firstDayOfMonth];
    XCTAssertEqual(sutFirstDayDate.day, 1);
    XCTAssertEqual(sutFirstDayDate.month, 3);
    XCTAssertEqual(sutFirstDayDate.year, 2018);
}

- (void)testAdditionOfMonths {
    NSDate *date = [[NSDate class] dateForDay:12 month:3 year:2018];
    NSDate *sutDate = [date dateByAddingMonths:4];
    XCTAssertEqual(sutDate.day, 12);
    XCTAssertEqual(sutDate.month, 7);
    XCTAssertEqual(sutDate.year, 2018);
    
    sutDate = [date dateByAddingMonths:13];
    XCTAssertEqual(sutDate.day, 12);
    XCTAssertEqual(sutDate.month, 4);
    XCTAssertEqual(sutDate.year, 2019);
}

- (void)testAdditionOfDays {
    NSDate *date = [[NSDate class] dateForDay:6 month:2 year:2018];
    NSDate *sutDate = [date dateByAddingDays:5];
    XCTAssertEqual(sutDate.day, 11);
    XCTAssertEqual(sutDate.month, 2);
    XCTAssertEqual(sutDate.year, 2018);
    
    sutDate = [date dateByAddingDays:25];
    XCTAssertEqual(sutDate.day, 3);
    XCTAssertEqual(sutDate.month, 3);
    XCTAssertEqual(sutDate.year, 2018);
}

- (void)testLastDayOfMonth {
    NSDate *date = [[NSDate class] dateForDay:6 month:2 year:2018];
    NSDate *sutDate = [date lastDayOfMonth];
    XCTAssertEqual(sutDate.day, 28);
    XCTAssertEqual(sutDate.month, 2);
    XCTAssertEqual(sutDate.year, 2018);
    
    sutDate = [date dateByAddingDays:30];
    sutDate = [sutDate lastDayOfMonth];
    XCTAssertEqual(sutDate.day, 31);
    XCTAssertEqual(sutDate.month, 3);
    XCTAssertEqual(sutDate.year, 2018);
}

- (void)testDateStringFormat {
    NSDate *sutDate = [[NSDate class] dateForDay:6 month:2 year:2018];
    NSString *sutDateString = [sutDate dateStringWithDayMonthYear];
    XCTAssertEqualObjects(sutDateString, @"06022018");
    
    sutDate = [[NSDate class] dateForDay:31 month:3 year:2018];
    sutDateString = [sutDate dateStringWithDayMonthYear];
    XCTAssertEqualObjects(sutDateString, @"31032018");
    
    sutDate = [[NSDate class] dateForDay:2 month:11 year:2018];
    sutDateString = [sutDate dateStringWithDayMonthYear];
    XCTAssertEqualObjects(sutDateString, @"02112018");
}

- (void)testTwoDatesEquality {
    NSDate *sutDate1 = [[self class] dateForDayWithRandomHourMinutesSeconds:6 month:2 year:2018];
    NSDate *sutDate2 = [[self class] dateForDayWithRandomHourMinutesSeconds:6 month:2 year:2018];
    XCTAssertEqualObjects(sutDate1, sutDate2);
    
    sutDate1 = [[self class] dateForDayWithRandomHourMinutesSeconds:6 month:2 year:2019];
    sutDate2 = [[self class] dateForDayWithRandomHourMinutesSeconds:6 month:2 year:2018];
    XCTAssertNotEqualObjects(sutDate1, sutDate2);
    
    sutDate1 = [[self class] dateForDayWithRandomHourMinutesSeconds:6 month:3 year:2018];
    sutDate2 = [[self class] dateForDayWithRandomHourMinutesSeconds:6 month:2 year:2018];
    XCTAssertNotEqualObjects(sutDate1, sutDate2);
}

- (void)testNumberOfDaysInMonth {
    NSDate *sutDate1 = [[self class] dateForDayWithRandomHourMinutesSeconds:6 month:2 year:2018];
    XCTAssertEqual([sutDate1 numberOfDaysInMonth], 28);
    
    sutDate1 = [[self class] dateForDayWithRandomHourMinutesSeconds:6 month:3 year:2018];
    XCTAssertEqual([sutDate1 numberOfDaysInMonth], 31);
}



+ (NSDate *)dateForDayWithRandomHourMinutesSeconds:(NSInteger)day month:(NSInteger)month year:(NSInteger)year {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:day];
    [components setMonth:month];
    [components setYear:year];
    [components setHour:rand() % 20];
    [components setMinute:rand() % 60];
    [components setSecond:rand() % 60];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

@end
