//
//  RUFoodViewController.h
//  Rutgers
//
//  Created by Kyle Bailey on 5/1/14.
//  Copyright (c) 2014 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RUComponentProtocol.h"

@interface RUFoodViewController : UITableViewController <RUComponentProtocol>
+(instancetype)component;
@end
