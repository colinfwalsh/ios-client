//
//  EZTableViewMapsSection.h
//  Rutgers
//
//  Created by Kyle Bailey on 6/12/14.
//  Copyright (c) 2014 Rutgers. All rights reserved.
//

#import "DataSource.h"
#import <MapKit/MapKit.h>

@class RUPlace;

@interface MiniMapDataSource : DataSource
-(instancetype)initWithPlace:(RUPlace *)place NS_DESIGNATED_INITIALIZER;
@end
