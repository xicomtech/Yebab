//
//  YBMeViewController.h
//  Yebab
//
//  Created by Xicom on 07/06/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBMeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *userInfoView;
- (IBAction)tabChanged:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *followingBtn;
@property (strong, nonatomic) IBOutlet UIButton *youBtn;
@property (strong, nonatomic) IBOutlet UIButton *emailBtn;
@property (strong, nonatomic) IBOutlet UILabel *photoLbl;
@property (strong, nonatomic) IBOutlet UILabel *albumLbl;
@property (strong, nonatomic) IBOutlet UILabel *followerLbl;
@property (strong, nonatomic) IBOutlet UILabel *followingLbl;
@property (strong, nonatomic) IBOutlet UILabel *userNameLbl;
@end
