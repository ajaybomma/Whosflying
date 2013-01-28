//
//  FriendsViewController.h
//  Whosflying
//
//  Created by startup on 16/01/13.
//  Copyright (c) 2013 startup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "ViewController.h"
#import "Cell.h"
#import "PostCommentViewController.h"

@interface FriendsViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSArray *matchedFriendsArray;

@end
