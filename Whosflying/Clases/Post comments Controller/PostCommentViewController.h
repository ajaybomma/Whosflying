//
//  PostCommentViewController.h
//  Whosflying
//
//  Created by startup on 24/01/13.
//  Copyright (c) 2013 startup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsAroundYouViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface PostCommentViewController : UIViewController<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *postButton;
@property (strong, nonatomic) IBOutlet UITextView *commentsTextView;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *friendNameLabel;
@property (strong, nonatomic) NSMutableDictionary *postParameters;
@property (strong, nonatomic) NSString *friendId;
@property (strong, nonatomic) IBOutlet UIView *commentsView;
@property (strong, nonatomic) IBOutlet UIView *mainView;

-(IBAction)cancelButtonTapped:(id)sender;
-(IBAction)postButtonTapped:(id)sender;
-(void)resetPostMessage;
-(void)publishStory;
@end
