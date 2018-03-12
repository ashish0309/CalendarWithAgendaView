//
//  ASCalendarFooterCollectionReusableView.m
//  AshishCalendarApp
//
//  Created by Ashish Singh on 1/29/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

#import "ASCalendarFooterCollectionReusableView.h"
#import "UIColor+AS.h"
@implementation ASCalendarFooterCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor as_mediumLightGrayColor];
    }
    return self;
}

@end
