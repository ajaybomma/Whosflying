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
    buttonNameString = [[NSMutableAttributedString alloc]initWithString:@"Login with FACEBOOK"];
    [buttonNameString  addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13]
                                                        range:NSMakeRange(0,10)];
    [buttonNameString  addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13]
                                                        range:NSMakeRange(10,[buttonNameString length]-10)];
    loginButton.titleLabel.attributedText = buttonNameString;
    [loginButton setTitleColor:[UIColor whiteColor] forState:0];
    [loginButton setBackgroundColor:[UIColor colorWithRed:0 green:0.7 blue:0 alpha:0.5]];
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
