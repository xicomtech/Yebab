//
//  HomeCustomCell.m
//  Yebab
//
//  Created by sushil on 06/05/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import "HomeCustomCell.h"

@implementation HomeCustomCell

@synthesize wallUserImage, delegate;

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

- (IBAction)likeBtnTapped:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    UITableViewCell *cell = (UITableViewCell *)[[[[[btn superview] superview] superview] superview] superview];
    NSIndexPath *indexPath = [(UITableView *)cell.superview indexPathForCell:cell];

    if ([btn isSelected]) {
        [self.delegate unlikeAction:indexPath];
        [btn setSelected:NO];
    }else{
        [btn setSelected:YES];
        _likeImgView.image=[UIImage imageWithContentsOfFile:@"like_icon.png"];
        [self.delegate likeAction:indexPath];
    }
}

- (IBAction)userImgBtnTapped:(id)sender {
    [self.delegate showUserProfile:0];

}
@end
