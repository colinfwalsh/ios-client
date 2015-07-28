//
//  TableViewController.h
//  Rutgers
//
//  Created by Kyle Bailey on 7/1/14.
//  Copyright (c) 2014 Kyle Bailey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"
#import "SearchDataSource.h"

@interface TableViewController : UITableViewController <UITableViewDelegate, DataSourceDelegate>
@property (nonatomic) DataSource *dataSource;
@property (nonatomic) DataSource<SearchDataSource> *searchDataSource;

@property (nonatomic, readonly, strong) UITableView *searchTableView;
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_REQUIRES_SUPER;

-(NSDictionary *)userInteractionForTableView:(UITableView *)tableView rowAtIndexPath:(NSIndexPath *)indexPath;
@end