//
//  ASAgendaView.m
//  AshishCalendarApp
//
//  Created by Ashish Singh on 1/27/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

#import "ASAgendaView.h"
#import "NSDate+AS_DateHelpers.h"
#import "UIColor+AS.h"
#import "ASAgendaTableViewCell.h"

static NSString * const kASAgendaSectionHeaderViewIdentifier = @"kASAgendaSectionHeaderViewIdentifier";
static CGFloat const kASTableViewHeaderHeight = 25.f;

@interface ASAgendaView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, assign) BOOL dontCallDelegateMethods;
@property (nonatomic, strong) UIView *topSeparator;
@property (nonatomic, strong) NSDate *lastDelegateCallDate;
@end
@implementation ASAgendaView

- (instancetype)init {
    self = [super init];
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
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    [self.tableView registerClass:[ASAgendaTableViewCell class] forCellReuseIdentifier:kASAgendaTableViewCellIdentifier];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kASAgendaSectionHeaderViewIdentifier];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kASNoEventsCellIdentifier];
    self.startDate      = [NSDate defaultStartDate];
    self.selectedDate   = [NSDate date];
    self.endDate        = [NSDate defaultEndDate];
    //_dontCallDelegateMethods = YES;
    
    _topSeparator = [UIView new];
    _topSeparator.backgroundColor = [UIColor as_mediumLightGrayColor];
    [self addSubview:_topSeparator];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
    self.topSeparator.frame = CGRectMake(0, 0, CGRectGetMaxX(self.bounds), 1);
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource numberOfRowsForSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ASCalendarAgenda *agenda = [self.dataSource agendaForIndexPath:indexPath];
    if (agenda) {
        ASAgendaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kASAgendaTableViewCellIdentifier forIndexPath:indexPath];
        [cell congigureCellWithAgenda:agenda];
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kASNoEventsCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = @"No Events";
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kASAgendaSectionHeaderViewIdentifier];
    UIView *backgroundView = [[UIView alloc] initWithFrame:headerView.bounds];
    backgroundView.backgroundColor = [UIColor as_lightGrayColor];
    headerView.backgroundView = backgroundView;
    NSDate *date = [self.dataSource dateForSection:section];
    headerView.textLabel.text = [date weekdayDayMonth];
    headerView.textLabel.textColor = [date isEqualToDate:[NSDate date]] ? [UIColor redColor] : [UIColor grayColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ASCalendarAgenda *agenda = [self.dataSource agendaForIndexPath:indexPath];
    return agenda ? 55.f : 40.f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ASCalendarAgenda *agenda = [self.dataSource agendaForIndexPath:indexPath];
    return agenda ? 55.f : 40.f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    //Required since changing the font in viewForHeaderInSection doesn't change the font for UITableViewHeaderFooterView class
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.textLabel.font = [UIFont systemFontOfSize:14.f weight:UIFontWeightMedium];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kASTableViewHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return kASTableViewHeaderHeight;
}

#pragma mark ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!scrollView.isDragging && !scrollView.isDecelerating) {
        return;
    }
    //NSLog(@"Scrolling");
    [self tellDelegateOfScroll];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    //Get at least 2 visible rows for the targetcontentoffset
    NSArray *visiblePaths = [self.tableView indexPathsForRowsInRect:CGRectMake(0, targetContentOffset->y, 100, 120)];
    NSIndexPath *firstPath = visiblePaths[0];
    NSIndexPath *secondPath = visiblePaths[1];
    CGRect firstRowRect = [self.tableView rectForRowAtIndexPath:firstPath];
    //scroll to most visible cell for the targetcontentoffset
    CGFloat y = (firstRowRect.origin.y > self.tableView.contentOffset.y ? firstRowRect.origin.y : [self.tableView rectForRowAtIndexPath:secondPath].origin.y);
    targetContentOffset->y = y - kASTableViewHeaderHeight;
}

//helper methods
- (CGRect)frameForHeaderInSection:(NSInteger)section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    CGRect firstItemFrame = cell.frame;
    CGFloat headerHeight = 20.0f;
    return CGRectOffset(firstItemFrame, 0, -headerHeight);
}

- (void)tellDelegateOfScroll {
    //assuming indexpathvisiblerows returns the rows in sequence from top section to bottom section
    NSInteger topSection = [[self.tableView indexPathsForVisibleRows][0] section];
    if ([self.delegate respondsToSelector:@selector(agendaView:didScrollToDate:)]) {
        NSDate *date = [self.dataSource dateForSection:topSection];
        //dont call delegate method twice for same scrolled date section
        if ([date isEqualToDate:self.lastDelegateCallDate]) {
            return;
        }
        [self.delegate agendaView:self didScrollToDate:date];
        self.lastDelegateCallDate = date;
    }
}

- (void)scrollToSectionHeader:(NSInteger)section animated:(BOOL)animated {
    CGRect topHeaderFrame = [self frameForHeaderInSection:section];
    CGPoint topOfHeader = CGPointMake(0, topHeaderFrame.origin.y - self.tableView.contentInset.top);
    [self.tableView setContentOffset:topOfHeader animated:animated];
}

//interaction with external controllers
- (void)scrollAgendaViewToDate:(NSDate *)date animated:(BOOL)animated {
    NSIndexPath *indexPath = [self.dataSource indexPathForDate:date];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:animated];
}

@end
