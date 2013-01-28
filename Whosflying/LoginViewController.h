//
//  LoginViewController.h
//  Whosflying
//
//  Created by startup on 11/01/13.
//  Copyright (c) 2013 startup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LoginViewController : UIViewController

@property(nonatomic,strong)NSMutableAttributedString *buttonNameString;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

-(IBAction)performLogin:(id)sender;
-(void)loginFailed;
@end
