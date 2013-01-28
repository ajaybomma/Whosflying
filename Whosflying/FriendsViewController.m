//
//  FriendsViewController.m
//  Whosflying
//
//  Created by startup on 16/01/13.
//  Copyright (c) 2013 startup. All rights reserved.
//

#import "FriendsViewController.h"
#import "ViewController.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController
@synthesize matchedFriendsArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Friends Around you";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [matchedFriendsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[Cell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[matchedFriendsArray objectAtIndex:indexPath.row] name];
    cell.profilePicture.profileID = [[matchedFriendsArray objectAtIndex:indexPath.row] id];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostCommentViewController *postCommentViewController = [[PostCommentViewController alloc]initWithNibName:@"PostCommentViewController" bundle:nil];
    [self presentViewController:postCommentViewController animated:YES completion:nil];
    postCommentViewController.profilePicture.profileID = [[matchedFriendsArray objectAtIndex:indexPath.row] id];
    postCommentViewController.friendNameLabel.text = [[matchedFriendsArray objectAtIndex:indexPath.row] name];
    postCommentViewController.friendId = [[matchedFriendsArray objectAtIndex:indexPath.row] id];
}
@end
