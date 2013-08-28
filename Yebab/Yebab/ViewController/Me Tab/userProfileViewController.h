//
//  userProfileViewController.h
//  Yebab
//
//  Created by Xicom on 11/06/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface userProfileViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *photoLbl;
@property (strong, nonatomic) IBOutlet UILabel *albumLbl;
@property (strong, nonatomic) IBOutlet UILabel *followingLbl;
@property (strong, nonatomic) IBOutlet UILabel *followerLbl;
- (IBAction)tabChanged:(id)sender;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *tabBtnCollection;
@end
