//
//  RUReaderGameViewController.m
//  Rutgers
//
//  Created by scm on 7/15/16.
//  Copyright © 2016 Rutgers. All rights reserved.
//

#import "RUReaderGameViewController.h"
#import "RUReaderDataSource.h"

@interface RUReaderGameViewController()
@property (nonatomic) NSDictionary *channel;

@end

@implementation RUReaderGameViewController

@dynamic channel;

+ (NSString *)channelHandle
{
    return @"Athletics";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // CHange the data Source
    NSLog(@"Game REader VIew Controller loaded");
    NSString * url = [NSString stringWithFormat:@"sports/%@.json" , self.channel[@"data"]];
    
    self.dataSource = [[RUReaderDataSource alloc] initWithUrl:url];
    
    
}

+(void)load
{
    [[RUChannelManager sharedInstance] registerClass:[self class]];
}

@end