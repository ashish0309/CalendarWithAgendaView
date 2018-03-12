//
//  ASCalendarCellViewModel.m
//  AshishCalendarApp
//
//  Created by Ashish Singh on 2/3/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

#import "ASCalendarCellViewModel.h"
#import "NSDate+AS_DateHelpers.h"
#import "UIColor+AS.h"
@interface ASCalendarCellViewModel()

@end
@implementation ASCalendarCellViewModel
- (instancetype)initWithCalendarDateSource:(id<ASCalendarDateOperationDataSource>)calendarDataSource indexPath:(NSIndexPath *)indexPath{
    self = [super init];
    if (self) {
        NSDate* dateWithOffset = [calendarDataSource dateAtIndexPath:indexPath];
        NSInteger currentItemMonth = [calendarDataSource monthForSection:indexPath.section];
        NSDate *today = [NSDate date];
        BOOL showIndicator = NO;
        if ([dateWithOffset isEqualToDate:today]) {
            _textColor = [UIColor redColor];
        }
        else if ([dateWithOffset weekday] == 1 || [dateWithOffset weekday] == 7) {
            _textColor = [UIColor as_darkGrayColor];
        }
        if ([dateWithOffset month] == currentItemMonth) {
            _userInteraction = YES;
            NSInteger day = [dateWithOffset day];
            _dayText = [NSString stringWithFormat:@"%d", (int)day];
            if ([dateWithOffset isEqualToDate:calendarDataSource.selectedDate]) {
                _selectedItem = YES;
            }
            showIndicator = [calendarDataSource shouldShowIndicatorForDate:dateWithOffset];
        }
        else {
            _userInteraction = NO;
            _dayText = @"";
        }
        _indicatorViewHidden = !showIndicator;
    }
    return self;
}
@end


