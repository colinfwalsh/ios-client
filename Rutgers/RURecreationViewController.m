//
//  recreation.m
//  Rutgers
//
//  Created by Kyle Bailey on 5/19/14.
//  Copyright (c) 2014 Rutgers. All rights reserved.
//

#import "RURecreationViewController.h"
#import "RURecCenterViewController.h"
#import "RURecreationDataSource.h"
#import "DataTuple.h"
#import "RUChannelManager.h"
#import "RUAnalyticsManager.h"

@interface RURecreationViewController ()
@property (nonatomic) NSDictionary *recData;
@end

@implementation RURecreationViewController
+(NSString *)channelHandle
{
    return @"recreation";
}

+(void)load
{
    [[RUChannelManager sharedInstance] registerClass:[self class]];
}

+(instancetype)channelWithConfiguration:(NSDictionary *)channel
{
    return [[self alloc] initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.dataSource = [[RURecreationDataSource alloc] init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DataTuple *recCenter = [self.dataSource itemAtIndexPath:indexPath];
   
    RURecCenterViewController *recVC = [[RURecCenterViewController alloc] initWithTitle:recCenter.title recCenter:recCenter.object];
    
    if (GRANULAR_ANALYTICS_NEEDED)
    {
        [[RUAnalyticsManager sharedManager] queueClassStrForExceptReporting:NSStringFromClass( [recVC class])];
    }

    [self.navigationController pushViewController:recVC animated:YES];
}
@end
