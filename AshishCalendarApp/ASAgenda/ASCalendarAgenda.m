//
//  ASCalendarAgenda.m
//  AshishCalendarApp
//
//  Created by Ashish Singh on 1/30/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

#import "ASCalendarAgenda.h"
#import "NSDate+AS_DateHelpers.h"
@interface ASCalendarAgenda()
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@end
@implementation ASCalendarAgenda

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _startDate = dict[@"startDate"];
        _endDate = dict[@"endDate"];
        _agendaText = dict[@"agenda"];
    }
    return self;
}

- (NSString *)startDateText {
    NSString *stringDate = [[[self class] dateFormatter] stringFromDate:self.startDate];
    NSString *firstDateString = [stringDate substringWithRange:NSMakeRange(0, 1)];
    if ([firstDateString isEqualToString:@"0"]) {
        stringDate = [stringDate substringWithRange:NSMakeRange(1, [stringDate length] - 1)];
    }
    return stringDate;
}

- (NSString *)durationText {
    NSDateComponents *differenceDate = [self.endDate dateBySubstractingDate:self.startDate];
    NSString *text = nil;
    if ([differenceDate hour] > 0) {
        text = [NSString stringWithFormat:@"%dh", (int)[differenceDate hour]];
    }
    if ([differenceDate minute] > 0) {
        text = [NSString stringWithFormat:@"%@%dm", (text ? [NSString stringWithFormat:@"%@ ", text] : @""), (int)[differenceDate minute]];
    }
    if (!text) {
        NSLog(@"");
    }
    return text;
}

- (NSString *)dateString {
    return [self.startDate dateStringWithDayMonthYear];
}

- (BOOL)isEqual:(ASCalendarAgenda *)otherCalendarAgenda {
    if (self == otherCalendarAgenda) {
        return YES;
    }
    if (!otherCalendarAgenda || ![otherCalendarAgenda isKindOfClass:[ASCalendarAgenda class]]) {
        return NO;
    }
    if ([self.dateString isEqualToString:otherCalendarAgenda.dateString] && [self.agendaText isEqualToString:otherCalendarAgenda.agendaText] && [self.durationText isEqualToString:otherCalendarAgenda.durationText]) {
        return YES;
    }
    return NO;
}

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"hh:mm a";
    });
    return dateFormatter;
}

@end
