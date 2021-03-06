//
//  RUPlaceDetailDataSource.h
//  Rutgers
//
//  Created by Kyle Bailey on 8/25/14.
//  Copyright (c) 2014 Rutgers. All rights reserved.
//

#import "ComposedDataSource.h"

@class RUPlace;

@interface RUPlaceDetailDataSource : ComposedDataSource
-(instancetype)init NS_UNAVAILABLE;
-(instancetype)initWithPlace:(RUPlace *)place NS_DESIGNATED_INITIALIZER;
-(instancetype)initWithSerializedPlace:(NSString *)serializedPlace NS_DESIGNATED_INITIALIZER;
-(void)startUpdates;
-(void)stopUpdates;
@end
