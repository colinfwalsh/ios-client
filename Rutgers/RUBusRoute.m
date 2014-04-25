//
//  RUBusRoute.m
//  Rutgers
//
//  Created by Kyle Bailey on 4/22/14.
//  Copyright (c) 2014 Rutgers. All rights reserved.
//

#import "RUBusRoute.h"

@implementation RUBusRoute
-(id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        self.title = dictionary[@"title"];
        self.stops = dictionary[@"stops"];
     
    }
    return self;
}
-(NSArray *)stops{
    if (!_stops) {
        _stops = [NSArray array];
    }
    return _stops;
}
-(NSArray *)activeStops{
    return [self.stops filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"active = YES"]];
}
@end