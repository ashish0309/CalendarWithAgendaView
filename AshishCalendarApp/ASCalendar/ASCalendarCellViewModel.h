//
//  ASCalendarCellViewModel.h
//  AshishCalendarApp
//
//  Created by Ashish Singh on 2/3/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ASCalendarView.h"

@interface ASCalendarCellViewModel : NSObject
- (instancetype)initWithCalendarDateSource:(id<ASCalendarDateOperationDataSource>)calendarDataSource indexPath:(NSIndexPath *)indexPath;
@property (nonatomic, readonly) UIColor *textColor;
@property (nonatomic, readonly) NSString *dayText;
@property (nonatomic, assign) BOOL cellSelected;
@property (nonatomic, assign) BOOL indicatorViewHidden;
@property (nonatomic, assign) BOOL selectedItem;
@property (nonatomic, assign) BOOL userInteraction;
@end
