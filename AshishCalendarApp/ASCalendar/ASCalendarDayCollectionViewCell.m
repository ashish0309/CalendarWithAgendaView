//
//  ASCalendarDayCollectionViewCell.m
//  AshishCalendarApp
//
//  Created by Ashish Singh on 1/27/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

#import "ASCalendarDayCollectionViewCell.h"
#import "UIColor+AS.h"
@interface ASCalendarDayCollectionViewCell()
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UIView *bottomSeprator;
@property (nonatomic, strong) UIView *highlightView;
@end
@implementation ASCalendarDayCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.highlightView = [UIView new];
    self.highlightView.hidden = YES;
    self.highlightView.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:self.highlightView];
    self.indicatorView = [UIView new];
    self.indicatorView.backgroundColor = [UIColor as_mediumLightGrayColor];
    self.indicatorView.hidden = YES;
    [self.contentView addSubview:self.indicatorView];
    [self.contentView addSubview:self.dayLabel];
    self.contentView.backgroundColor = [UIColor as_lightGrayColor];
    self.dayLabel.backgroundColor = [UIColor clearColor];
    //self.dayLabel.backgroundColor = [UIColor clearColor];
    self.bottomSeprator = [UIView new];
    self.bottomSeprator.backgroundColor = [UIColor as_mediumLightGrayColor];
    [self.contentView addSubview:self.bottomSeprator];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.contentView.bounds.size;
    self.bottomSeprator.frame = CGRectMake(0, 0, CGRectGetMaxX(self.bounds), 1);
    CGFloat indicatorInset = 5.0f;
    CGRect indicatorFrame = CGRectMake((size.width - indicatorInset)/2.0f, 0, indicatorInset, indicatorInset);
    indicatorFrame.origin.y = CGRectGetMaxY(self.contentView.bounds) - 8.f - indicatorInset;
    self.indicatorView.frame = indicatorFrame;
    self.indicatorView.layer.cornerRadius = indicatorFrame.size.height / 2.0f;
    CGFloat highlightViewHeight = CGRectGetMinY(indicatorFrame) - 6.0f;
    self.highlightView.frame = CGRectMake((size.width - highlightViewHeight)/2.0f, 4.0f, highlightViewHeight, highlightViewHeight);
    self.highlightView.layer.cornerRadius = self.highlightView.frame.size.height / 2.0f;
    self.dayLabel.frame = self.highlightView.frame;
}

- (void)configureCellWith:(ASCalendarCellViewModel *)viewModel {
    //self.dayLabel.textColor = viewModel.textColor;
    self.userInteractionEnabled = viewModel.userInteraction;
    self.dayLabel.text = viewModel.dayText;
    self.indicatorView.hidden = viewModel.indicatorViewHidden;
    self.selected = viewModel.selectedItem;
    self.textColor = viewModel.textColor;
}

- (void)setDayText:(NSString *)text{
    self.dayLabel.text = text;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.dayLabel.textColor = textColor;
    if ([textColor isEqual:[UIColor redColor]]) {
        self.highlightView.backgroundColor = textColor;
    }
    else {
        self.highlightView.backgroundColor = [UIColor blueColor];
    }
}

- (UILabel *)dayLabel {
    if (!_dayLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentCenter;
        //label.adjustsFontSizeToFitWidth = YES;
        label.font = [UIFont systemFontOfSize:18.0f];
        label.textColor = [UIColor blackColor];
        self.dayLabel = label;
    }
    return _dayLabel;
}

- (void)setSelected:(BOOL)selected {
    self.highlightView.hidden = !selected;
    //self.indicatorView.hidden = NO;
    self.dayLabel.textColor = selected ? [UIColor whiteColor] : self.textColor;
}

@end
