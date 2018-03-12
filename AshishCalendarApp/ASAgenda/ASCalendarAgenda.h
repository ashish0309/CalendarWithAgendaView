//
//  ASCalendarAgenda.h
//  AshishCalendarApp
//
//  Created by Ashish Singh on 1/30/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASCalendarAgenda : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dict;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) NSString *startDateText;
@property (nonatomic, strong) NSString *durationText;
@property (nonatomic, copy) NSString *agendaText;

@end
