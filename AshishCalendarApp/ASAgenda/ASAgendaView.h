//
//  ASAgendaView.h
//  AshishCalendarApp
//
//  Created by Ashish Singh on 1/27/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASCalendarAgenda.h"
@class ASAgendaView;

static NSString * const kASNoEventsCellIdentifier = @"kASNoEventsCellIdentifier";

@protocol ASAgendaViewDelegate <NSObject>
@optional
- (void)agendaView:(ASAgendaView *)agendaView didScrollToDate:(NSDate *)date;
@end

@protocol ASAgendaViewDataSource <NSObject>
- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsForSection:(NSInteger)section;
- (NSDate *)dateForSection:(NSInteger)section;
- (NSIndexPath *)indexPathForDate:(NSDate *)date;
- (ASCalendarAgenda *)agendaForIndexPath:(NSIndexPath *)indexPath;
@end

@interface ASAgendaView : UIView
@property (nonatomic, strong) NSDate  *startDate;
@property (nonatomic, strong) NSDate  *endDate;
@property (nonatomic, strong) NSDate  *selectedDate;
@property (nonatomic, strong) NSDictionary <NSString *, NSArray <ASCalendarAgenda *>*>*agendasDict;
@property (nonatomic, weak) id<ASAgendaViewDelegate>delegate;
@property (nonatomic, weak) id<ASAgendaViewDataSource>dataSource;
- (void)scrollAgendaViewToDate:(NSDate *)date animated:(BOOL)animated;
@end


