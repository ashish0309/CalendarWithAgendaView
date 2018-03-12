//
//  ASAgendaTest.m
//  AshishCalendarAppTests
//
//  Created by Ashish Singh on 2/6/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ASDummyAgendaData.h"
#import "ASCalendarAgenda.h"
@interface ASAgendaTest : XCTestCase
@property (nonatomic, strong) NSArray *agendas;
@end

@implementation ASAgendaTest

- (void)setUp {
    [super setUp];
    _agendas = [ASDummyAgendaData agendas];
}

- (void)testInit {
    ASCalendarAgenda *agenda = [[ASCalendarAgenda alloc] initWithDictionary:self.agendas[0]];
    XCTAssertNotNil(agenda.startDateText);
    XCTAssertEqualObjects(agenda.startDateText, @"9:00 AM");
    XCTAssertNotNil(agenda.durationText);
    XCTAssertEqualObjects(agenda.durationText, @"45m");
    XCTAssertNotNil(agenda.dateString);
    XCTAssertEqualObjects(agenda.dateString, @"04022018");
    XCTAssertNotNil(agenda.agendaText);
    XCTAssertEqualObjects(agenda.agendaText, @"Agenda 1");
    
    agenda = [[ASCalendarAgenda alloc] initWithDictionary:self.agendas[2]];
    XCTAssertNotNil(agenda.startDateText);
    XCTAssertEqualObjects(agenda.startDateText, @"2:00 PM");
    XCTAssertNotNil(agenda.durationText);
    XCTAssertEqualObjects(agenda.durationText, @"2h 30m");
    XCTAssertNotNil(agenda.dateString);
    XCTAssertEqualObjects(agenda.dateString, @"04022018");
    XCTAssertNotNil(agenda.agendaText);
    XCTAssertEqualObjects(agenda.agendaText, @"Agenda 3");
}

@end
