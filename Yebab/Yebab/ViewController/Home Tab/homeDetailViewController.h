//
//  homeDetailViewController.h
//  Yebab
//
//  Created by Xicom on 23/05/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connections.h"
#import <MessageUI/MessageUI.h>

@protocol homeDetailDelegate
@optional
-(void)reloadTableCell:(NSDictionary *)cellDetail andIndexpath:(NSIndexPath *)indexPath;

@end

@interface homeDetailViewController : UIViewController<ConnectionsDelegate,UITextViewDelegate,MFMailComposeViewControllerDelegate>{
    BOOL isEditing;
    NSString *requestType;
    id<homeDetailDelegate> delegate;
    NSMutableDictionary *imgDic;
}
@property (strong, nonatomic) IBOutlet UIButton *likeBtn;
@property (strong, nonatomic) IBOutlet UIButton *calBtn;
@property (strong, nonatomic) IBOutlet UIButton *msgBtn;
- (IBAction)callBtnTapped:(id)sender;
- (IBAction)msgBtnTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) id<homeDetailDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *userDescView;
@property (strong, nonatomic) IBOutlet UIView *shopDescView;

@property (strong, nonatomic) IBOutlet UITextView *commentTxtView;
@property (strong, nonatomic) IBOutlet UILabel *userCmnt;
@property (strong, nonatomic) IBOutlet UIView *imageInfoView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableDictionary *imageDetail;
@property (strong, nonatomic) NSIndexPath *cellIndexPath;

@property (strong, nonatomic) IBOutlet UIImageView *userImg;
@property (strong, nonatomic) IBOutlet UILabel *userNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *inThingsLbl;
@property (strong, nonatomic) IBOutlet UILabel *dayAgoLbl;
@property (strong, nonatomic) IBOutlet UILabel *likeCountLbl;
@property (strong, nonatomic) IBOutlet UILabel *imgDescLbl;
@property (strong, nonatomic) IBOutlet UILabel *locationLbl;
@property (strong, nonatomic) IBOutlet UILabel *stickCountLbl;
@property (strong, nonatomic) IBOutlet UIView *commentView;
@property (strong, nonatomic) IBOutlet UIImageView *wallUserImg;

- (IBAction)postCommentTapped:(id)sender;
- (IBAction)likeBtnTapped:(id)sender;
- (IBAction)stickBtnTapped:(id)sender;
- (IBAction)commentBtnTapped:(id)sender;

@end
