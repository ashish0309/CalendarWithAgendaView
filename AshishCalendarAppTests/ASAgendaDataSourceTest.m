//
//  ASAgendaDataSourceTest.m
//  AshishCalendarAppTests
//
//  Created by Ashish Singh on 2/6/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ASAgendaDataSource.h"
#import "NSDate+AS_DateHelpers.h"
#import "ASDummyAgendaData.h"

@interface ASAgendaDataSourceTest : XCTestCase
@property (nonatomic, strong) NSDictionary *agendasMappedToDate;
@property (nonatomic, strong) NSArray *agendas;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@end

@implementation ASAgendaDataSourceTest

- (void)setUp {
    [super setUp];
    _agendasMappedToDate = [ASDummyAgendaData agendasMappedToDate];
    _agendas = [ASDummyAgendaData agendas];
    _startDate = [NSDate defaultStartDate];
    _endDate = [NSDate defaultEndDate];
}

- (void)testInit {
    ASAgendaDataSource *agendasDataSource = [[ASAgendaDataSource alloc] initWithDictionary:self.agendasMappedToDate startDate:self.startDate endDate:self.endDate];
    NSDictionary *agendaDict = self.agendas[0];
    ASCalendarAgenda *calendarAgenda = [[ASCalendarAgenda alloc] initWithDictionary:agendaDict];
    NSIndexPath *indexPath = [agendasDataSource indexPathForDate:agendaDict[@"startDate"]];
    NSInteger numberOfdays = [self.startDate numberOfDaysTillDate:self.endDate] + 1;
    XCTAssertEqual([agendasDataSource numberOfSections], numberOfdays);
    XCTAssertEqual([agendasDataSource numberOfRowsForSection:indexPath.section], 3);
    XCTAssertEqualObjects(calendarAgenda, [agendasDataSource agendaForIndexPath:indexPath]);
    
    agendaDict = self.agendas[3];
    calendarAgenda = [[ASCalendarAgenda alloc] initWithDictionary:agendaDict];
    indexPath = [agendasDataSource indexPathForDate:agendaDict[@"startDate"]];
    numberOfdays = [self.startDate numberOfDaysTillDate:self.endDate] + 1;
    XCTAssertEqual([agendasDataSource numberOfSections], numberOfdays);
    XCTAssertEqual([agendasDataSource numberOfRowsForSection:indexPath.section], 2);
    XCTAssertEqualObjects(calendarAgenda, [agendasDataSource agendaForIndexPath:indexPath]);
    
    agendaDict = self.agendas[4];
    calendarAgenda = [[ASCalendarAgenda alloc] initWithDictionary:agendaDict];
    ASCalendarAgenda *agendaFromDataSource = [agendasDataSource agendaForIndexPath:[NSIndexPath indexPathForRow:1 inSection:indexPath.section]];
    XCTAssertEqualObjects(calendarAgenda, agendaFromDataSource);
}

- (void)testAgendaDataSourceSectionsWithoutAgendas {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:5];
    [components setMonth:3];
    [components setYear:2018];
    [components setHour:9];
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    ASAgendaDataSource *agendasDataSource = [[ASAgendaDataSource alloc] initWithDictionary:self.agendasMappedToDate startDate:_startDate endDate:_endDate];
    NSIndexPath *indexPath = [agendasDataSource indexPathForDate:date];
    XCTAssertFalse([agendasDataSource agendaPresentForDate:date]);
    XCTAssertEqual([agendasDataSource numberOfRowsForSection:indexPath.section], 1);
}



@end
