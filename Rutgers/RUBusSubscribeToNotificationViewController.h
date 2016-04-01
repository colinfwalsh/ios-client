//
//  RUBusSubscribeToNotificationViewController.h
//  Rutgers
//
//  Created by Open Systems Solutions on 4/1/16.
//  Copyright © 2016 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RUBusArrival.h"

@interface RUBusSubscribeToNotificationViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil busStopName:(NSString*)busStopName busName:(NSString*)busName arrivalTimes:(NSArray*)arrivalTimes;

@end
