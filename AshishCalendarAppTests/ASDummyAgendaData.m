//
//  ASDummyAgendaData.m
//  AshishCalendarAppTests
//
//  Created by Ashish Singh on 2/6/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

#import "ASDummyAgendaData.h"
#import "ASCalendarAgenda.h"
@implementation ASDummyAgendaData

+ (NSArray *)agendas {
    NSMutableArray *agendas = [NSMutableArray new];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:4];
    [components setMonth:2];
    [components setYear:2018];
    [components setHour:9];
    NSDate *startDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    components = [[NSDateComponents alloc] init];
    [components setDay:4];
    [components setMonth:2];
    [components setYear:2018];
    [components setHour:9];
    [components setMinute:45];
    NSDate *endDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    NSDictionary *dict = @{
                           @"startDate": startDate,
                           @"endDate": endDate,
                           @"agenda": @"Agenda 1"
                           };
    [agendas addObject:dict];
    
    components = [[NSDateComponents alloc] init];
    [components setDay:4];
    [components setMonth:2];
    [components setYear:2018];
    [components setHour:9];
    startDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    components = [[NSDateComponents alloc] init];
    [components setDay:4];
    [components setMonth:2];
    [components setYear:2018];
    [components setHour:10];
    [components setMinute:30];
    endDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    dict = @{
             @"startDate": startDate,
             @"endDate": endDate,
             @"agenda": @"Agenda 2"
             };
    [agendas addObject:dict];
    
    components = [[NSDateComponents alloc] init];
    [components setDay:4];
    [components setMonth:2];
    [components setYear:2018];
    [components setHour:14];
    startDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    components = [[NSDateComponents alloc] init];
    [components setDay:4];
    [components setMonth:2];
    [components setYear:2018];
    [components setHour:16];
    [components setMinute:30];
    endDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    dict = @{
             @"startDate": startDate,
             @"endDate": endDate,
             @"agenda": @"Agenda 3"
             };
    [agendas addObject:dict];
    
    
    components = [[NSDateComponents alloc] init];
    [components setDay:6];
    [components setMonth:2];
    [components setYear:2018];
    [components setHour:6];
    [components setMinute:30];
    startDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    components = [[NSDateComponents alloc] init];
    [components setDay:6];
    [components setMonth:2];
    [components setYear:2018];
    [components setHour:7];
    [components setMinute:30];
    endDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    dict = @{
             @"startDate": startDate,
             @"endDate": endDate,
             @"agenda": @"Agenda 4"
             };
    [agendas addObject:dict];
    
    
    components = [[NSDateComponents alloc] init];
    [components setDay:6];
    [components setMonth:2];
    [components setYear:2018];
    [components setHour:14];
    [components setMinute:30];
    startDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    components = [[NSDateComponents alloc] init];
    [components setDay:6];
    [components setMonth:2];
    [components setYear:2018];
    [components setHour:15];
    [components setMinute:0];
    endDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    dict = @{
             @"startDate": startDate,
             @"endDate": endDate,
             @"agenda": @"Agenda 5"
             };
    [agendas addObject:dict];
    
    components = [[NSDateComponents alloc] init];
    [components setDay:9];
    [components setMonth:2];
    [components setYear:2018];
    [components setHour:14];
    [components setMinute:30];
    startDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    components = [[NSDateComponents alloc] init];
    [components setDay:9];
    [components setMonth:2];
    [components setYear:2018];
    [components setHour:16];
    [components setMinute:0];
    endDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    dict = @{
             @"startDate": startDate,
             @"endDate": endDate,
             @"agenda": @"Agenda 6"
             };
    [agendas addObject:dict];
    
    return agendas;
}

+ (NSArray <ASCalendarAgenda *>*)calendarAgendaObjects {
    NSMutableArray <ASCalendarAgenda *>* cAgendas = [NSMutableArray new];
    for (NSDictionary *dict in [self agendas]) {
        [cAgendas addObject:[[ASCalendarAgenda alloc] initWithDictionary:dict]];
    }
    return cAgendas;
}

+ (NSDictionary *)agendasMappedToDate {
    NSMutableDictionary *agendasDictionary = [NSMutableDictionary new];
    for (ASCalendarAgenda *agenda in [self calendarAgendaObjects]) {
        NSString *key = agenda.dateString;
        NSMutableArray *agendas = [(agendasDictionary[key] ? : @[]) mutableCopy];
        [agendas addObject:agenda];
        agendasDictionary[agenda.dateString] = [agendas copy];
    }
    return [agendasDictionary copy];
}
@end
