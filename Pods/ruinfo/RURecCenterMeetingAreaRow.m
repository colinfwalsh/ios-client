//
//  RURecCenterMeetingAreaCell.m
//  Rutgers
//
//  Created by Kyle Bailey on 5/21/14.
//  Copyright (c) 2014 Rutgers. All rights reserved.
//

#import "RURecCenterMeetingAreaRow.h"
#import "RURecCenterMeetingAreaTableViewCell.h"
@interface RURecCenterMeetingAreaRow ()
@property NSDictionary *dates;
@property NSString *area;
@end
@implementation RURecCenterMeetingAreaRow
-(instancetype)initWithArea:(NSString *)area dates:(NSDictionary *)dates{
    self = [super initWithIdentifier:@"RURecCenterMeetingAreaTableViewCell"];
    if (self) {
        self.area = area;
        self.dates = dates;
    }
    return self;
}
-(UITableViewCell *)makeReuseableCell{
    return [[RURecCenterMeetingAreaTableViewCell alloc] init];
}
-(void)setupCell:(RURecCenterMeetingAreaTableViewCell *)cell{
    cell.areaLabel.text = self.area;
    cell.dateLabel.text = self.dates[self.date];
}
@end
