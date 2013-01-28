//
//  Cell.m
//  Whosflying
//
//  Created by startup on 17/01/13.
//  Copyright (c) 2013 startup. All rights reserved.
//

#import "Cell.h"

@implementation Cell
@synthesize profilePicture,textLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        profilePicture = [[FBProfilePictureView alloc]initWithFrame:CGRectMake(-30,0, 100, 40)];
        [self addSubview:profilePicture];
        textLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 280, 50)];
        [self addSubview:textLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
