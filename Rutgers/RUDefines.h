//
//  RUDefines.h
//  Rutgers
//
//  Created by Open Systems Solutions on 9/21/15.
//  Copyright © 2015 Rutgers. All rights reserved.
//

#ifndef RUDefines_h
#define RUDefines_h

#define kLabelHorizontalInsets      15.0f
#define kLabelVerticalInsets        11.0f

#define kLabelHorizontalInsetsSmall      8.0f
#define kLabelVerticalInsetsSmall        5.0f

#define IPAD_SCALE 1.15

#define ASSERT_MAIN_THREAD NSAssert([NSThread isMainThread], @"This method must be called on the main thread")

#define DEV 0

#define GRANULAR_ANALYTICS_NEEDED 1

extern uint64_t dispatch_benchmark(size_t count, void (^block)(void));

static inline NSComparisonResult compare(NSInteger int1, NSInteger int2)
{
    if (int1 < int2) return NSOrderedAscending;
    if (int1 > int2) return NSOrderedDescending;
    return NSOrderedSame;
};

extern BOOL iPad();

static NSString *const gittag = @"4.1.3";

static NSString *const api = @"2";

/*
    Different RUN Modes for the App to run in .
 
    alpha -> beta -> production ::
   
    The server can be run locally too ::
 
    alpha server :: nvanguard  on internet : nstanlee
    beta server :: doxa
    production server :: nlethe on internet : rumobile
 
 
 */

typedef NS_ENUM(NSUInteger, RunMode)
{
    LocalDevMode ,
    AlphaMode ,
    BetaMode ,
    ProductionMode
};

static RunMode const runMode = BetaMode;

extern BOOL isBeta();

extern NSString * betaModeString();


/*
    Takes in an NSURL and returns the absolute string for that URL
    Without the RU , the name conflicts with internal apple function
 */
extern NSString * RUGetAbsoluteString(NSURL * url);



#endif /* RUDefines_h */
