
//
//  RUAppDelegate.m
//  Rutgers
//
//  Created by Russell Frank on 1/12/14.
//  Copyright (c) 2014 Rutgers. All rights reserved.
//

#import "RUAppDelegate.h"
#import "XMLDictionary.h"
#import "RURootController.h"
#import "RUAppearance.h"

#import "ARTabBarController.h"

#import "RUChannelManager.h"
#import "RUUserInfoManager.h"


#define MEMORY_MEGS 20
#define DISK_MEGS 50

@interface RUAppDelegate () <UITabBarControllerDelegate>
//@property RURootController *rootController;
@property UITabBarController *tabBarController;
@property RUChannelManager *channelManager;
@end

@implementation RUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initCache];
    [application setStatusBarHidden:NO];
    
    [RUAppearance applyAppearance];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate = self;
    
    self.channelManager = [RUChannelManager sharedInstance];
    
    NSArray *channels = [self.channelManager loadChannels];
    
    self.tabBarController.viewControllers = [self viewControllerForChannels:channels];
    
    [self.channelManager loadWebLinksWithCompletion:^(NSArray *webLinks) {
        NSArray *viewControllers = [self viewControllerForChannels:webLinks];
        self.tabBarController.viewControllers = [self.tabBarController.viewControllers arrayByAddingObjectsFromArray:viewControllers];
    }];
    
    [RUAppearance applyAppearance];
    /*
    [RUAppearance applyAppearanceToTabBarController:self.tabBarController];
    [RUAppearance applyAppearanceToNavigationController:self.tabBarController.moreNavigationController];
    */
   // [self.tabBarController.moreNavigationController setViewControllers:@[]];
    
    self.window.rootViewController = self.tabBarController;
    
    /*
    self.rootController = [[RURootController alloc] init];
    self.window.rootViewController = [self.rootController makeRootViewController];//[[ARTabBarController alloc] init];//
    */
    [self.window makeKeyAndVisible];
    
    RUUserInfoManager *userInfoManager = [RUUserInfoManager sharedInstance];
   
    if (!userInfoManager.hasUserInformation) {
        [userInfoManager getUserInformationCompletion:^{
            
        }];
    }
    
    return YES;
}

-(NSArray *)viewControllerForChannels:(NSArray *)channels{
    NSMutableArray *viewControllers = [NSMutableArray array];
    for (NSDictionary *channel in channels) {
        UIViewController *viewController = [self.channelManager viewControllerForChannel:channel];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        navigationController.tabBarItem = viewController.tabBarItem;
        
        //[RUAppearance applyAppearanceToNavigationController:navigationController];
        [viewControllers addObject:navigationController];
    }
    return viewControllers;
}
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    CGFloat ratio = [tabBarController.viewControllers indexOfObject:viewController]/((CGFloat)tabBarController.viewControllers.count);
    self.tabBarController.tabBar.tintColor = [UIColor colorWithHue:ratio saturation:1 brightness:1 alpha:1];
}
-(void)initCache{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesFolder = paths[0];
    NSString *fullPath = [cachesFolder stringByAppendingPathComponent:@"RUNetCache"];
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:MEMORY_MEGS * 1024 * 1024 diskCapacity:DISK_MEGS * 1024 * 1024 diskPath:fullPath];
    [NSURLCache setSharedURLCache:URLCache];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
