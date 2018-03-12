//
//  ASCalendarDayCollectionViewCell.h
//  AshishCalendarApp
//
//  Created by Ashish Singh on 1/27/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASCalendarCellViewModel.h"


static NSString * const kASCalendarDayCollectionViewCellIdentifier = @"kASCalendarDayCollectionViewCellIdentifier";

@interface ASCalendarDayCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIView *indicatorView;
- (void)setDayText:(NSString *)text;
- (void)configureCellWith:(ASCalendarCellViewModel *)viewModel;
@end


