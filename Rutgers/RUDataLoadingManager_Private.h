//
//  RUDataLoadingManager_Private.h
//  Rutgers
//
//  Created by Open Systems Solutions on 6/17/15.
//  Copyright (c) 2015 Rutgers. All rights reserved.
//

#import "RUDataLoadingManager.h"

@interface RUDataLoadingManager ()
-(BOOL)needsLoad;
-(void)load;

-(void)willBeginLoad;
-(void)didEndLoad:(BOOL)loaded withError:(NSError *)error;

@end
