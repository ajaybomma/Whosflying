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
                                            FBFriendPickerDelegate,CLLocationManagerDelegate,
                                            MKMapViewDelegate>

@property (strong,nonatomic) NSNumber *currentLatitude;
@property (strong,nonatomic) NSNumber *currentLongitude;
@property (strong,nonatomic) NSString *rootPath;
@property (strong,nonatomic) NSString *pListPath;
@property (strong,nonatomic) NSMutableArray *pListDataArray;
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) NSArray *userLocationArray;
@property (strong,nonatomic) id<FBGraphPlace> userLocation;
@property (strong,nonatomic) NSMutableArray *friendsAroundUserArray;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;

-(void)logout:(id)sender;
-(void)writeUserDetailsToPlist;
-(IBAction)ok:(id)sender;
-(void)friendsAroundTheUser;
@end
