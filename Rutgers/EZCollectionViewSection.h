//
//  EZCollectionViewSection.h
//  Rutgers
//
//  Created by Kyle Bailey on 6/3/14.
//  Copyright (c) 2014 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EZCollectionViewItem;

@interface EZCollectionViewSection : NSObject
@property (nonatomic) NSString *title;
-(instancetype)initWithSectionTitle:(NSString *)sectionTitle;
-(instancetype)initWithSectionTitle:(NSString *)sectionTitle items:(NSArray *)items;

-(void)addItem:(EZCollectionViewItem *)item;
-(void)addItems:(NSArray *)items;
-(void)removeAllItems;

-(NSInteger)numberOfItems;
-(EZCollectionViewItem *)itemAtIndex:(NSInteger)index;
@end
