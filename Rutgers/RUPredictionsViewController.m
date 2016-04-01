//
//  RUPredictionsViewController.m
//  Rutgers
//
//  Created by Kyle Bailey on 4/24/14.
//  Copyright (c) 2014 Rutgers. All rights reserved.
//

#import "RUPredictionsViewController.h"
#import "RUPredictionsDataSource.h"
#import "RUBusRoute.h"
#import "RUBusMultiStop.h"
#import "TableViewController_Private.h"
#import <MSWeakTimer.h>
#import "NSURL+RUAdditions.h"
#import "RUBusDataLoadingManager.h"

#define PREDICTION_TIMER_INTERVAL 30.0

@interface RUPredictionsViewController ()
@property (nonatomic) MSWeakTimer *timer;
@property (nonatomic) id item;
@property (nonatomic) id serializedItem;
@property (strong, nonatomic) RUBusSubscribeToNotificationViewController *subscribeToNotificationViewController;
@end

@implementation RUPredictionsViewController
-(instancetype)initWithItem:(id)item{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.item = item;
        self.title = [self.item title];
    }
    return self;
}

-(instancetype)initWithSerializedItem:(id)item title:(NSString *)title{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.item = item;
        self.title = title;
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    //Set the estimated row height to help the tableview
    self.tableView.rowHeight = [self.item isKindOfClass:[RUBusRoute class]] ? 70.0 : 96.0;
    self.tableView.estimatedRowHeight = self.tableView.rowHeight;
    
    //All of the content loading happens in the data source
    self.dataSource = [[RUPredictionsDataSource alloc] initWithItem:self.item];
    
    self.pullsToRefresh = YES;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    RUPredictionsHeaderRow *clickedItem = [self.dataSource itemAtIndexPath:indexPath];
    RUBusPrediction *predictions = clickedItem.predictions;
    
    NSString *busStopName = clickedItem.title;
    
    NSArray *busStopArrivals = predictions.arrivals;
    
    for(RUBusArrival *arrival in busStopArrivals) {
        NSLog(@"%ld\t%\ld", arrival.minutes, arrival.seconds);
    }
    
    self.subscribeToNotificationViewController = [[RUBusSubscribeToNotificationViewController alloc] initWithNibName:@"RUBusSubscribeToNotificationViewController" bundle:[NSBundle mainBundle] busStopName:busStopName busName:@"A" arrivalTimes:busStopArrivals];
    self.subscribeToNotificationViewController.modalTransitionStyle = UIModalPresentationPopover;
    
    [self presentViewController:self.subscribeToNotificationViewController animated:YES completion:nil];
    
    NSLog(@"VIEW SELECTED\t%@", [self.dataSource itemAtIndexPath:indexPath]);
}

-(NSURL *)sharingURL{
    NSString *type;
    if ([self.item isKindOfClass:[RUBusRoute class]]) {
        type = @"route";
    } else if ([self.item isKindOfClass:[RUBusMultiStop class]]) {
        type = @"stop";
    }
    if (!type) return nil;
    return [NSURL rutgersUrlWithPathComponents:@[@"bus", type, [self.item title]]];
}

//This causes an update timer to start upon the Predictions View controller appearing
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.timer = [MSWeakTimer scheduledTimerWithTimeInterval:PREDICTION_TIMER_INTERVAL target:self.dataSource selector:@selector(setNeedsLoadContent) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
}

//And stops the timer
-(void)viewWillDisappear:(BOOL)animated{
    [self.timer invalidate];
    [super viewWillDisappear:animated];
}

-(UITableViewRowAnimation)rowAnimationForOperationDirection:(DataSourceAnimationDirection)direction{
    switch (direction) {
        case DataSourceAnimationDirectionNone:
            //This causes the inserted and removed sections to slide on and off the screen
            return UITableViewRowAnimationAutomatic;
            break;
        default:
            return [super rowAnimationForOperationDirection:direction];
            break;
    }
}

@end
