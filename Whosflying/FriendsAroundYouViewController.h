//
//  FriendsAroundYouViewController.h
//  Whosflying
//
//  Created by startup on 29/01/13.
//  Copyright (c) 2013 startup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostCommentViewController.h"

@interface FriendsAroundYouViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    bool searching;
}

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *friendsListTableView;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (nonatomic, strong) NSArray *matchedFriendsArray;
@property (nonatomic, strong) NSMutableArray *listOfSearchedFriends;

-(IBAction)Back:(id)sender;
-(void)Done:(id)sender;
-(void)searchTableView;
@end
