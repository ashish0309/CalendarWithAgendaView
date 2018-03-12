//
//  ASCalendarWeekdayView.m
//  AshishCalendarApp
//
//  Created by Ashish Singh on 1/29/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

#import "ASCalendarWeekdayView.h"
#import "NSDate+AS_DateHelpers.h"
#import "UIColor+AS.h"
@interface ASCalendarWeekdayView()
@property (nonatomic, strong) NSArray <UILabel *>*weekdaysLabel;
@property (nonatomic, strong) UIView *separatorView;
@end

@implementation ASCalendarWeekdayView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *weekdays = [NSDate shortWeekDays];
        NSMutableArray *labels = [NSMutableArray new];
        for (NSString *weekday in weekdays) {
            UILabel *dayLabel = [UILabel new];
            dayLabel.text = weekday;
            dayLabel.font = [UIFont systemFontOfSize:10.0f weight:UIFontWeightMedium];
            dayLabel.textAlignment = NSTextAlignmentCenter;
            [labels addObject:dayLabel];
            [self addSubview:dayLabel];
        }
        self.weekdaysLabel = [labels copy];
        _separatorView = [UIView new];
        _separatorView.backgroundColor = [UIColor as_darkGrayColor];
        //[self addSubview:_separatorView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat weekdayLabelWidth = self.bounds.size.width / 7.0f;
    [self.weekdaysLabel[0] sizeToFit];
    CGRect weekdayLabelFrame = CGRectMake(0, 0, weekdayLabelWidth, WEEKDAY_VIEW_HEIGHT - 6);
    for (UILabel *weekdayLabel in self.weekdaysLabel) {
        weekdayLabel.frame = weekdayLabelFrame;
        weekdayLabelFrame = CGRectOffset(weekdayLabelFrame, weekdayLabelWidth, 0);
    }
    self.separatorView.frame = CGRectMake(0, CGRectGetMaxY(self.bounds) - 1, self.bounds.size.width, 1.0f);
}

@end
