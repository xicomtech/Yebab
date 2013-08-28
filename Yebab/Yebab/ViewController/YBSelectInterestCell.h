//
//  YBSelectInterestCell.h
//  Yebab
//
//  Created by xicom-213 on 4/18/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBSelectInterestCell : UITableViewCell{
    
}
@property(nonatomic,retain)  IBOutlet UIButton *followbutton;
@property(nonatomic, retain) IBOutlet UILabel *userNameLbl;
@property(nonatomic, retain) IBOutlet UILabel *followersCountLbl;
@property(nonatomic, retain) IBOutlet UIImageView *userImage;
@property(nonatomic, retain) IBOutlet UIImageView *followUser1;
@property(nonatomic, retain) IBOutlet UIImageView *followUser2;
@property(nonatomic, retain) IBOutlet UIImageView *followUser3;
@property(nonatomic, retain) IBOutlet UIImageView *followUser4;
@property(nonatomic, retain) IBOutlet UIImageView *followUser5;

@end
