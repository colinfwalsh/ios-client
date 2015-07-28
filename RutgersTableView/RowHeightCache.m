//
//  RowHeightCache.m
//  Rutgers
//
//  Created by Kyle Bailey on 8/20/14.
//  Copyright (c) 2014 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RowHeightCache.h"
#import <libkern/OSAtomic.h>

@interface RowHeightCache ()
@property (nonatomic) NSMutableDictionary *sections;
@end

@implementation RowHeightCache
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sections = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)invalidateCachedHeights{
    [self.sections removeAllObjects];
}

-(NSMutableDictionary *)cacheForSection:(NSInteger)section{
    NSMutableDictionary *cache = self.sections[@(section)];
    if (!cache) {
        cache = [NSMutableDictionary dictionary];
        self.sections[@(section)] = cache;
    }
    return cache;
}

-(void)invalidateCachedHeightsForSection:(NSInteger)section{
    [[self cacheForSection:section] removeAllObjects];
}

-(void)invalidateCachedHeightsForIndexPaths:(NSArray *)indexPaths{
    for (NSIndexPath *indexPath in indexPaths) {
        [self invalidateCachedHeightForIndexPath:indexPath];
    }
}
-(void)invalidateCachedHeightForIndexPath:(NSIndexPath *)indexPath{
    [[self cacheForSection:indexPath.section] removeObjectForKey:@(indexPath.row)];
}

-(NSNumber *)cachedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self cacheForSection:indexPath.section][@(indexPath.row)];
}

-(void)setCachedHeight:(CGFloat)height forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self cacheForSection:indexPath.section][@(indexPath.row)] = @(height);
}
@end