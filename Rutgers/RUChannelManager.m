//
//  RUComponentManager.m
//  Rutgers
//
//  Created by Kyle Bailey on 5/12/14.
//  Copyright (c) 2014 Rutgers. All rights reserved.
//
#import "RUChannelManager.h"
#import "RUNetworkManager.h"

#import "RUComponentProtocol.h"

@interface RUChannelManager ()
@property NSArray *webChannels;
@property NSArray *channels;
@end

@implementation RUChannelManager

+(RUChannelManager *)sharedInstance{
    static RUChannelManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RUChannelManager alloc] init];
    });
    return manager;
}

-(NSArray *)loadChannels{
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Channels" ofType:@"json"]];
    NSError *error;
    if (error && !data) {
    } else {
        self.channels = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    }
    return self.channels;
}

-(void)loadWebLinksWithCompletion:(void(^)(NSArray *webLinks))completion{
    [[RUNetworkManager jsonSessionManager] GET:@"shortcuts.txt" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSArray *webChannels = responseObject;
            self.webChannels = [webChannels filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                NSString *handle = evaluatedObject[@"handle"];
                for (NSDictionary *channel in self.channels) {
                    if ([channel[@"handle"] isEqualToString:handle]) {
                        return false;
                    }
                }
                return true;
            }]];
            completion(responseObject);
        } else {
            [self loadWebLinksWithCompletion:completion];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self loadWebLinksWithCompletion:completion];
    }];
}

-(UIViewController *)viewControllerForChannel:(NSDictionary *)channel{
    NSString *view = channel[@"view"];
    if (!view) view = @"www";
    //everthing from shortcuts.txt will get a view of www
  //  if ([self.webChannels containsObject:channel])
    if ([view isEqualToString:@"dtable"]) view = @"DynamicCollectionView";
    Class class = NSClassFromString(view);
    if (class && [class respondsToSelector:@selector(componentForChannel:)]) {
        UIViewController * vc = [class componentForChannel:channel];
        vc.title = [channel titleForChannel];
        vc.tabBarItem.image = [channel iconForChannel];
        return vc;
    } else {
        NSLog(@"No way to handle view type %@, \n%@",view,channel);
    }
    return nil;
}


@end
