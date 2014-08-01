//
//  AllStopsDataSource.m
//  Rutgers
//
//  Created by Kyle Bailey on 7/22/14.
//  Copyright (c) 2014 Rutgers. All rights reserved.
//

#import "AllStopsDataSource.h"
#import "RUBusDataLoadingManager.h"
#import "RUBusData.h"

@interface AllStopsDataSource ()
@property NSString *agency;
@end

@implementation AllStopsDataSource
- (instancetype)initWithAgency:(NSString *)agency
{
    self = [super init];
    if (self) {
        self.agency = agency;
        self.title = [NSString stringWithFormat:@"All %@ Stops",TITLES[agency]];
    }
    return self;
}
-(void)loadContent{
    [self loadContentWithBlock:^(AAPLLoading *loading) {
        [[RUBusDataLoadingManager sharedInstance] fetchAllStopsForAgency:self.agency completion:^(NSArray *stops, NSError *error) {
            if (!error) {
                [loading updateWithContent:^(AllStopsDataSource *me) {
                    self.items = stops;
                }];
            } else {
                [loading doneWithError:^(AllStopsDataSource *me) {
                    
                }];
            }
        }];
    }];
}
@end