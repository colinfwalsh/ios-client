//
//  RUBusViewController.h
//  Rutgers
//
//  Created by Kyle Bailey on 4/21/14.
//  Copyright (c) 2014 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RUComponentDelegate.h"

@interface RUBusViewController : UITableViewController
@property (nonatomic) id <RUComponentDelegate> delegate;
-(instancetype)initWithDelegate:(id<RUComponentDelegate>)delegate;
@end
