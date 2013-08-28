//
//  InviteFriendCell.m
//  Yebab
//
//  Created by sushil on 07/05/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import "InviteFriendCell.h"

@implementation InviteFriendCell

@synthesize nameLable;
@synthesize  emailLable,
inviteButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
