//
//  FriendsAroundYouViewController.h
//  Whosflying
//
//  Created by startup on 29/01/13.
//  Copyright (c) 2013 startup. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "PostCommentViewController.h"

@interface FriendsAroundYouViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
//{
//    bool searching;
//}

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *friendsListTableView;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (strong, nonatomic) IBOutlet UITableView *optionsTableView;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSMutableArray *matchedFriendsArray;
@property (strong, nonatomic) NSMutableArray *listOfSearchedFriends;
@property (strong, nonatomic) NSArray *optionsArray;
@property (strong, nonatomic) FBPlacePickerViewController *placePickerController;
@property (strong, nonatomic) NSString *faceBook_Id;

-(IBAction)Back:(id)sender;
//-(void)Done:(id)sender;
//-(void)searchTableView;
-(IBAction)moreOptionsButtonTapped:(id)sender;
@end
