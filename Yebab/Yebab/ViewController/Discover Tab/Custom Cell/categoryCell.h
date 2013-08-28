//
//  categoryCell.h
//  Yebab
//
//  Created by Xicom on 05/06/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol categoryCellDelegate
//-(void)connectionDidRecievedResponse:(BOOL)isSuccess withData:(id)data selected:(int)selected;

@optional
-(void)categoryAction:(NSInteger)btnTag;
@end

@interface categoryCell : UITableViewCell{
    id<categoryCellDelegate> delegate;

}
@property (strong, nonatomic) id<categoryCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *categoryView1;
@property (strong, nonatomic) IBOutlet UIView *categoryView2;
@property (strong, nonatomic) IBOutlet UIView *categoryView3;
- (IBAction)categoryBtnTapped:(id)sender;
-(void)loadData:(NSArray *)categoryArr;

@property (strong, nonatomic) IBOutlet UILabel *categoryLabel1;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel2;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel3;
@property (strong, nonatomic) IBOutlet UIButton *categoryBtn1;
@property (strong, nonatomic) IBOutlet UIButton *categoryBtn2;
@property (strong, nonatomic) IBOutlet UIButton *categoryBtn3;
@property (strong, nonatomic) IBOutlet UIImageView *categoryImg1;
@property (strong, nonatomic) IBOutlet UIImageView *categoryImg2;
@property (strong, nonatomic) IBOutlet UIImageView *categoryImg3;
@end
