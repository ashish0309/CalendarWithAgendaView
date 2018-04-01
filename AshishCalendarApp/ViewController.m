//
//  ViewController.m
//  AshishCalendarApp
//
//  Created by Ashish Singh on 1/26/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

#import "ViewController.h"
#import "ASCalendarView.h"
#import "ASAgendaView.h"
#import "ASCalendarWeekdayView.h"
#import "UIColor+AS.h"
#import "NSDate+AS_DateHelpers.h"
#import "ASCalendarAgenda.h"
#import "ASAgendaDataSource.h"
@interface ViewController ()<ASCalendarViewDelegate, ASAgendaViewDelegate>
@property (nonatomic, strong) ASCalendarView *calendarView;
@property (nonatomic, strong) ASAgendaView* agendaView;
@property (nonatomic, strong) UILabel *titleView;
@property (nonatomic, strong) ASAgendaDataSource *agendaDataSource;
@property (nonatomic, strong) NSLayoutConstraint *calendarViewHeightConstraint;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _calendarView = [ASCalendarView new];
    _calendarView.delegate = self;
    _calendarView.backgroundColor = [UIColor as_lightGrayColor];
    [self.view addSubview:_calendarView];

    self.navigationItem.titleView = self.titleView;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.barTintColor = [UIColor as_lightGrayColor];
    
    // Init calendar agendas with array consisting of dummy agenda dictionary.
    NSArray *calendarAgendasWithDict = [[self class] calendarAgendas];
    NSMutableArray <ASCalendarAgenda *>* calendarAgendasWithModel = [NSMutableArray new];
    for (NSDictionary *dict in calendarAgendasWithDict) {
        [calendarAgendasWithModel addObject:[[ASCalendarAgenda alloc] initWithDictionary:dict]];
    }
    // Group agendas based on agenda's start date's monthy, year, day string concatenation.
    NSMutableDictionary *groupedCalendarAgendas = [NSMutableDictionary new];
    for (ASCalendarAgenda *agenda in calendarAgendasWithModel) {
        NSString *key = agenda.dateString;
        NSMutableArray *agendas = [(groupedCalendarAgendas[key] ? : @[]) mutableCopy];
        [agendas addObject:agenda];
        groupedCalendarAgendas[agenda.dateString] = [agendas copy];
    }
    
    NSDictionary *groupedCalendarAgendasCopy = [groupedCalendarAgendas copy];
    // Init agenda Datasource.
    ASAgendaDataSource *agendasDataSource = [[ASAgendaDataSource alloc] initWithDictionary:groupedCalendarAgendasCopy startDate:[NSDate defaultStartDate] endDate:[NSDate defaultEndDate]];
    _agendaView = [ASAgendaView new];
    _agendaView.delegate = self;
    _agendaView.dataSource = agendasDataSource;
    [self.view addSubview:_agendaView];
    self.agendaDataSource = agendasDataSource;

    // Setup constraints
    _calendarView.translatesAutoresizingMaskIntoConstraints = NO;
    [_calendarView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [_calendarView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [_calendarView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    //[_calendarView.heightAnchor constraintEqualToConstant:80].active = YES;
    _calendarViewHeightConstraint = [_calendarView.heightAnchor constraintEqualToConstant:0];
    _calendarViewHeightConstraint.active = YES;
    _calendarViewHeightConstraint.constant = floorf(self.view.bounds.size.width / 7.0f) * 5.0f + WEEKDAY_VIEW_HEIGHT;
    
    _agendaView.translatesAutoresizingMaskIntoConstraints = NO;
    [_agendaView.topAnchor constraintEqualToAnchor:_calendarView.bottomAnchor].active = YES;
    [_agendaView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [_agendaView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [_agendaView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    
    self.titleView.text = [[NSDate date] monthYearString];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.calendarView scrollCalendarToDate:[NSDate date] animated:NO];
    //[self.agendaView scrollAgendaViewToDate:[NSDate defaultEndDate] animated:YES];
    [self.agendaView scrollAgendaViewToDate:[NSDate date] animated:NO];
}

- (UILabel *)titleView {
    if (!_titleView) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300.f, 40)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"Jan, 2017";
        label.font = [UIFont systemFontOfSize:15.0f weight:UIFontWeightMedium];
        _titleView = label;
    }
    return _titleView;
}

#pragma mark ASCalendarViewDelegate
- (void)calendarView:(ASCalendarView *)calendarView didSelectDate:(NSDate *)date{
    [self.agendaView scrollAgendaViewToDate:date animated:YES];
    self.titleView.text = [date monthYearString];
}

- (BOOL)calendarView:(ASCalendarView *)calendarView shouldShowIndicatorForDate:(NSDate *)date {
    return [self.agendaDataSource agendaPresentForDate:date];
}

- (void)calendarView:(ASCalendarView *)calendarView scrolledToSectionOfDifferentNumberOfRows:(NSInteger)rows {
    _calendarViewHeightConstraint.constant = floorf(self.view.bounds.size.width / 7.0f) * rows + WEEKDAY_VIEW_HEIGHT;
    [UIView animateWithDuration:0.3 animations:^ {
        [self.view layoutIfNeeded];
    }];
}

#pragma mark ASAgendaViewDelegate
- (void)agendaView:(ASAgendaView *)agendaView didScrollToDate:(NSDate *)date {
    [self.calendarView scrollCalendarToDate:date animated:YES];
    self.titleView.text = [date monthYearString];
}

// Create dummy calendar agendas to show in Agenda View
+ (NSArray *)calendarAgendas {
    NSMutableArray *agendasArray = [NSMutableArray new];
    for (NSInteger i = 0; i < 120; i++) {
        NSDate *today = [NSDate date];
        NSInteger day = random() % 120 - (random() % 120);
        NSDate *startDate = [today dateByAddingDays:day];
        NSNumber *minute = [[self class] minutes][rand() % 4];
        NSInteger hour = rand() % 24;
        startDate = [startDate assignHour:hour minutes:[minute integerValue]];
        
        minute = [[self class] minutes][rand() % 4];
        hour = rand() % (24 - hour < 4 ? : 3);
        if (hour == 0 && [minute integerValue] == 0) {
            hour = 1;
        }
        
        NSDate *endDate = [startDate dateByAddingHour:hour minute:[minute integerValue]];
        NSString *agenda = [[self class] agendas][rand() % 11];
        NSDictionary *dict = @{
                               @"startDate": startDate,
                               @"endDate": endDate,
                               @"agenda": agenda
                              };
        [agendasArray addObject:dict];
    }
    return agendasArray;
}

+ (NSArray *)minutes {
    return @[@0, @15, @30, @45, @60];
}

+ (NSArray *)agendas {
    return @[
             @"Interview with Phanis Google",
             @"Take a trip to heaven and come back again",
             @"Travesty is the thing that nobody thinks but when thinks then it will go away with wind",
             @"Go for a travel",
             @"Make an unknown",
             @"Remind me of the last thing that I forgot",
             @"Hike in the mountains with friends",
             @"Best Friend's Birthday, who is none other than Anuj",
             @"Special presentation on -- How to lead a life of humility and success",
             @"Meet with school friends in Joss",
             @"Friend's wedding shopping"
            ];
}

@end
