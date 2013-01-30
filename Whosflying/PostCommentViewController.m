//
//  PostCommentViewController.m
//  Whosflying
//
//  Created by startup on 24/01/13.
//  Copyright (c) 2013 startup. All rights reserved.
//

#import "PostCommentViewController.h"

@interface PostCommentViewController ()
{
    NSString *kPlaceholderPostMessage;
    
}
@end

@implementation PostCommentViewController
@synthesize commentsTextView,postParameters,friendId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        postParameters = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     kPlaceholderPostMessage = @"Say something to your friend..";
    [self resetPostMessage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)cancelButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)postButtonTapped:(id)sender
{
    if(![commentsTextView.text isEqualToString:kPlaceholderPostMessage] &&
       ![commentsTextView.text isEqualToString:@""])
    {
        [postParameters setObject:commentsTextView.text forKey:@"message"];
        [postParameters setObject:friendId forKey:@"friend_id"];
    }
    
    if([FBSession.activeSession.permissions indexOfObject:@"publish_stream"] == NSNotFound)
    {
        [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObjects:@"publish_stream",nil]
                                                   defaultAudience:FBSessionDefaultAudienceFriends
                                                 completionHandler:^(FBSession *session, NSError *error){
                                                     [self publishStory];
                                                 }];
    }
    else
        [self publishStory];
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:kPlaceholderPostMessage])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""] )
    {
        [self resetPostMessage];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *) event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.commentsTextView isFirstResponder] && (self.commentsTextView != touch.view))
    {
        [self.commentsTextView resignFirstResponder];
    }
}

- (void)resetPostMessage
{
    self.commentsTextView.text = kPlaceholderPostMessage;
    self.commentsTextView.textColor = [UIColor lightGrayColor];
}

-(void)publishStory
{
    [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@/feed",friendId]
                                 parameters:postParameters
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error)
     {
         NSLog(@"value +++++%@",result);
         NSLog(@"connection ++%@",connection);
         NSLog(@"error ++++%@",error);
         NSString *alertText;
         if (error)
         {
             alertText = [NSString stringWithFormat:
                          @"error: domain = %@, code = %d",
                          error.domain, error.code];
         }
         else
         {
             alertText = [NSString stringWithFormat:
                          @"Posted action, id: %@",
                          [result objectForKey:@"id"]];
         }
         [[[UIAlertView alloc] initWithTitle:@"Result"
                                     message:alertText
                                    delegate:self
                           cancelButtonTitle:@"OK!"
                           otherButtonTitles:nil] show];
     }];
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}
@end
