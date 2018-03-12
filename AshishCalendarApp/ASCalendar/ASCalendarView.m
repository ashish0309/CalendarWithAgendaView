//
//  ASCalendarView.m
//  AshishCalendarApp
//
//  Created by Ashish Singh on 1/26/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

#import "ASCalendarView.h"
#import "NSDate+AS_DateHelpers.h"
#import "ASCalendarDayCollectionViewCell.h"
#import "ASCalendarWeekdayView.h"
#import "UIColor+AS.h"
#import "ASCalendarFooterCollectionReusableView.h"
#import "ASCalendarSectionHeaderView.h"

#define DAYS_IN_WEEK 7
#define MONTHS_IN_YEAR 12

static CGFloat const kASCollectionViewItemSpacing    = 0.f;
static CGFloat const kASCollectionViewLineSpacing    = 0.f;
static CGFloat const kASCollectionViewHeaderSectionSpacing = 40.f;

@interface ASCalendarView() <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, ASCalendarDateOperationDataSource>
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout* flowLayout;
@property (nonatomic, strong) NSDate* currentDate;
@property (nonatomic, assign) NSInteger currentVisibleSection;
@property (nonatomic, assign) CGFloat startOffsetY;
@property (nonatomic, strong) ASCalendarWeekdayView *weekdayView;
@property (nonatomic, strong) UIView *separatorView;
@end
@implementation ASCalendarView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    //self.backgroundColor = [UIColor redColor];
    _weekdayView = [[ASCalendarWeekdayView alloc] initWithFrame:CGRectZero];
    [self addSubview:_weekdayView];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumInteritemSpacing  = kASCollectionViewItemSpacing;
    layout.minimumLineSpacing       = kASCollectionViewLineSpacing;
    self.flowLayout = layout;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor as_lightGrayColor];
    _collectionView.dataSource = self;
    _collectionView.delegate   = self;
    _collectionView.allowsMultipleSelection = NO;
    _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    //_collectionView.pagingEnabled = YES;
    [self addSubview:_collectionView];
    [_collectionView registerClass:[ASCalendarDayCollectionViewCell class]    forCellWithReuseIdentifier:kASCalendarDayCollectionViewCellIdentifier];
    [_collectionView registerClass:[ASCalendarFooterCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kASCalendarFooterReusableViewIdentifier];
    [_collectionView registerClass:[ASCalendarSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kASCalendarSectionHeaderViewIdentifier];
    
    _separatorView = [UIView new];
    _separatorView.backgroundColor = [UIColor as_darkGrayColor];
    [self addSubview:_separatorView];
    //Default Configuration
    _currentDate = [NSDate date];
    self.startDate      = [NSDate defaultStartDate];
    self.selectedDate   = _currentDate;
    self.endDate        = [NSDate defaultEndDate];
    self.highlightColor = [UIColor redColor];
    self.indicatorColor = [UIColor lightGrayColor];
    self.dateTextColor  = [UIColor blackColor];
    self.startOffsetY = CGFLOAT_MIN;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.weekdayView.frame = CGRectMake(0, 0, self.bounds.size.width, WEEKDAY_VIEW_HEIGHT);
    self.collectionView.frame = CGRectMake(0, WEEKDAY_VIEW_HEIGHT, self.bounds.size.width, self.bounds.size.height - WEEKDAY_VIEW_HEIGHT);
    self.separatorView.frame = CGRectMake(0, CGRectGetMaxY(self.weekdayView.frame), self.bounds.size.width, 1.0f);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.startDate numberOfMonthsTillDate:self.endDate] + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSDate *firstDayOfMonth = [self firstDayDateForSection:section];
    NSInteger month = [firstDayOfMonth month];
    NSInteger year  = [firstDayOfMonth year];
    NSInteger numberOfDaysInCurrentSectionMonth = [NSDate numberOfDaysInMonth:month forYear:year];
    NSInteger offsetDays = [self offsetDaysForSection:section];
    NSInteger pendingDaysForCurrentSection = [self pendingDaysForSection:section];
    return numberOfDaysInCurrentSectionMonth + offsetDays + pendingDaysForCurrentSection;
}

#pragma mark - UICollectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ASCalendarDayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kASCalendarDayCollectionViewCellIdentifier forIndexPath:indexPath];
    ASCalendarCellViewModel *viewModel = [[ASCalendarCellViewModel alloc] initWithCalendarDateSource:self indexPath:indexPath];
    [cell configureCellWith:viewModel];
    if (viewModel.selectedItem) {
        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    //Sometimes the cellForRowatIndexPath method is not called when scrollview scrolled by delegate method call
    //issue happens in rare cases
    ASCalendarCellViewModel *viewModel = [[ASCalendarCellViewModel alloc] initWithCalendarDateSource:self indexPath:indexPath];
    if (viewModel.selectedItem) {
        cell.selected = YES;
        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view;
    if (kind == UICollectionElementKindSectionFooter) {
        ASCalendarFooterCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kASCalendarFooterReusableViewIdentifier forIndexPath:indexPath];
        view = footerView;
    }
    else if (kind == UICollectionElementKindSectionHeader) {
        ASCalendarSectionHeaderView *sectionHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kASCalendarSectionHeaderViewIdentifier forIndexPath:indexPath];
        NSDate* date = [self firstDayDateForSection:indexPath.section];
        [sectionHeaderView setHeaderText:[date monthYearString]];
        view = sectionHeaderView;
    }
    return view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedDate = [self dateAtIndexPath:indexPath];
    if ([_delegate respondsToSelector:@selector(calendarView:didSelectDate:)]) {
        [_delegate calendarView:self didSelectDate:self.selectedDate];
    }
}

#pragma mark - UICollectionViewFlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellWidth = [self cellWidth];
    CGFloat cellHeight = cellWidth;
    return CGSizeMake(cellWidth, cellHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGFloat boundsWidth = collectionView.bounds.size.width;
    return CGSizeMake(boundsWidth, kASCollectionViewHeaderSectionSpacing);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(CGRectGetWidth(self.bounds), 0);
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGRect currentSectionFrame = [self frameForHeaderInSection:self.currentVisibleSection];
    CGFloat differenceOffset = targetContentOffset->y - currentSectionFrame.origin.y;
    if (ABS(differenceOffset) >= scrollView.bounds.size.height / 5.0f) {
        NSInteger section = velocity.y > 0  ? self.currentVisibleSection - 1 : self.currentVisibleSection + 1;
        section = self.currentVisibleSection;
        if (velocity.y > 0 || differenceOffset > 0) section++;
        if (velocity.y < 0 || differenceOffset < 0) section--;
        CGRect frame = [self frameForHeaderInSection:section];
        self.currentVisibleSection = section;
        targetContentOffset->y = frame.origin.y;
    }
    else {
        targetContentOffset->y = currentSectionFrame.origin.y;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //NSLog(@"%@", [NSNumber numberWithBool:scrollView.isDragging] );
    //self.startOffsetY = scrollView.isTracking ? scrollView.contentOffset.y : self.startOffsetY;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //self.startOffsetY = CGFLOAT_MIN;
}

//ColletionView DataSource Helpers
- (CGFloat)cellWidth {
    CGFloat boundsWidth = self.collectionView.bounds.size.width;
    return floor(boundsWidth / DAYS_IN_WEEK) - kASCollectionViewItemSpacing;
}

- (void)setCurrentVisibleSection:(NSInteger)currentVisibleSection {
    if (_currentVisibleSection != currentVisibleSection) {
        int pastSectionRows = (int)floor([self.collectionView numberOfItemsInSection:_currentVisibleSection] / 7.f);
        int sectionRows = (int)floor([self.collectionView numberOfItemsInSection:currentVisibleSection] / 7.f);
        if (pastSectionRows != sectionRows) {
            if ([self.delegate respondsToSelector:@selector(calendarView:scrolledToSectionOfDifferentNumberOfRows:)]) {
                [self.delegate calendarView:self scrolledToSectionOfDifferentNumberOfRows:sectionRows];
            }
        }
    }
    _currentVisibleSection = currentVisibleSection;
}

#pragma mark ASCalendarDateOperationDataSource
- (BOOL)shouldShowIndicatorForDate:(NSDate *)date {
    if ([self.delegate respondsToSelector:@selector(calendarView:shouldShowIndicatorForDate:)]) {
        return [self.delegate calendarView:self shouldShowIndicatorForDate:date];
    }
    return NO;
}

- (NSDate *)dateAtIndexPath:(NSIndexPath *)indexPath {
    NSDate* date = [self.startDate dateByAddingMonths:indexPath.section assignDays:indexPath.item + 1];
    NSInteger offset = [self offsetDaysForSection:indexPath.section];
    return [date dateByAddingDays:-offset];
}

- (NSInteger)monthForSection:(NSInteger)section {
    NSDate *firstDayOfMonth = [[self.startDate firstDayOfMonth] dateByAddingMonths:section];
    return [firstDayOfMonth month];
}

//Date Helpers
- (NSDate *)firstDayDateForSection:(NSInteger)section {
    return [[self.startDate firstDayOfMonth] dateByAddingMonths:section];
}

- (NSInteger)offsetDaysForSection:(NSInteger)section {
    NSDate *firstDayOfMonth = [self firstDayDateForSection:section];
    return [firstDayOfMonth weekday] - 1;
}

- (NSInteger)pendingDaysForSection:(NSInteger)section {
    NSDate *firstDayOfMonth = [self firstDayDateForSection:section];
    NSInteger weekday = [[firstDayOfMonth lastDayOfMonth] weekday];
    return DAYS_IN_WEEK - weekday;
}

- (NSIndexPath *)indexPathForDate:(NSDate *)date {
    NSIndexPath *indexPath = nil;
    if (date) {
        NSDate *firstDayOfCalendar = [_startDate firstDayOfMonth];
        NSInteger section = [firstDayOfCalendar numberOfMonthsTillDate:date];
        NSInteger dayOffset = [self offsetDaysForSection:section];
        NSInteger dayIndex = [date day] + dayOffset - 1;
        indexPath = [NSIndexPath indexPathForItem:dayIndex inSection:section];
    }
    return indexPath;
}

- (CGRect)frameForHeaderInSection:(NSInteger)section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:section];
    UICollectionViewLayoutAttributes* attributes = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
    CGRect firstItemFrame = attributes.frame;
    CGFloat headerHeight = 0.0f;
    return CGRectOffset(firstItemFrame, 0, -headerHeight);
}

  //UICollectionView interaction handlers
- (void)scrollToSectionHeader:(NSInteger)section animated:(BOOL)animated {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:section];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:animated];
    self.currentVisibleSection = section;
}

- (void)scrollCalendarToDate:(NSDate *)date animated:(BOOL)animated {
    NSIndexPath *indexPath = [self indexPathForDate:date];
    [self updatesToCellOnIndexPathSelection:indexPath];
    self.selectedDate = date;
    NSSet *visibleIndexPaths = [NSSet setWithArray:[self.collectionView indexPathsForVisibleItems]];
    NSDate* dateWithOffset = [self dateAtIndexPath:indexPath];
    NSInteger currentItemMonth = [self monthForSection:self.currentVisibleSection];
    if ((indexPath && ![visibleIndexPaths containsObject:indexPath]) || [dateWithOffset month] != currentItemMonth) {
        [self scrollToSectionHeader:indexPath.section animated:animated];
    }
}

- (void)updatesToCellOnIndexPathSelection:(NSIndexPath *)indexPath {
    NSIndexPath *pastSelectedIndexPath = [self indexPathForDate:self.selectedDate];
    if ([pastSelectedIndexPath isEqual:indexPath]) {
        return;
    }
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = YES;
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

@end
