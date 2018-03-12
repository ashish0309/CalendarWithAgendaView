//
//  ASAgendaDataSource.m
//  AshishCalendarApp
//
//  Created by Ashish Singh on 1/31/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

#import "ASAgendaDataSource.h"
#import "NSDate+AS_DateHelpers.h"

@interface ASAgendaDataSource()
@property (nonatomic, strong) NSDictionary <NSString *, NSArray <ASCalendarAgenda *>*>*agendasDict;
@property (nonatomic, strong, readonly) NSDate *startDate;
@property (nonatomic, strong, readonly) NSDate *endDate;
@end
@implementation ASAgendaDataSource

- (instancetype)initWithDictionary:(NSDictionary <NSString *, NSArray <ASCalendarAgenda *>*>*)dict startDate:(NSDate *)sDate endDate:(NSDate *)eDate{
    self = [super init];
    if (self) {
        NSMutableDictionary *agendasDictionary = [NSMutableDictionary new];
        for (NSString *key in [dict allKeys]) {
            NSArray <ASCalendarAgenda *>*agendas = dict[key];
            //sort agendas with startDate and endDate
            NSSortDescriptor *descriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES];
            NSSortDescriptor *descriptor2 = [NSSortDescriptor sortDescriptorWithKey:@"endDate" ascending:YES];
            agendasDictionary[key] = [agendas sortedArrayUsingDescriptors:@[descriptor1, descriptor2]];
        }
        _agendasDict = [agendasDictionary copy];
        _startDate = sDate;
        _endDate = eDate;
    }
    return self;
}

- (NSInteger)numberOfSections {
    return [self.startDate numberOfDaysTillDate:self.endDate] + 1;
}

- (NSInteger)numberOfRowsForSection:(NSInteger)section {
    NSArray *agendas = [self agendasForSection:section];
    return agendas ? agendas.count : 1;
}

- (ASCalendarAgenda *)agendaForIndexPath:(NSIndexPath *)indexPath {
    NSArray <ASCalendarAgenda *>*agendas = [self agendasForSection:indexPath.section];
    return agendas ? agendas[indexPath.row] : nil;
}

- (NSArray <ASCalendarAgenda *>*)agendasForSection:(NSInteger)section {
    NSString *dateString = [self dateStringForSection:section];
    NSArray <ASCalendarAgenda *>* agendas = self.agendasDict[dateString];
    return agendas;
}

- (NSDate *)dateForSection:(NSInteger)section {
    return [self.startDate dateByAddingDays:section];
}

- (NSIndexPath *)indexPathForDate:(NSDate *)date {
    NSIndexPath *indexPath = nil;
    if (date) {
        NSDate *firstDayOfCalendar = [self.startDate firstDayOfMonth];
        NSInteger section = [firstDayOfCalendar numberOfDaysTillDate:date];
        indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    }
    return indexPath;
}

#pragma mark helpers
- (NSString *)dateStringForSection:(NSUInteger)section {
    NSDate *sectionDate = [self dateForSection:section];
    NSString *dateString = [sectionDate dateStringWithDayMonthYear];
    return dateString;
}

- (BOOL)agendaPresentForDate:(NSDate *)date {
    NSString *dateString = [date dateStringWithDayMonthYear];
    return self.agendasDict[dateString] != nil;
}
@end
