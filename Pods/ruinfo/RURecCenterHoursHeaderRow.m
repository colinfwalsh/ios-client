//
//  RURecCenterHoursHeader.m
//  Rutgers
//
//  Created by Kyle Bailey on 5/21/14.
//  Copyright (c) 2014 Rutgers. All rights reserved.
//

#import "RURecCenterHoursHeaderRow.h"
#import "RURecCenterHoursHeaderTableViewCell.h"

@implementation RURecCenterHoursHeaderRow
- (instancetype)init
{
    self = [super initWithIdentifier:@"RURecCenterHoursHeaderTableViewCell"];
    if (self) {
        self.leftButtonEnabled = YES;
        self.rightButtonEnabled = YES;
    }
    return self;
}
-(void)setupCell:(RURecCenterHoursHeaderTableViewCell *)cell{
    cell.dateLabel.text = self.date;
    cell.leftButton.enabled = self.leftButtonEnabled;
    cell.rightButton.enabled = self.rightButtonEnabled;
}
@end
