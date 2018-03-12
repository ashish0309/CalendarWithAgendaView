//
//  ASCalendarCellViewModelTest.m
//  AshishCalendarAppTests
//
//  Created by Ashish Singh on 2/4/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ASCalendarCellViewModel.h"
#import "NSDate+AS_DateHelpers.h"
#import "UIColor+AS.h"
@interface ASCalendarCellViewModelTest : XCTestCase <ASCalendarDateOperationDataSource>
@property (nonatomic, strong) ASCalendarCellViewModel *viewModel;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, assign) NSInteger offsetDays;
@end

@implementation ASCalendarCellViewModelTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testViewModelInitialization {
    self.selectedDate = [NSDate date];
    //Initialize required date variables
    self.startDate = [[self class] dateForDay:1 month:11 year:2017];
    self.endDate = [[self class] dateForDay:31 month:12 year:2020];
    
    //calendar starts from 5th weekday in Feb
    self.offsetDays = 4;
    
    //Initialize view model for 31 Jan 2018
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:3 inSection:3];
    self.viewModel = [[ASCalendarCellViewModel alloc] initWithCalendarDateSource:self indexPath:indexPath];
    XCTAssertEqualObjects(self.viewModel.dayText, @"");
    XCTAssertFalse(self.viewModel.selectedItem);
    XCTAssertTrue(self.viewModel.indicatorViewHidden);
    XCTAssertFalse(self.viewModel.userInteraction);
    
    //Initialize view model for 2 Feb, 2018
    indexPath = [NSIndexPath indexPathForItem:5 inSection:3];
    self.selectedDate = [[self class] dateForDay:2 month:2 year:2018];
    self.viewModel = [[ASCalendarCellViewModel alloc] initWithCalendarDateSource:self indexPath:indexPath];
    XCTAssertEqualObjects(self.viewModel.dayText, @"2");
    XCTAssertTrue(self.viewModel.selectedItem);
    XCTAssertTrue(self.viewModel.indicatorViewHidden);
    XCTAssertTrue(self.viewModel.userInteraction);
    
    //Initialize view model for 5 Feb, 2018
    indexPath = [NSIndexPath indexPathForItem:8 inSection:3];
    self.selectedDate = [[self class] dateForDay:2 month:2 year:2018];
    self.viewModel = [[ASCalendarCellViewModel alloc] initWithCalendarDateSource:self indexPath:indexPath];
    XCTAssertEqualObjects(self.viewModel.dayText, @"5");
    XCTAssertFalse(self.viewModel.selectedItem);
    XCTAssertFalse(self.viewModel.indicatorViewHidden);
    XCTAssertTrue(self.viewModel.userInteraction);
    
    //Initialize with today date
    NSDate *today = [NSDate date];
    NSDate *firstDay = [today firstDayOfMonth];
    NSInteger section = [self.startDate numberOfMonthsTillDate:firstDay];
    self.offsetDays = [firstDay weekday] - 1;
    indexPath = [NSIndexPath indexPathForItem:(self.offsetDays + [today day] - 1) inSection:section];
    self.selectedDate = [[self class] dateForDay:2 month:2 year:2018];
    self.viewModel = [[ASCalendarCellViewModel alloc] initWithCalendarDateSource:self indexPath:indexPath];
    NSString *dayText = [NSString stringWithFormat:@"%ld", [today day]];
    BOOL shouldShowIndicator = [self shouldShowIndicatorForDate:today];
    XCTAssertEqualObjects(self.viewModel.dayText, dayText);
    XCTAssertFalse(self.viewModel.selectedItem);
    XCTAssert(self.viewModel.indicatorViewHidden == !shouldShowIndicator);
    XCTAssertTrue(self.viewModel.userInteraction);
    XCTAssertEqualObjects(self.viewModel.textColor, [UIColor redColor]);
    
    self.selectedDate = [NSDate date];
    self.viewModel = [[ASCalendarCellViewModel alloc] initWithCalendarDateSource:self indexPath:indexPath];
    XCTAssertTrue(self.viewModel.selectedItem);
    
}

#pragma mark ASCalendarDateOperationDataSource
- (BOOL)shouldShowIndicatorForDate:(NSDate *)date {
    NSDateComponents *components = [NSDate currentCalendarComponents:date];
    if (components.day % 3 == 0 || components.day % 5 == 0) {
        return YES;
    }
    if (components.weekday == 3) {
        return YES;
    }
    if (components.month == 6 || components.month == 3) {
        return YES;
    }
    return NO;
}

- (NSDate *)dateAtIndexPath:(NSIndexPath *)indexPath {
    NSDate* date = [self.startDate dateByAddingMonths:indexPath.section assignDays:indexPath.item + 1];
    return [date dateByAddingDays:-_offsetDays];
}

- (NSInteger)monthForSection:(NSInteger)section {
    NSDate *firstDayOfMonth = [[self.startDate firstDayOfMonth] dateByAddingMonths:section];
    return [firstDayOfMonth month];
}

+ (NSDate *)dateForDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    [comps setMonth:month];
    [comps setYear:year];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

@end
