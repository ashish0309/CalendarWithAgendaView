//
//  ASCalendarViewControllerTest.m
//  AshishCalendarAppTests
//
//  Created by Ashish Singh on 2/6/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"
#import "ASAgendaView.h"
#import "ASCalendarView.h"
#import "ASAgendaDataSource.h"
#import "NSDate+AS_DateHelpers.h"
#import "ASCalendarWeekdayView.h"
#import <UIKit/UIKit.h>

@interface ViewController (Testing)
@property (nonatomic, strong) ASCalendarView *calendarView;
@property (nonatomic, strong) ASAgendaView* agendaView;
@property (nonatomic, strong) UILabel *titleView;
@property (nonatomic, strong) ASAgendaDataSource *agendaDataSource;
@end

@interface ASCalendarView (Testing)
@property (nonatomic, assign) NSInteger currentVisibleSection;
- (NSIndexPath *)indexPathForDate:(NSDate *)date;
@end

@interface ASAgendaView (Testing)
@property (nonatomic, strong) UITableView *tableView;
@end

@interface ASCalendarViewControllerTest : XCTestCase
@property (nonatomic, strong) ViewController *calendarVC;
@end

@implementation ASCalendarViewControllerTest

- (void)setUp {
    [super setUp];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *navVC = [storyboard instantiateInitialViewController];
    _calendarVC = (ViewController *)navVC.topViewController;
    UIApplication.sharedApplication.keyWindow.rootViewController = _calendarVC;
    XCTAssertNotNil(navVC.view);
    XCTAssertNotNil(_calendarVC.view);
}

- (void)testExpansionOfCalendarViewWhenSelectedMonthHas6Rows {
    //Month with days going to 6 rows on UI
    NSDate *dateSelected = [[NSDate class] dateForDay:1 month:9 year:2018];
    [self.calendarVC.calendarView scrollCalendarToDate:dateSelected animated:NO];
    CGFloat calendarViewHeight = floorf(self.calendarVC.view.bounds.size.width / 7.0f) * 6 + WEEKDAY_VIEW_HEIGHT;
    XCTAssertEqualWithAccuracy(self.calendarVC.calendarView.bounds.size.height, calendarViewHeight, 0.1);
    XCTAssertTrue([dateSelected isEqualToDate:self.calendarVC.calendarView.selectedDate]);
}

- (void)testExpansionOfCalendarViewWhenSelectedMonthHas5Rows {
    //Month with days going to 5 rows on UI
    NSDate *dateSelected = [[NSDate class] dateForDay:1 month:8 year:2018];
    [self.calendarVC.view layoutIfNeeded];
    [self.calendarVC.calendarView scrollCalendarToDate:dateSelected animated:NO];
    CGFloat calendarViewHeight = floorf(self.calendarVC.view.bounds.size.width / 7.0f) * 5 + WEEKDAY_VIEW_HEIGHT;
    XCTAssertEqualWithAccuracy(self.calendarVC.calendarView.bounds.size.height, calendarViewHeight, 0.1);
    XCTAssertTrue([dateSelected isEqualToDate:self.calendarVC.calendarView.selectedDate]);
}

- (void)testCalendarViewScrollToSelectedDate {
    NSDate *dateSelected = [[NSDate class] dateForDay:1 month:8 year:2018];
    NSIndexPath *indexPath = [self.calendarVC.calendarView indexPathForDate:dateSelected];
    [self.calendarVC.view layoutIfNeeded];
    [self.calendarVC.calendarView scrollCalendarToDate:dateSelected animated:NO];
    XCTAssertTrue([dateSelected isEqualToDate:self.calendarVC.calendarView.selectedDate]);
    XCTAssertEqual(self.calendarVC.calendarView.currentVisibleSection, indexPath.section);
    
    dateSelected = [[NSDate class] dateForDay:20 month:10 year:2018];
    indexPath = [self.calendarVC.calendarView indexPathForDate:dateSelected];
    [self.calendarVC.calendarView scrollCalendarToDate:dateSelected animated:NO];
    XCTAssertTrue([dateSelected isEqualToDate:self.calendarVC.calendarView.selectedDate]);
    XCTAssertEqual(self.calendarVC.calendarView.currentVisibleSection, indexPath.section);
    
}

- (void)testAgendaViewScrollToSectionOnWhenDateIsSelectedInCalendarView {
    NSDate *dateSelected = [[NSDate class] dateForDay:1 month:8 year:2018];
    NSIndexPath *indexPath = [[self class] indexPathForDate:dateSelected];
    [self.calendarVC.view layoutIfNeeded];
    [self.calendarVC.agendaView scrollAgendaViewToDate:dateSelected animated:NO];
    NSInteger topSection = [[self.calendarVC.agendaView.tableView indexPathsForVisibleRows][0] section];
    XCTAssertEqual(topSection, indexPath.section);
    
    dateSelected = [[NSDate class] dateForDay:20 month:5 year:2014];
    indexPath = [[self class] indexPathForDate:dateSelected];
    [self.calendarVC.agendaView scrollAgendaViewToDate:dateSelected animated:NO];
    topSection = [[self.calendarVC.agendaView.tableView indexPathsForVisibleRows][0] section];
    XCTAssertEqual(topSection, indexPath.section);
    
    dateSelected = [[NSDate class] dateForDay:20 month:5 year:2015];
    indexPath = [[self class] indexPathForDate:dateSelected];
    [self.calendarVC.agendaView scrollAgendaViewToDate:dateSelected animated:NO];
    topSection = [[self.calendarVC.agendaView.tableView indexPathsForVisibleRows][0] section];
    XCTAssertEqual(topSection, indexPath.section);
    
    dateSelected = [[NSDate class] dateForDay:20 month:7 year:2015];
    indexPath = [[self class] indexPathForDate:dateSelected];
    [self.calendarVC.agendaView scrollAgendaViewToDate:dateSelected animated:NO];
    topSection = [[self.calendarVC.agendaView.tableView indexPathsForVisibleRows][0] section];
    XCTAssertEqual(topSection, indexPath.section);
    
    dateSelected = [[NSDate class] dateForDay:12 month:8 year:2015];
    indexPath = [[self class] indexPathForDate:dateSelected];
    [self.calendarVC.agendaView scrollAgendaViewToDate:dateSelected animated:NO];
    topSection = [[self.calendarVC.agendaView.tableView indexPathsForVisibleRows][0] section];
    XCTAssertEqual(topSection, indexPath.section);
    
    dateSelected = [[NSDate class] dateForDay:12 month:8 year:2017];
    indexPath = [[self class] indexPathForDate:dateSelected];
    [self.calendarVC.agendaView scrollAgendaViewToDate:dateSelected animated:NO];
    topSection = [[self.calendarVC.agendaView.tableView indexPathsForVisibleRows][0] section];
    XCTAssertEqual(topSection, indexPath.section);
    
    dateSelected = [[NSDate class] dateForDay:3 month:3 year:2014];
    indexPath = [[self class] indexPathForDate:dateSelected];
    [self.calendarVC.agendaView scrollAgendaViewToDate:dateSelected animated:NO];
    topSection = [[self.calendarVC.agendaView.tableView indexPathsForVisibleRows][0] section];
    XCTAssertEqual(topSection, indexPath.section);
}


+ (NSIndexPath *)indexPathForDate:(NSDate *)date {
    NSIndexPath *indexPath = nil;
    if (date) {
        NSDate *firstDayOfCalendar = [[NSDate defaultStartDate] firstDayOfMonth];
        NSInteger section = [firstDayOfCalendar numberOfDaysTillDate:date];
        indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    }
    return indexPath;
}
@end
