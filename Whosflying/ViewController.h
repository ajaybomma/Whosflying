//
//  ViewController.h
//  Whosflying
//
//  Created by startup on 11/01/13.
//  Copyright (c) 2013 startup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FriendsViewController.h"

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,FBFriendPickerDelegate,CLLocationManagerDelegate,MKMapViewDelegate>

@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) NSArray *userLocationArray;
@property (strong,nonatomic) id<FBGraphPlace> userLocation;
@property (strong,nonatomic) NSMutableArray *aroundFriendsArray;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UITableView *aroundFriendsTableView;

-(void)logout:(id)sender;
-(void)userDetails;
-(IBAction)ok:(id)sender;
-(void)friendsAroundTheUser;
@end
