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
@synthesize commentsTextView,postParameters,friendId,postButton;

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
    postParameters = [NSMutableDictionary dictionary];
    kPlaceholderPostMessage = @"Say something to your friend..";
    [self resetPostMessage];
    postButton.enabled = NO;
    NSLog(@"view frame is +++%@",NSStringFromCGRect(self.commentsView.frame));
    NSLog(@"text view frame is +++%@",NSStringFromCGRect(commentsTextView.frame));
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
    if(![commentsTextView.text isEqualToString:kPlaceholderPostMessage])
    {
        postButton.enabled = YES;
        [postParameters setObject:commentsTextView.text forKey:@"message"];
        [postParameters setObject:friendId forKey:@"friend_id"];
    
        if([FBSession.activeSession.permissions indexOfObject:@"publish_stream"] == NSNotFound)
        {
            [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray
                                     arrayWithObjects:@"publish_stream",nil]
                                    defaultAudience:FBSessionDefaultAudienceFriends
                                    completionHandler:^(FBSession *session, NSError *error)
            {
                                                     [self publishStory];
                                                 }];
        }
        else
            [self publishStory];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:kPlaceholderPostMessage])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
        self.mainView.frame = CGRectMake(0, -130, 320, 460);
        
        NSLog(@"view frame is +++%@",NSStringFromCGRect(self.commentsView.frame));
        NSLog(@"text view frame is +++%@",NSStringFromCGRect(commentsTextView.frame));
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""] )
        [self resetPostMessage];
    else
        postButton.enabled = YES;
    self.mainView.frame = CGRectMake(0, 0, 320, 460);
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
         NSString *alertText;
         NSLog(@"error +++%@",error);
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
