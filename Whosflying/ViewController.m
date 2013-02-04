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
@synthesize profilePicture,locationManager,userLocationArray,pListDataArray,rootPath,pListPath;
@synthesize userNameLabel,friendsAroundUserArray,currentLatitude,currentLongitude;

- (void)viewDidLoad
{
    [super viewDidLoad];
    pListDataArray = [[NSMutableArray alloc] init];
    friendsAroundUserArray = [[NSMutableArray alloc] init];
    userLocationArray = [[NSArray alloc]init];
    locationManager = [[CLLocationManager alloc]init];
    [locationManager setDelegate:self];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(logout:)];
    rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES)
                objectAtIndex:0];
    
    pListPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:pListPath])
    {
        [[NSFileManager defaultManager] createFileAtPath:pListPath
                                                contents:nil
                                              attributes:nil];
    }
    else
    {
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:pListPath];
        if ([plistXML length])
        {
            pListDataArray = (NSMutableArray *)[NSPropertyListSerialization
                                                propertyListFromData:plistXML
                                                mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                format:&format
                                                errorDescription:&errorDesc];
        }
    }
    if (!pListDataArray)
    {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    friendsAroundUserArray = [[NSMutableArray alloc]init];
    if(FBSession.activeSession.isOpen)
    {
        [self writeUserDetailsToPlist];
        [self friendsAroundTheUser];
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

-(void)writeUserDetailsToPlist
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
                 NSDictionary *userDetailsDict = [NSDictionary dictionaryWithObjects:
                                                 [NSArray arrayWithObjects:user.id,user.name,currentLatitude,currentLongitude, nil]
                                                  forKeys:[NSArray arrayWithObjects:@"ID",@"Name",@"Latitude",@"Longitude", nil]];
                 if([pListDataArray count] > 0)
                 {
                     int count = 0;
                     for (int i = 0; i < [pListDataArray count]; i++)
                     {
                         NSDictionary *tempDictionary = [pListDataArray objectAtIndex:i];
                         if([[tempDictionary objectForKey: @"ID"]
                             isEqual:[userDetailsDict objectForKey:@"ID"]])
                         {
                             count ++;
                             [pListDataArray removeObjectAtIndex:i];
                             [pListDataArray addObject:userDetailsDict];
                             [pListDataArray writeToFile:pListPath atomically:YES];
                             break;
                         }
                         else
                         {
                             if(i == [pListDataArray count]-1)
                             {
                                 [pListDataArray addObject:userDetailsDict];
                                 [pListDataArray writeToFile:pListPath atomically:YES];
                             }
                         }
                     }
                 }
                 else
                 {
                     [pListDataArray addObject:userDetailsDict];
                     if(pListDataArray)
                     {
                         NSLog(@"plistdata array %@", pListDataArray);
                         [pListDataArray writeToFile:pListPath atomically:YES];
                     }
                 }
             }
            else
            NSLog(@"error description %@",error.description);
}];
    }
}

-(void)friendsAroundTheUser
{
    [[FBRequest requestForMyFriends] startWithCompletionHandler:^(FBRequestConnection *connection,
                                                                  id result,
                                                                  NSError *error)
     {
         NSArray *data = (NSArray *)[result objectForKey:@"data"];
         CLLocation *userLocation = [[CLLocation alloc]
                                     initWithLatitude:(CLLocationDegrees)[currentLatitude doubleValue]
                                     longitude:(CLLocationDegrees)[currentLongitude doubleValue]];
         for (int i = 0; i < [pListDataArray count]; i++)
         {
             CLLocationCoordinate2D coord;
             NSDictionary *tempDict = [pListDataArray objectAtIndex:i];
             NSNumber *lat = [tempDict objectForKey:@"Latitude"];
             NSNumber *longt = [tempDict objectForKey:@"Longitude"];
             coord.latitude = (CLLocationDegrees)[lat doubleValue];
             coord.longitude = (CLLocationDegrees)[longt doubleValue];
             CLLocation *friendLocation = [[CLLocation alloc]
                                           initWithLatitude:coord.latitude
                                           longitude:coord.longitude];
             NSString *friendId = [tempDict objectForKey:@"ID"];
             if([friendLocation distanceFromLocation:userLocation] <= 8046.72)
             {
                 for (FBGraphObject<FBGraphUser> *friend in data)
                 {
                     if ([friendId isEqualToString:[friend id]])
                     {
                         [friendsAroundUserArray addObject:friend];
                         break;
                     }
                 }
             }
         }
     }];
}

-(IBAction)ok:(id)sender
{
    FriendsAroundYouViewController *friendsAroundYouViewController = [[FriendsAroundYouViewController alloc]
                                                            initWithNibName:@"FriendsAroundYouViewController"
                                                                                                 bundle:nil];
    friendsAroundYouViewController.matchedFriendsArray = [NSArray arrayWithArray:friendsAroundUserArray];
    [self presentViewController:friendsAroundYouViewController animated:YES completion:Nil];
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

@end