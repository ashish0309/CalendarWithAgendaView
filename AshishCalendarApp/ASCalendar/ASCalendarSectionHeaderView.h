//
//  ASCalendarSectionHeaderView.h
//  AshishCalendarApp
//
//  Created by Ashish Singh on 1/30/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

#import <UIKit/UIKit.h>


static NSString * const kASCalendarSectionHeaderViewIdentifier = @"kASCalendarSectionHeaderViewIdentifier";
@interface ASCalendarSectionHeaderView : UICollectionReusableView
- (void)setHeaderText:(NSString *)text;
@end
