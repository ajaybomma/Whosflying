//
//  FriendPickerController.m
//  Whosflying
//
//  Created by startup on 17/01/13.
//  Copyright (c) 2013 startup. All rights reserved.
//

#import "FriendPickerController.h"

@interface FriendPickerController ()

@end

@implementation FriendPickerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                shouldIncludeUser:(id<FBGraphUser>)user
{
    return NO;
}
@end
