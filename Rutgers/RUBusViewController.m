//
//  RUNewBusViewController.m
//  Rutgers
//
//  Created by Kyle Bailey on 7/22/14.
//  Copyright (c) 2014 Rutgers. All rights reserved.
//

/*
            Set up the initial Table View Contoller On Tapping the Bus Icon
            On tapping Cell Segues into predictions page
 
        To Do :     
            Convert this into a map
 
 */

#import "RUBusViewController.h"
#import "RUBusDataSource.h"
#import "BusSearchDataSource.h"
#import "RUBusDataLoadingManager.h"
#import "RUPredictionsViewController.h"
#import "TableViewController_Private.h"
#import "RUChannelManager.h"
#import "RURootController.h"
#import <SWRevealViewController.h>
#import "RUAnalyticsManager.h"


@interface RUBusViewController () <UIGestureRecognizerDelegate>

@end

@implementation RUBusViewController
+(NSString *)channelHandle
{
    return @"bus";
}

+(void)load
{
    [[RUChannelManager sharedInstance] registerClass:[self class]];
}


/*
    Descript :
    Since each of the View Controller are Handled by a Generic Channel , this functions allows us to set up specific Configurations for a particular View Controller...
 */
+(instancetype)channelWithConfiguration:(NSDictionary *)channel
{
    return [[self alloc] initWithStyle:UITableViewStylePlain];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // All content is located in the data sources
    self.dataSource = [[RUBusDataSource alloc] init];
    self.searchDataSource = [[BusSearchDataSource alloc] init];
    self.searchBar.placeholder = @"Search All Routes and Stops";
    
   // create require failure relationship between the swipe gesture and the pan gesture which will open the slide menu
    self.leftSwipe.delegate = self;
    self.rightSwipe.delegate = self;
    
 //  [NSException raise:@"Invalid foo value" format:@"foo of "];
    
 
    if(DEV)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(36 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0) , ^
        {
          /*  @throw [NSException exceptionWithName:NSGenericException
                                           reason:@"Test uncaught exception handling"
                                         userInfo:nil];     
           */
            [NSException raise:NSInternalInconsistencyException format:@"Error Testing"];
        });
    }
  
}
/*
    //Execute the pan gesture to open the drawer if the swip gesture has failed
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    BOOL result = NO ;
   
    if(  (gestureRecognizer == self.leftSwipe || gestureRecognizer == self.rightSwipe) && [otherGestureRecognizer class] == [SWRevealViewControllerPanGestureRecognizer class])
    {
        result = YES;
    }
    return result;
}
*/



//This causes an update timer to start upon the Bus View controller appearing
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(RUBusDataSource *)self.dataSource startUpdates];
}

//And stops the timer
/*
    View is being update / but with what <q>
 */
-(void)viewWillDisappear:(BOOL)animated{
    [(RUBusDataSource *)self.dataSource stopUpdates];
    [super viewWillDisappear:animated];
}

//This is the action send when tapping on a cell, this opens up the predictions screen
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    id item = [[self dataSourceForTableView:tableView] itemAtIndexPath:indexPath];
    // Create a view using the item. Ie. Present the view with the bu stops and their timiings
    if (GRANULAR_ANALYTICS_NEEDED)
    {
        [[RUAnalyticsManager sharedManager] queueClassStrForExceptReporting:NSStringFromClass( [item class])];
    }
    [self.navigationController pushViewController:[[RUPredictionsViewController alloc] initWithItem:item] animated:YES]; // move to the next view controller
}

/*
    Descript : 
        Part of the Channel ? 
 
 
 */
+(NSArray *)viewControllersWithPathComponents:(NSArray *)pathComponents destinationTitle:(NSString *)destinationTitle {
    RUPredictionsViewController *viewController = [[RUPredictionsViewController alloc] initWithSerializedItem:pathComponents title:destinationTitle];
    return @[viewController];
}

@end
