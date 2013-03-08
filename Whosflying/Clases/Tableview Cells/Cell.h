//
//  Cell.h
//  Whosflying
//
//  Created by startup on 17/01/13.
//  Copyright (c) 2013 startup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface Cell : UITableViewCell

@property (nonatomic,strong) FBProfilePictureView *profilePicture;
@property (nonatomic,strong) UILabel *textLabel;
@end
