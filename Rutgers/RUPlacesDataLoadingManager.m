//
//  RUPlacesData.m
//  Rutgers
//
//  Created by Kyle Bailey on 4/25/14.
//  Copyright (c) 2014 Rutgers. All rights reserved.
//

#import "RUPlacesDataLoadingManager.h"
#import <AFNetworking.h>
#import "RULocationManager.h"
#import "RUNetworkManager.h"
#import "RUPlace.h"

NSString *PlacesDataDidUpdateRecentPlacesKey = @"PlacesDataDidUpdateRecentPlacesKey";

static NSString *const PlacesRecentPlacesKey = @"PlacesRecentPlacesKey";

@interface RUPlacesDataLoadingManager ()
@property (nonatomic) NSDictionary *places;
@property dispatch_group_t placesGroup;

@end

@implementation RUPlacesDataLoadingManager

+(RUPlacesDataLoadingManager *)sharedInstance{
    static RUPlacesDataLoadingManager *placesData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        placesData = [[RUPlacesDataLoadingManager alloc] init];
    });
    return placesData;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{PlacesRecentPlacesKey: @[]}];
        self.placesGroup =  dispatch_group_create();
        dispatch_group_enter(self.placesGroup);
        [self getPlaces];
    }
    return self;
}

-(void)getPlaces{
    [[RUNetworkManager jsonSessionManager] GET:@"places.txt" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [self parsePlaces:responseObject];
            dispatch_group_leave(self.placesGroup);
        } else {
            [self getPlaces];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self getPlaces];
    }];
}
-(void)parsePlaces:(NSDictionary *)response{
    NSMutableDictionary *parsedPlaces = [NSMutableDictionary dictionary];
    
    [response[@"all"] enumerateKeysAndObjectsWithOptions:0 usingBlock:^(id key, id obj, BOOL *stop) {
        RUPlace *place = [[RUPlace alloc] initWithDictionary:obj];
        parsedPlaces[place.uniqueID] = place;
    }];

    self.places = parsedPlaces;
}

-(void)queryPlacesWithString:(NSString *)query completion:(void (^)(NSArray *results))completionBlock{
    dispatch_group_notify(self.placesGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
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
            return [[obj1 title] compare:[obj2 title] options:NSNumericSearch|NSCaseInsensitiveSearch];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(results);
        });
    });
}

-(void)getRecentPlacesWithCompletion:(void (^)(NSArray *recents))completionBlock{
    dispatch_group_notify(self.placesGroup, dispatch_get_main_queue(), ^{
        NSArray *recentPlaces = [[NSUserDefaults standardUserDefaults] arrayForKey:PlacesRecentPlacesKey];
        NSArray *recentPlacesDetails = [self.places objectsForKeys:recentPlaces notFoundMarker:[NSNull null]];
 
        recentPlacesDetails = [recentPlacesDetails filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([evaluatedObject isEqual:[NSNull null]]) return false;
            return true;
        }]];
        
        completionBlock(recentPlacesDetails);
    });
}

-(void)userWillViewPlace:(RUPlace *)place{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recentPlaces = [[userDefaults arrayForKey:PlacesRecentPlacesKey] mutableCopy];
    NSString *ID = place.uniqueID;
    if ([recentPlaces containsObject:ID]){
        [recentPlaces removeObject:ID];
    }
    [recentPlaces insertObject:ID atIndex:0];

    [userDefaults setObject:recentPlaces forKey:PlacesRecentPlacesKey];
    
    [self notifyRecentPlacesDidUpdate];
}

-(void)notifyRecentPlacesDidUpdate{
    [[NSNotificationCenter defaultCenter] postNotificationName:PlacesDataDidUpdateRecentPlacesKey object:self];
}

#pragma mark - nearby api
-(void)placesNearLocation:(CLLocation *)location completion:(void (^)(NSArray *nearbyPlaces))completionBlock{
    if (!location) {
        completionBlock(@[]);
        return;
    }
    dispatch_group_notify(self.placesGroup, dispatch_get_main_queue(), ^{
        NSArray *nearbyPlaces = [[self.places allValues] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(RUPlace *place, NSDictionary *bindings) {
            if (!place.location) return NO;
            return ([place.location distanceFromLocation:location] < NEARBY_DISTANCE);
        }]];
        
        nearbyPlaces = [nearbyPlaces sortedArrayUsingComparator:^NSComparisonResult(RUPlace *placeOne, RUPlace *placeTwo) {

            CLLocationDistance distanceOne = [placeOne.location distanceFromLocation:location];
            CLLocationDistance distanceTwo = [placeTwo.location distanceFromLocation:location];
            
            if (distanceOne < distanceTwo) return NSOrderedAscending;
            else if (distanceOne > distanceTwo) return NSOrderedDescending;
            return NSOrderedSame;
        }];
    
        completionBlock([nearbyPlaces copy]);
    });
}
@end