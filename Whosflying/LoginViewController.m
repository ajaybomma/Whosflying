//
//  LoginViewController.m
//  Whosflying
//
//  Created by startup on 11/01/13.
//  Copyright (c) 2013 startup. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize spinner,buttonNameString,loginButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    spinner.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)performLogin:(id)sender
{
    spinner.hidden = NO;
    [spinner startAnimating];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate openSession];
}


-(void)loginFailed
{
    spinner.hidden = YES;
    [spinner stopAnimating];
}
@end
