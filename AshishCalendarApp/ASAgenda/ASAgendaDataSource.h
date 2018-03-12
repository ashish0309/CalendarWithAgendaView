//
//  ASAgendaDataSource.h
//  AshishCalendarApp
//
//  Created by Ashish Singh on 1/31/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ASCalendarAgenda.h"
#import "ASAgendaView.h"

@interface ASAgendaDataSource : NSObject<ASAgendaViewDataSource>
- (instancetype)initWithDictionary:(NSDictionary <NSString *, NSArray <ASCalendarAgenda *>*>*)dict startDate:(NSDate *)sDate endDate:(NSDate *)eDate;
- (BOOL)agendaPresentForDate:(NSDate *)date;
@end
