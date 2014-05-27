//
//  RURecCenterMeetingAreaCell.h
//  Rutgers
//
//  Created by Kyle Bailey on 5/21/14.
//  Copyright (c) 2014 Rutgers. All rights reserved.
//

#import "EZTableViewRow.h"

@interface RURecCenterMeetingAreaRow : EZTableViewRow
-(instancetype)initWithArea:(NSString *)area dates:(NSDictionary *)dates;
@property NSString *date;
@end
