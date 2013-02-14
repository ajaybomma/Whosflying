//
//  ViewController.m
//  Whosflying
//
//  Created by startup on 11/01/13.
//  Copyright (c) 2013 startup. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation ViewController
@synthesize profilePicture,locationManager;
@synthesize userNameLabel,currentLatitude,currentLongitude;

- (void)viewDidLoad
{
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(logout:)];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.responseData = [[NSMutableData alloc]init];
    if(FBSession.activeSession.isOpen)
    {
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection,
                                                               NSDictionary<FBGraphUser> *user,
                                                               NSError *error){
            if(!error)
            {
                userNameLabel.text = user.name;
                profilePicture.profileID = user.id;
                [self storeUserDetailsToDatabase];
            }
            else
                NSLog(@"error description %@",error.description);
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)logout:(id)sender
{
    [FBSession.activeSession closeAndClearTokenInformation];
}

-(void)storeUserDetailsToDatabase
{
    NSString *content =
    [NSString stringWithFormat:@"user[fullname]=%@&user[user_facebook_uid]=%@&user[facebook_access_token]=%@&user[current_latitude]=%@&user[current_longitude]=%@",
     userNameLabel.text,profilePicture.profileID,FBSession.activeSession.accessToken,currentLatitude,currentLongitude];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://173.255.195.108:3011/users"]];
    [request setValue:@"Content-Type" forHTTPHeaderField:@"application/x-www-form-urlencoded"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[content dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

-(IBAction)ok:(id)sender
{
    FriendsAroundYouViewController *friendsAroundYouViewController =
    [[FriendsAroundYouViewController alloc] initWithNibName:@"FriendsAroundYouViewController"
                                                     bundle:nil];
    [self presentViewController:friendsAroundYouViewController
                       animated:YES
                     completion:Nil];
}

-(void)locationManager:(CLLocationManager *)manager
    didUpdateLocations:(NSArray *)locations
{
    [locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    currentLongitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
    currentLatitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
}

-(void)locationManager:(CLLocationManager *)manager
      didFailWithError:(NSError *)error
{
    NSLog(@"error %@",error);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"data ++%@",data);
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"finish loading");
    id response = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:nil];
    NSLog(@"id  +++++%@",response);
}

@end