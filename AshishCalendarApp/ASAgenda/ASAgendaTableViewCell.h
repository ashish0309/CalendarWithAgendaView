//
//  ASAgendaTableViewCell.h
//  AshishCalendarApp
//
//  Created by Ashish Singh on 1/30/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASCalendarAgenda.h"
static NSString * const kASAgendaTableViewCellIdentifier = @"kASAgendaTableViewCellIdentifier";

@interface ASAgendaTableViewCell : UITableViewCell
- (void)congigureCellWithAgenda:(ASCalendarAgenda *)agendaModel;
@end
