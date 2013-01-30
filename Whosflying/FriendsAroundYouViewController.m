//
//  FriendsAroundYouViewController.m
//  Whosflying
//
//  Created by startup on 29/01/13.
//  Copyright (c) 2013 startup. All rights reserved.
//

#import "FriendsAroundYouViewController.h"
#import "ViewController.h"
#import "Cell.h"

@interface FriendsAroundYouViewController ()

@end

@implementation FriendsAroundYouViewController
@synthesize matchedFriendsArray,friendsListTableView,listOfSearchedFriends,searchBar,navigationItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    searching = NO;
    listOfSearchedFriends = [[NSMutableArray alloc] init];
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
    if (searching)
        return [listOfSearchedFriends count];
    else
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
    if(searching)
    {
            cell.textLabel.text = [[listOfSearchedFriends objectAtIndex:indexPath.row] name];
            cell.profilePicture.profileID = [[listOfSearchedFriends objectAtIndex:indexPath.row] id];
    }
    else
    {
        cell.textLabel.text = [[matchedFriendsArray objectAtIndex:indexPath.row] name];
        cell.profilePicture.profileID = [[matchedFriendsArray objectAtIndex:indexPath.row] id];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostCommentViewController *postCommentViewController = [[PostCommentViewController alloc]
                                                            initWithNibName:@"PostCommentViewController"
                                                            bundle:nil];
    [self presentViewController:postCommentViewController animated:YES completion:nil];
    if(searching)
    {
        postCommentViewController.profilePicture.profileID = [[listOfSearchedFriends objectAtIndex:indexPath.row] id];
        postCommentViewController.friendNameLabel.text = [[listOfSearchedFriends objectAtIndex:indexPath.row] name];
        postCommentViewController.friendId = [[listOfSearchedFriends objectAtIndex:indexPath.row] id];
    }
    else
    {
        postCommentViewController.profilePicture.profileID = [[matchedFriendsArray objectAtIndex:indexPath.row] id];
        postCommentViewController.friendNameLabel.text = [[matchedFriendsArray objectAtIndex:indexPath.row] name];
        postCommentViewController.friendId = [[matchedFriendsArray objectAtIndex:indexPath.row] id];
     }
}

- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        return indexPath;
}

-(IBAction)Back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar
{
    if([searchBar.text length] > 0)
        searching = YES;
    else
        searching = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                              target:self action:@selector(Done:)];
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText
{    
    [listOfSearchedFriends removeAllObjects];
    if([searchText length] > 0)
    {
        searching = YES;
        [self searchTableView];
    }
    else
    {
        searching = NO;
    }
    [self.friendsListTableView reloadData];
}

-(void)searchTableView
{
    NSString *searchText = searchBar.text;
    for (int i =0; i < [matchedFriendsArray count]; i++ )
    {
        NSRange titleResultsRange = [[[matchedFriendsArray objectAtIndex:i] name]
                                     rangeOfString:searchText
                                     options:NSCaseInsensitiveSearch];
        if(titleResultsRange.length > 0)
            [listOfSearchedFriends addObject:[matchedFriendsArray objectAtIndex:i]];
    }
}

-(void)Done:(id)sender
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    searching = NO;
    self.navigationItem.rightBarButtonItem = nil;
    friendsListTableView.scrollEnabled = YES;
    [self.friendsListTableView reloadData];
}

@end
