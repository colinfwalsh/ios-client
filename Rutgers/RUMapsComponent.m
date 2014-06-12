//
//  RUMapsComponent.m
//  Rutgers
//
//  Created by Kyle Bailey on 6/3/14.
//  Copyright (c) 2014 Rutgers. All rights reserved.
//

#import "RUMapsComponent.h"
#import "NSUserDefaults+MKMapRect.h"

NSString *const mapsRecentRegionKey = @"mapsRecentRegionKey";


@interface RUMapsComponent ()

@end

@implementation RUMapsComponent
+(instancetype)componentForChannel:(NSDictionary *)channel{
    return [[RUMapsComponent alloc] init];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.mapView.showsUserLocation = YES;
    
    //load last map rect, or world rect
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{mapsRecentRegionKey : MKStringFromMapRect(MKMapRectWorld)}];
    MKMapRect mapRect = [[NSUserDefaults standardUserDefaults] mapRectForKey:mapsRecentRegionKey];
    [self.mapView setVisibleMapRect:mapRect];

}

#pragma mark - MKMapViewDelegate protocol implementation
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    [[NSUserDefaults standardUserDefaults] setMapRect:mapView.visibleMapRect forKey:mapsRecentRegionKey];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end