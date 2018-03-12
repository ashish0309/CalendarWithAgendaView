//
//  ASCalendarSectionHeaderView.m
//  AshishCalendarApp
//
//  Created by Ashish Singh on 1/30/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

#import "ASCalendarSectionHeaderView.h"

@interface ASCalendarSectionHeaderView()
@property (nonatomic, strong) UILabel *label;
@end
@implementation ASCalendarSectionHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _label = [UILabel new];
        _label.text = @"Jan, 2017";
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:18.0f weight:UIFontWeightSemibold];
        _label.backgroundColor = [UIColor clearColor];
        [self  addSubview:_label];
    }
    return self;
}

- (void)setHeaderText:(NSString *)text {
    self.label.text = text;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = self.bounds;
}


@end
