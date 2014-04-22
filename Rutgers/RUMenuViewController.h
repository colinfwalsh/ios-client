//
//  RUMenuViewController.h
//  Rutgers
//
//  Created by Russell Frank on 1/12/14.
//  Copyright (c) 2014 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JASidePanelController.h"
#import "RUInfoDelegate.h"
#import "RUNewsDelegate.h"
#import "RUBusDelegate.h"

@interface RUMenuViewController : UIViewController <RUInfoDelegate, RUNewsDelegate, RUBusDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) JASidePanelController * sidepanel;

@end
  