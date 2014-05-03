//
//  RUPlacesData.m
//  Rutgers
//
//  Created by Kyle Bailey on 4/25/14.
//  Copyright (c) 2014 Rutgers. All rights reserved.
//

#import "RUPlacesData.h"
#import <AFNetworking.h>

NSString *const placesRecentPlacesKey = @"placesRecentPlacesKey";

@interface RUPlacesData ()
@property (nonatomic) AFHTTPSessionManager *sessionManager;
@property NSDictionary *places;
@property dispatch_group_t placesGroup;


@end

@implementation RUPlacesData

+(RUPlacesData *)sharedInstance{
    static RUPlacesData *placesData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        placesData = [[RUPlacesData alloc] init];
    });
    return placesData;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionManager = [AFHTTPSessionManager manager];
        self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{placesRecentPlacesKey: @[]}];

        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        self.placesGroup = group;
        
        [self getPlaces];
    }
    return self;
}

-(void)getPlaces{
    [self.sessionManager GET:@"https://rumobile.rutgers.edu/1/places.txt" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
           // NSArray *places = [responseObject[@"all"] allValues];
            self.places = responseObject[@"all"];
            dispatch_group_leave(self.placesGroup);
        } else {
            [self getPlaces];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self getPlaces];
    }];
}

-(void)queryPlacesWithString:(NSString *)query completion:(void (^)(NSArray *results))completionBlock{
    dispatch_group_notify(self.placesGroup, dispatch_get_main_queue(), ^{
        NSArray *results = [[self.places allValues] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title contains[cd] %@",query]];
        
        NSPredicate *beginsWithPredicate = [NSPredicate predicateWithFormat:@"title beginswith[cd] %@",query];
        results = [results sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            BOOL one = [beginsWithPredicate evaluateWithObject:obj1];
            BOOL two = [beginsWithPredicate evaluateWithObject:obj2];
            if (one && !two) {
                return NSOrderedAscending;
            } else if (!one && two) {
                return NSOrderedDescending;
            }
            return [obj1[@"title"] caseInsensitiveCompare:obj2[@"title"]];
        }];
        completionBlock(results);
    });
}

-(void)getRecentPlacesWithCompletion:(void (^)(NSArray *recents))completionBlock{
    dispatch_group_notify(self.placesGroup, dispatch_get_main_queue(), ^{
        NSArray *recentPlaces = [[NSUserDefaults standardUserDefaults] arrayForKey:placesRecentPlacesKey];
        completionBlock([self.places objectsForKeys:recentPlaces notFoundMarker:[NSNull null]]);
    });
}

-(void)userDidSelectPlace:(NSDictionary *)place{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recentPlaces = [[userDefaults arrayForKey:placesRecentPlacesKey] mutableCopy];
    NSString *ID = place[@"id"];
    if (![recentPlaces containsObject:ID]){
        [recentPlaces insertObject:ID atIndex:0];
    }
    while (recentPlaces.count > 7) {
        [recentPlaces removeLastObject];
    }
    
    [userDefaults setObject:recentPlaces forKey:placesRecentPlacesKey];
}

@end
