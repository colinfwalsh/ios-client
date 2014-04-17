//
//  RUReaderController.m
//  Rutgers
//
//  Created by Kyle Bailey on 4/16/14.
//  Copyright (c) 2014 Rutgers. All rights reserved.
//

#import "RUReaderController.h"
#import <AFNetworking.h>
#import "AFTBXMLResponseSerializer.h"
#import "TBXML.h"
#import <TSMiniWebBrowser.h>

@interface RUReaderController ()
@property (nonatomic) AFHTTPSessionManager *sessionManager;
@property (nonatomic) NSArray *items;
@end

@implementation RUReaderController
-(id)initWithStyle:(UITableViewStyle)style child:(NSDictionary *)child{
    self = [super initWithStyle:style];
    if (self) {
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        self.child = child;
    }
    return self;
}
-(NSString *)urlForChild:(NSDictionary *)child{
    return child[@"channel"][@"url"];
}
-(NSString *)titleForChild:(NSDictionary *)child{
    id title = child[@"title"];
    if ([title isKindOfClass:[NSString class]]) {
        return title = title;
    } else if ([title isKindOfClass:[NSDictionary class]]) {
        id subtitle = title[@"homeTitle"];
        if ([subtitle isKindOfClass:[NSString class]]) {
            return subtitle;
        }
    }
    return nil;
}
-(void)setChild:(NSDictionary *)child{
    _child = child;
    
    NSString *title = [self titleForChild:child];
    if (title) {
        self.title = title;
    }
    
    self.sessionManager = [[AFHTTPSessionManager alloc] init];//initWithBaseURL:[self urlForChild:child]];
    self.sessionManager.responseSerializer = [AFTBXMLResponseSerializer serializer];
    [self.sessionManager GET:[self urlForChild:child] parameters:0 success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[TBXML class]]) {
            [self parseResponse:responseObject];
        } else {
            [self requestFailed];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self requestFailed];
    }];
    
}

-(void)requestFailed{
    
}

-(void)parseResponse:(TBXML *)response{
    TBXMLElement *rss = response.rootXMLElement;
    TBXMLElement *channel = [TBXML childElementNamed:@"channel" parentElement:rss];
    
    NSMutableArray *items = [NSMutableArray array];
    [TBXML iterateElementsForQuery:@"item" fromElement:channel withBlock:^(TBXMLElement *element) {
        NSMutableDictionary *item = [NSMutableDictionary dictionary];
        TBXMLElement *childElement = element->firstChild;
        while (childElement) {
            NSString *name = [TBXML elementName:childElement];
            NSString *text = [TBXML textForElement:childElement];
            if (name && text) {
                item[name] = text;
            }
            childElement = childElement->nextSibling;
        }
        [items addObject:item];
    }];
    self.items = [items copy];

}
-(void)setItems:(NSArray *)items{
    _items = items;
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *item = self.items[indexPath.row];
    cell.textLabel.text = item[@"title"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *item = self.items[indexPath.row];
    NSString *link = item[@"link"];
    if (link) {
        TSMiniWebBrowser *webBrowser = [[TSMiniWebBrowser alloc] initWithUrl:[NSURL URLWithString:link]];
        [self.navigationController pushViewController:webBrowser animated:YES];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
