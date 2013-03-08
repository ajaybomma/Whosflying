//
//  FriendsAroundYouViewController.m
//  Whosflying
//
//  Created by startup on 29/01/13.
//  Copyright (c) 2013 startup. All rights reserved.
//

#import "FriendsAroundYouViewController.h"
#import "UIViewController+ProgressSheet.h"
#import "ViewController.h"
#import "Cell.h"

@interface FriendsAroundYouViewController ()

@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation FriendsAroundYouViewController
@synthesize matchedFriendsArray,friendsListTableView,listOfSearchedFriends,placePickerController;
@synthesize optionsTableView,navigationItem,searchBar,optionsArray,location,faceBook_Id;

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
    optionsArray = [[NSArray alloc]initWithObjects:@"Upto 10miles",@"Upto 20miles",
                                            @"Upto 30miles",@"Nearby places", nil];
    searching = NO;
    listOfSearchedFriends = [[NSMutableArray alloc] init];
    matchedFriendsArray = [[NSMutableArray alloc] init];
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    titleLable.text = @"Buddies Around You";
    titleLable.adjustsFontSizeToFitWidth = YES;
    titleLable.font = [UIFont boldSystemFontOfSize:20];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.titleView = titleLable;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:
                                    [NSURL URLWithString:[NSString stringWithFormat:
                                    @"http://173.255.195.108:3011/users/near_by?uid=%@&min=0&max=5",faceBook_Id]]];
    [request setHTTPMethod:@"GET"];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    [self startCenterAndNonBlockBusyViewWithTitle:@"Loading..." needUserInteraction:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 1)
    {
        if (searching)
            return [listOfSearchedFriends count];
        else
            return [matchedFriendsArray count];
    }
    else
        return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 1)
    {
        static NSString *CellIdentifier = @"Cell";
        Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[Cell alloc]
                    initWithStyle:UITableViewCellStyleValue1
                    reuseIdentifier:CellIdentifier];
        }
        if(searching)
        {
            cell.textLabel.text =
            [[listOfSearchedFriends objectAtIndex:indexPath.row] objectForKey:@"user_name"];
            cell.profilePicture.profileID =
            [[listOfSearchedFriends objectAtIndex:indexPath.row] objectForKey:@"user_facebook_uid"];
        }
        else
        {
            cell.textLabel.text =
            [[matchedFriendsArray objectAtIndex:indexPath.row] objectForKey:@"user_name"];
            cell.profilePicture.profileID =
            [[matchedFriendsArray objectAtIndex:indexPath.row] objectForKey:@"user_facebook_uid"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    else{
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell1 == nil)
        {
            cell1 = [[UITableViewCell alloc]
                     initWithStyle:UITableViewCellStyleValue1
                     reuseIdentifier:CellIdentifier];
        }
        cell1.textLabel.text = [optionsArray objectAtIndex:indexPath.row];
        return cell1;
    }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(tableView.tag == 1)
//    {
//        PostCommentViewController *postCommentViewController =
//        [[PostCommentViewController alloc] initWithNibName:@"PostCommentViewController"
//                                                    bundle:nil];
//        [self presentViewController:postCommentViewController animated:YES completion:nil];
//        if(searching)
//        {
//            postCommentViewController.profilePicture.profileID =
//            [[listOfSearchedFriends objectAtIndex:indexPath.row] objectForKey:@"user_facebook_uid"];
//            postCommentViewController.friendNameLabel.text =
//            [[listOfSearchedFriends objectAtIndex:indexPath.row] objectForKey:@"user_name"];
//            postCommentViewController.friendId =
//            [[listOfSearchedFriends objectAtIndex:indexPath.row] objectForKey:@"user_facebook_uid"];
//        }
//        else
//        {
//            postCommentViewController.profilePicture.profileID =
//            [[matchedFriendsArray objectAtIndex:indexPath.row] objectForKey:@"user_facebook_uid"];
//            postCommentViewController.friendNameLabel.text =
//            [[matchedFriendsArray objectAtIndex:indexPath.row] objectForKey:@"user_name"];
//            postCommentViewController.friendId =
//            [[matchedFriendsArray objectAtIndex:indexPath.row] objectForKey:@"user_facebook_uid"];
//        }
//    }
//    else
//    {
//        [self.optionsView setHidden:YES];
//        switch (indexPath.row) {
//                case 0:
//            {
//                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://173.255.195.108:3011/users/near_by?uid=%@&min=0&max=10",faceBook_Id]]];
//                [request setHTTPMethod:@"GET"];
//                [NSURLConnection connectionWithRequest:request delegate:self];
//                break;
//            }
//                case 1:
//            {
//                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://173.255.195.108:3011/users/near_by?uid=%@&min=0&max=20",faceBook_Id]]];
//                [request setHTTPMethod:@"GET"];
//                [NSURLConnection connectionWithRequest:request delegate:self];
//                break;
//            }
//            case 2:
//            {
//                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://173.255.195.108:3011/users/near_by?uid=%@&min=0&max=30",faceBook_Id]]];
//                [request setHTTPMethod:@"GET"];
//                [NSURLConnection connectionWithRequest:request delegate:self];
//                break;
//            }
//            case 3: if (!placePickerController)
//            {
//                placePickerController = [[FBPlacePickerViewController alloc]
//                                         initWithNibName:nil bundle:nil];
//                placePickerController.title = @"Select a restaurant";
//                placePickerController.navigationItem.leftBarButtonItem =
//                [[UIBarButtonItem alloc] initWithTitle:@"Back"
//                                                 style:UIBarButtonItemStyleBordered
//                                                target:self
//                                                action:@selector(Back:)];
//            }
//                placePickerController.locationCoordinate = location.coordinate;
//                placePickerController.radiusInMeters = 1500;
//                placePickerController.resultsLimit = 50;
//                placePickerController.searchText = @"restaurant";
//                [placePickerController loadData];
//                UINavigationController *navigationController =
//                [[UINavigationController alloc] initWithRootViewController:placePickerController];
//                [self presentViewController:navigationController animated:TRUE completion:Nil];
//                break;
//        }
//    }
//}

//- (IBAction)Back:(id)sender
//{
//    [self dismissViewControllerAnimated:YES completion:Nil];
//}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar
{
    friendsListTableView.userInteractionEnabled = NO;
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(Done:)];
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

- (void)searchTableView
{
    NSString *searchText = searchBar.text;
    for (int i =0; i < [matchedFriendsArray count]; i++ )
    {
        NSRange titleResultsRange = [[[matchedFriendsArray objectAtIndex:i] objectForKey:@"user_name"]
                                     rangeOfString:searchText
                                     options:NSCaseInsensitiveSearch];
        if(titleResultsRange.length > 0)
        {
            [listOfSearchedFriends addObject:[matchedFriendsArray objectAtIndex:i]];
        }
    }
}

- (void)Done:(id)sender
{
    friendsListTableView.userInteractionEnabled = YES;
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    searching = NO;
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Options"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(moreOptionsButtonTapped:)];
    
    friendsListTableView.scrollEnabled = YES;
    [self.friendsListTableView reloadData];
}

- (IBAction)moreOptionsButtonTapped:(id)sender
{
    if([self.optionsView isHidden])
    {
        [self.optionsView setHidden:NO];
    }
    else
    {
        [self.optionsView setHidden:YES];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self stopCenterAndNonBlockBusyViewWithTitle];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse");
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"data ++%@",data);
    self.responseData = [[NSMutableData alloc]init];
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"finish loading +++%@",self.responseData);
    id response = [NSJSONSerialization JSONObjectWithData:self.responseData options:1 error:nil];
    NSLog(@"responce ++++%@",response);
    for (id frd in response)
    {
        [matchedFriendsArray addObject:frd];
    }
    [self stopCenterAndNonBlockBusyViewWithTitle];
    [friendsListTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    friendsListTableView.userInteractionEnabled = YES;
    [self.searchBar resignFirstResponder];
    [friendsListTableView reloadData];
}

@end
