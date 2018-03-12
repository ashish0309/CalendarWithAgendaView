//
//  ASCalendarView.h
//  AshishCalendarApp
//
//  Created by Ashish Singh on 1/26/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ASCalendarView;

@protocol ASCalendarViewDelegate <NSObject>
@optional
- (void)calendarView:(ASCalendarView *)calendarView didSelectDate:(NSDate *)date;
- (BOOL)calendarView:(ASCalendarView *)calendarView shouldSelectDate:(NSDate *)date;
- (BOOL)calendarView:(ASCalendarView *)calendarView shouldShowIndicatorForDate:(NSDate *)date;
- (void)calendarView:(ASCalendarView *)calendarView scrolledToSectionOfDifferentNumberOfRows:(NSInteger)rows;
@end

@protocol ASCalendarDateOperationDataSource <NSObject>
- (NSDate *)dateAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)monthForSection:(NSInteger)section;
- (BOOL)shouldShowIndicatorForDate:(NSDate *)date;
@property (nonatomic, strong) NSDate  *selectedDate;
@end

@interface ASCalendarView : UIView
@property (nonatomic, strong) NSDate  *startDate;
@property (nonatomic, strong) NSDate  *endDate;
@property (nonatomic, strong) NSDate  *selectedDate;
@property (nonatomic, strong) UIColor *highlightColor;
@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, strong) UIColor *dateTextColor;
@property (nonatomic, weak) id<ASCalendarViewDelegate>delegate;
- (void)scrollCalendarToDate:(NSDate *)date animated:(BOOL)animated;
@end


