//
//  HomeCustomCell.h
//  Yebab
//
//  Created by sushil on 06/05/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol homeCustomCelldelegate
//-(void)connectionDidRecievedResponse:(BOOL)isSuccess withData:(id)data selected:(int)selected;

@optional
-(void)likeAction:(NSIndexPath *)indexPath;
-(void)unlikeAction:(NSIndexPath *)indexPath;
-(void)showUserProfile:(NSIndexPath *)indexPath;

@end

@interface HomeCustomCell : UITableViewCell{
    id<homeCustomCelldelegate> delegate;

}
@property (strong, nonatomic) IBOutlet UIImageView *stickImgView;
@property (strong, nonatomic) IBOutlet UIImageView *likeImgView;
- (IBAction)likeBtnTapped:(id)sender;
- (IBAction)userImgBtnTapped:(id)sender;
@property(nonatomic, retain)id<homeCustomCelldelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *imageInfoView;

//@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *activeView;
@property (strong, nonatomic) IBOutlet UIView *commentView;
@property(nonatomic, retain) IBOutlet UIImageView *userImage;
@property(nonatomic, retain) IBOutlet UIImageView *wallUserImage;
@property(nonatomic, retain) IBOutlet UILabel *dayAgoLabel;
@property(nonatomic, retain) IBOutlet UILabel *userNameLabel;
@property(nonatomic, retain) IBOutlet UILabel *inThingsLabel;
@property(nonatomic, retain) IBOutlet UILabel *likeCountLabel;
@property(nonatomic, retain) IBOutlet UILabel *storeCountLabel;
@property(nonatomic, retain) IBOutlet UILabel *userDescriptionLabel;
@property(nonatomic, retain) IBOutlet UILabel *locatioLabel;
@property(nonatomic, retain) IBOutlet UILabel *commentCountLabel;
@property(nonatomic, retain) IBOutlet UILabel *commentUserNameLabel1;
@property(nonatomic, retain) IBOutlet UILabel *commentUserNameLabel2;;
@property(nonatomic, retain) IBOutlet UIButton *commentCountUIButton;
@property (strong, nonatomic) IBOutlet UIButton *likeBtn;


@end
