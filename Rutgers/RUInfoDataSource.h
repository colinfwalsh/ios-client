//
//  RUInfoDataSource.h
//  Rutgers
//
//  Created by Kyle Bailey on 8/20/14.
//  Copyright (c) 2014 Rutgers. All rights reserved.
//

#import "ComposedDataSource.h"

@interface RUInfoDataSource : ComposedDataSource
+(BOOL)buttonTypeEnabled:(NSString *)type;
@end
