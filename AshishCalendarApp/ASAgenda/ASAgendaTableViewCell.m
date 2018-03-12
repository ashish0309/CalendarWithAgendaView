//
//  ASAgendaTableViewCell.m
//  AshishCalendarApp
//
//  Created by Ashish Singh on 1/30/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

#import "ASAgendaTableViewCell.h"
#import "UIColor+AS.h"
@interface ASAgendaTableViewCell()
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *meetingAgenda;
@property (nonatomic, strong) UIImageView *agendaTypeImageView;
@property (nonatomic, strong) UILabel *hourLabel;
@end
@implementation ASAgendaTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _timeLabel = [UILabel new];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.font = [UIFont systemFontOfSize:12.0f weight:UIFontWeightRegular];
    _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _timeLabel.text = @"12.00 PM ";
    [self.contentView addSubview:_timeLabel];
    //_timeLabel.backgroundColor = [UIColor magentaColor];

    _hourLabel = [UILabel new];
    _hourLabel.textAlignment = NSTextAlignmentLeft;
    _hourLabel.font = [UIFont systemFontOfSize:12.0f weight:UIFontWeightRegular];
    _hourLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _hourLabel.text = @"1 hour";
    _hourLabel.textColor = [UIColor as_darkGrayColor];
    [self.contentView addSubview:_hourLabel];
    
    _agendaTypeImageView = [UIImageView new];
    _agendaTypeImageView.backgroundColor = [UIColor redColor];
    _agendaTypeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_agendaTypeImageView];
    
    _meetingAgenda = [UILabel new];
    _meetingAgenda.textAlignment = NSTextAlignmentLeft;
    _meetingAgenda.font = [UIFont systemFontOfSize:14.0f weight:UIFontWeightRegular];
    _meetingAgenda.translatesAutoresizingMaskIntoConstraints = NO;
    _meetingAgenda.numberOfLines = 2;
    _meetingAgenda.text = @"A layout where the stack when the tiger comes then you should not be afraid of anything";
    //_meetingAgenda.backgroundColor = [UIColor magentaColor];
    [self.contentView addSubview:_meetingAgenda];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    [self.agendaTypeImageView.heightAnchor constraintEqualToConstant:8.0f].active = YES;
    [self.agendaTypeImageView.widthAnchor constraintEqualToConstant:8.0f].active = YES;
    self.agendaTypeImageView.layer.cornerRadius = 5.0f;

    [self.timeLabel sizeToFit];
    [self.timeLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:14.0f].active = YES;
    [self.timeLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:15.0f].active = YES;
    [self.timeLabel.widthAnchor constraintEqualToConstant:self.timeLabel.bounds.size.width].active = YES;
    //[self.timeLabel setContentHuggingPriority:48 forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.agendaTypeImageView.leadingAnchor constraintEqualToAnchor:self.timeLabel.trailingAnchor constant:14.0f].active = YES;
    [self.agendaTypeImageView.centerYAnchor constraintEqualToAnchor:self.timeLabel.centerYAnchor constant:0].active = YES;
    
    [self.meetingAgenda.leadingAnchor constraintEqualToAnchor:self.agendaTypeImageView.trailingAnchor constant:14.0f].active = YES;
    [self.meetingAgenda.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-15.0f].active = YES;
    [self.meetingAgenda.topAnchor constraintEqualToAnchor:self.timeLabel.topAnchor constant:-2.f].active = YES;
    
    [self.hourLabel.topAnchor constraintEqualToAnchor:self.timeLabel.bottomAnchor constant:3.f].active = YES;
    [self.hourLabel.leadingAnchor constraintEqualToAnchor:self.timeLabel.leadingAnchor constant:0].active = YES;
}

- (void)congigureCellWithAgenda:(ASCalendarAgenda *)agendaModel {
    self.hourLabel.text = agendaModel.durationText;
    self.timeLabel.text = agendaModel.startDateText;
    self.meetingAgenda.text = agendaModel.agendaText;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
