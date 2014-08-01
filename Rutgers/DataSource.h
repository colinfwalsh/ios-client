//
//  DataSource.h
//  
//
//  Created by Kyle Bailey on 6/24/14.
//  Copyright (c) 2014 Kyle Bailey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAPLContentLoading.h"

@class DataSource;
@class LayoutMetrics;

@interface DataSource : NSObject <UITableViewDataSource, UICollectionViewDataSource, AAPLContentLoading>

/// The title of this data source. This value is used to populate section headers and the segmented control tab.
@property (nonatomic, copy) NSString *title;

/// The number of sections in this data source.
@property (nonatomic, readonly) NSInteger numberOfSections;

- (NSInteger)numberOfItemsInSection:(NSInteger)section;

/// Find the item at the specified index path.
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

/// Find the index paths of the specified item in the data source. An item may appear more than once in a given data source.
- (NSArray *)indexPathsForItem:(id)item;

#pragma mark - Placeholders

@property (nonatomic, copy) NSString *noContentTitle;
@property (nonatomic, copy) NSString *noContentMessage;
@property (nonatomic, strong) UIImage *noContentImage;

@property (nonatomic, copy) NSString *errorMessage;
@property (nonatomic, copy) NSString *errorTitle;
@property (nonatomic, strong) UIImage *errorImage;

/// Is this data source "hidden" by a placeholder either of its own or from an enclosing data source. Use this to determine whether to report that there are no items in your data source while loading.
@property (nonatomic, readonly) BOOL obscuredByPlaceholder;

#pragma mark - Subclass hooks
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

/// Register reusable views needed by this data source
- (void)registerReusableViewsWithCollectionView:(UICollectionView *)collectionView NS_REQUIRES_SUPER;

- (void)registerReusableViewsWithTableView:(UITableView *)tableView NS_REQUIRES_SUPER;

#pragma mark - Content loading

/// Signal that the datasource SHOULD reload its content
- (void)setNeedsLoadContent;

/// Load the content of this data source.
- (void)loadContent;

/// Reset the content and loading state.
- (void)resetContent NS_REQUIRES_SUPER;

/// Use this method to wait for content to load. The block will be called once the loadingState has transitioned to the ContentLoaded, NoContent, or Error states. If the data source is already in that state, the block will be called immediately.
- (void)whenLoaded:(dispatch_block_t)block;

@end