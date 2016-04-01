//
//  RUBusSubscribeToNotificationViewController.m
//  Rutgers
//
//  Created by Open Systems Solutions on 4/1/16.
//  Copyright © 2016 Rutgers. All rights reserved.
//

#import "RUBusSubscribeToNotificationViewController.h"

@interface RUBusSubscribeToNotificationViewController ()

@property (weak, nonatomic) IBOutlet UILabel *busStopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalTimeDescriptionLabel;

@property (weak, nonatomic) IBOutlet UIPickerView *minutesPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *busArrivalPickerView;

@property (weak, nonatomic) IBOutlet UIButton *remindMeButton;

@property (strong, nonatomic) NSString *busStopName;
@property (strong, nonatomic) NSString *busName;

@property (strong, nonatomic) NSArray *arrivalTimes;

@end

@implementation RUBusSubscribeToNotificationViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil busStopName:(NSString *)busStopName busName:(NSString *)busName arrivalTimes:(NSArray *)arrivalTimes
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        self.busName = busName;
        self.busStopName = busStopName;
        self.arrivalTimes = arrivalTimes;
    }
    
    return self;
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return @"HellO";
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.arrivalTimes.count;
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}
- (IBAction)remindMeClick:(id)sender
{
    
}

@end
