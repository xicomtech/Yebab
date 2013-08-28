//
//  YBInviteFriendViewController.h
//  Yebab
//
//  Created by sushil on 02/05/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  <MessageUI/MessageUI.h>

@interface YBInviteFriendViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate>{
    
    IBOutlet UITableView  *inviteFriendTable;
    IBOutlet UITableView  *inviteFriendCellTable;
    NSMutableArray        *emailFrdArray;
    NSMutableArray        *phoneNoFrdArray;
    NSMutableArray        *fullNameFrdArray;
    
    IBOutlet UIButton     *emailBtn;
    IBOutlet UIButton     *smsBtn;
    NSString     *emailStr;
    NSString     *phoneNoStr;
    NSString     *fullNameStr;
    BOOL smsFlag;
    NSInteger inviteFlagInt;

}
//-(IBAction)finishButtonTapped;///:(id)sender)
-(IBAction)EmailAndSmsButtonAction:(id)sender;

@end
