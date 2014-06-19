//
//  RUSOCViewController.m
//  Rutgers
//
//  Created by Kyle Bailey on 5/29/14.
//  Copyright (c) 2014 Rutgers. All rights reserved.
//

#import "RUSOCViewController.h"
#import "RUSOCData.h"
#import "EZTableViewSection.h"
#import "EZTableViewRightDetailRow.h"
#import "ALTableViewRightDetailCell.h"
#import "RUSOCSubjectViewController.h"

@interface RUSOCViewController () <UISearchDisplayDelegate>
@property (nonatomic) UISearchDisplayController *searchController;
@end

@implementation RUSOCViewController
+(instancetype)componentForChannel:(NSDictionary *)channel{
    return [[RUSOCViewController alloc] initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self enableSearch];
    
    [[RUSOCData sharedInstance] getSubjectsForCurrentConfigurationWithCompletion:^(NSArray *subjects) {
        EZTableViewSection *section = [[EZTableViewSection alloc] initWithSectionTitle:@"Subjects"];
        for (NSDictionary *subject in subjects) {
            NSString *subjectTitle = [NSString stringWithFormat:@"%@ (%@)",[subject[@"description"] capitalizedString],subject[@"code"]];
            EZTableViewRightDetailRow *row = [[EZTableViewRightDetailRow alloc] initWithText:subjectTitle];
            row.didSelectRowBlock = ^{
                [self.navigationController pushViewController:[[RUSOCSubjectViewController alloc] initWithSubject:subjectTitle code:subject[@"code"]] animated:YES];
            };
            [section addRow:row];
        }
        [self addSection:section];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:self.sections.count-1] withRowAnimation:UITableViewRowAnimationFade];
    }];
    // Do any additional setup after loading the view.
}
-(void)enableSearch{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    self.searchController.searchResultsDelegate = self;
    self.searchController.searchResultsDataSource = self;
    self.searchController.delegate = self;
    
    self.tableView.tableHeaderView = searchBar;
    
}


@end
