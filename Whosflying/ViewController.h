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
#import "FriendsAroundYouViewController.h"

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,
CLLocationManagerDelegate,MKMapViewDelegate>

@property (strong,nonatomic) NSNumber *currentLatitude;
@property (strong,nonatomic) NSNumber *currentLongitude;
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) id<FBGraphPlace> userLocation;
@property (strong,nonatomic) IBOutlet FBProfilePictureView *profilePicture;
@property (strong,nonatomic) IBOutlet UILabel *userNameLabel;

-(void)logout:(id)sender;
-(void)storeUserDetailsToDatabase;
-(IBAction)ok:(id)sender;
@end
