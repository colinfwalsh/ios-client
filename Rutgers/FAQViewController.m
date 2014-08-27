//
//  FAQViewController.m
//  Rutgers
//
//  Created by Kyle Bailey on 6/20/14.
//  Copyright (c) 2014 Rutgers. All rights reserved.
//

#import "FAQViewController.h"
#import "ExpandingTableViewSection.h"
#import "EZTableViewTextRow.h"
#import "FAQDataSource.h"

@interface FAQViewController ()
@property NSDictionary *channel;
@end

@implementation FAQViewController

+(id)channelWithConfiguration:(NSDictionary *)channel{
    return [[self alloc] initWithChannel:channel];
}

-(instancetype)initWithChannel:(NSDictionary *)channel{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.channel = channel;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = [[FAQDataSource alloc] initWithChannel:self.channel];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    id item = [self.dataSource itemAtIndexPath:indexPath];
    
    if ([item isKindOfClass:[NSDictionary class]]) {
        NSDictionary *channel = item[@"channel"];
        if (!channel) channel = item;
        
        UIViewController *vc = [[RUChannelManager sharedInstance] viewControllerForChannel:channel];
        vc.title = [item channelTitle];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (indexPath.row == 1);
}

-(BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    return (indexPath.row == 1 && action == @selector(copy:));
}

-(void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    if (action != @selector(copy:)) return;
    [UIPasteboard generalPasteboard].string = [[self.dataSource itemAtIndexPath:indexPath] description];
}

@end
