//
//  ViewController.m
//  Whosflying
//
//  Created by startup on 11/01/13.
//  Copyright (c) 2013 startup. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize profilePicture,userNameLabel,aroundFriendsTableView,aroundFriendsArray,locationManager,userLocationArray;
@synthesize userLocation;

- (void)viewDidLoad
{
    [super viewDidLoad];
    userLocationArray = [[NSArray alloc]init];
    locationManager = [[CLLocationManager alloc]init];
    [locationManager setDelegate:self];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Logout"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(logout:)];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    aroundFriendsArray = [[NSMutableArray alloc]init];
    if(FBSession.activeSession.isOpen)
    {
        [self friendsAroundTheUser];
        [self userDetails];
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

-(void)userDetails
{
    if(FBSession.activeSession.isOpen)
    {
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection,
                                                              NSDictionary<FBGraphUser> *user,
                                                              NSError *error){
                                                                if(!error)
                                                                {
                                                                    profilePicture.profileID = user.id;
                                                                    userNameLabel.text = user.name;
                                                                }
        }];
    }
}

-(IBAction)ok:(id)sender
{
    FriendsViewController *friendsViewController = [[FriendsViewController alloc]
                                                    initWithNibName:@"FriendsViewController"
                                                             bundle:nil];
    friendsViewController.matchedFriendsArray = [NSArray arrayWithArray:aroundFriendsArray];
    [self.navigationController pushViewController:friendsViewController animated:TRUE];
}

-(void)friendsAroundTheUser
{
    
    FBRequest *friendRequest = [FBRequest requestForGraphPath:@"me/friends?fields=location,name"];
    [ friendRequest startWithCompletionHandler:^(FBRequestConnection *connection,
                                                 id result,
                                                 NSError *error)
                                                {
                                                    NSArray *data = (NSArray *)[result objectForKey:@"data"];
                                                    for (FBGraphObject<FBGraphUser> *friend in data)
                                                    {
                                                       NSArray *friendsLocationArray = [[NSArray alloc]init];
                                                        if([[friend location] name] != (id)[NSNull null])
                                                            friendsLocationArray = [[[friend location] name] componentsSeparatedByString:@", "];
                                                        else
                                                            continue;
                                                        if([[userLocationArray objectAtIndex:0] isEqual:[friendsLocationArray objectAtIndex:0]])
                                                        {
                                                            if([userLocationArray count] > 1 && [friendsLocationArray count] > 1)
                                                            {
                                                                for (int i = 1; i < [friendsLocationArray count]; i++)
                                                                {
                                                                    BOOL flag = FALSE;
                                                                    for (int j = 1; j < [userLocationArray count]; j++)
                                                                    {
                                                                       if( [[friendsLocationArray objectAtIndex:i] isEqualToString:[userLocationArray objectAtIndex:j]])
                                                                       {
                                                                           [aroundFriendsArray addObject:friend];
                                                                           flag = TRUE;
                                                                           break;
                                                                       }
                                                                    }
                                                                    if(flag == TRUE)
                                                                        break;
                                                                }
                                                            }
                                                            else
                                                                [aroundFriendsArray addObject:friend];
                                                        }
                                                    }}];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [locationManager stopUpdatingLocation];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    CLLocation* location = [locations lastObject];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         CLPlacemark *placemark;
         if (error == nil && [placemarks count] > 0)
         {
            placemark = [placemarks lastObject];
             if(placemark.locality != NULL)
                 userLocationArray = [NSArray arrayWithObjects:placemark.locality,placemark.administrativeArea,placemark.country, nil];
             else
                 userLocationArray = [NSArray arrayWithObjects:@"Hyderabad",placemark.administrativeArea,placemark.country, nil];
         }
         else {
             NSLog(@"%@", error.debugDescription);
         }
     }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error %@",error);
}

@end