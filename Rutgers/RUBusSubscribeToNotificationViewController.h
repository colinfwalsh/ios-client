//
//  RUBusSubscribeToNotificationViewController.h
//  Rutgers
//
//  Created by Open Systems Solutions on 3/31/16.
//  Copyright © 2016 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RUBusArrival.h"

@interface RUBusSubscribeToNotificationViewController : UIViewController

- (instancetype) initWithBusStopName:(NSString*)busStopName busArrivals:(NSArray*)busArrivals;

@end
