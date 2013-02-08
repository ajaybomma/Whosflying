//
//  ViewController.m
//  Whosflying
//
//  Created by startup on 11/01/13.
//  Copyright (c) 2013 startup. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSMutableArray *userFriendsIdsArray;
}

@end

@implementation ViewController
@synthesize profilePicture,locationManager,pListDataArray,rootPath,pListPath;
@synthesize userNameLabel,friendsAroundUserArray,currentLatitude,currentLongitude,dataListIdsArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    pListDataArray = [[NSMutableArray alloc] init];
    locationManager = [[CLLocationManager alloc]init];
    [locationManager setDelegate:self];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(logout:)];
   
    rootPath = [NSSearchPathForDirectoriesInDomains
                (NSDocumentDirectory, NSUserDomainMask,YES)
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
        NSData *plistXML = [[NSFileManager defaultManager]
                            contentsAtPath:pListPath];
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
    dataListIdsArray = [[NSMutableArray alloc]init];
    friendsAroundUserArray = [[NSMutableArray alloc]init];
    userFriendsIdsArray = [[NSMutableArray alloc] init];
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
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection,
                                                           NSDictionary<FBGraphUser> *user,
                                                                            NSError *error){
        if(!error)
        {
            userNameLabel.text = user.name;
            profilePicture.profileID = user.id;
            NSDictionary *userDetailsDict =
            [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:user.id,user.name,
                                                     currentLatitude,currentLongitude, nil]
                                                   forKeys:[NSArray arrayWithObjects:@"ID",
                                                    @"Name",@"Latitude",@"Longitude", nil]];
            if([pListDataArray count] > 0)
            {
                for (int i = 0; i < [pListDataArray count]; i++)
                {
                    NSDictionary *tempDictionary = [pListDataArray objectAtIndex:i];
                    if([[tempDictionary objectForKey: @"ID"]
                       isEqual:[userDetailsDict objectForKey:@"ID"]])
                    {
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
                         [pListDataArray writeToFile:pListPath atomically:YES];
                     }
                 }
             }
             else
                NSLog(@"error description %@",error.description);
         }];
}

-(void)friendsAroundTheUser
{
    [[FBRequest requestForMyFriends]
     startWithCompletionHandler:^(FBRequestConnection *connection,
                                                        id result,
                                                   NSError *error)
     {
         NSArray *data = (NSArray *)[result objectForKey:@"data"];
         for (FBGraphObject<FBGraphUser> *friend in data)
         {
             [userFriendsIdsArray addObject:[friend id]];
         }
         
         CLLocation *userLocation = [[CLLocation alloc]
                                     initWithLatitude:(CLLocationDegrees)[currentLatitude doubleValue]
                                     longitude:(CLLocationDegrees)[currentLongitude doubleValue]];
         for (NSDictionary *tempDict in pListDataArray)
         {
             CLLocationCoordinate2D coord;
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
                 if(![friendId isEqualToString:profilePicture.profileID])
                     [dataListIdsArray addObject:tempDict];
                 
                 for (FBGraphObject<FBGraphUser> *friend in data)
                 {
                     if ([friendId isEqualToString:[friend id]])
                     {
                         [dataListIdsArray removeObject:tempDict];
                         [friendsAroundUserArray addObject:tempDict];
                         break;
                     }
                 }
             }
         }
         [self friendsOfFriendsAroundUser];
     }];
}

-(void)friendsOfFriendsAroundUser
{ 
    for (NSDictionary *dataDict in dataListIdsArray)
    {
        for (NSString *friendId in userFriendsIdsArray)
        {
            NSString *query =
           [NSString stringWithFormat:@"SELECT uid1, uid2 FROM friend WHERE uid1 =%@ AND uid2 =%@",
                                                            [dataDict objectForKey:@"ID"],friendId];
            NSDictionary *queryParam =
            [NSDictionary dictionaryWithObjectsAndKeys:query, @"q", nil];
            [FBRequestConnection startWithGraphPath:@"/fql"
                                         parameters:queryParam
                                         HTTPMethod:@"GET"
                                  completionHandler:^(FBRequestConnection *connection,
                                                          id result,
                                                           NSError *error) {
            if (error)
            {
                NSLog(@"Error: %@", [error localizedDescription]);
            }
            else
            {
                NSString *temp = [result objectForKey:@"data"];
                if(![temp isEqual:[NSNull null]])
                {
                    if (![friendsAroundUserArray containsObject:dataDict])
                    {
                        [friendsAroundUserArray addObject:dataDict];
                    }
                }
             }}];
           }
        }
}

-(IBAction)ok:(id)sender
{
    FriendsAroundYouViewController *friendsAroundYouViewController =
    [[FriendsAroundYouViewController alloc] initWithNibName:@"FriendsAroundYouViewController"
                                                     bundle:nil];
    friendsAroundYouViewController.matchedFriendsArray =
    [NSArray arrayWithArray:friendsAroundUserArray];
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

@end