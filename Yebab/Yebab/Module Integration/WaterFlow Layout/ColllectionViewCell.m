//
//  ColllectionViewCell.m
//  WaterFlowDisplay
//
//  Created by B.H.Liu on 12-8-22.
//  Copyright (c) 2012年 Appublisher. All rights reserved.
//

#import "ColllectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ColllectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //UIView *testView = [[UIView alloc] initWithFrame:self.contentView.frame];
        self.contentView.clipsToBounds = YES;

        self.contentView.layer.cornerRadius = 4.0f;
        
        self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.contentView.layer.borderWidth = 1.0f;
        UIImageView *asyncimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height-46)];
        [self.contentView addSubview:asyncimageView];
        //_imageView = asyncimageView;
        
        UIImageView *line= [[UIImageView alloc] initWithFrame:CGRectMake(0, asyncimageView.frame.size.height, frame.size.width , 1.5f)];
        [line setImage:[UIImage imageNamed:@"line.png"]];
        line.alpha = 0.5f;
        line.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:line];
        
        UIImageView *userImg= [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, asyncimageView.frame.size.height+ 8.0f, 30.0f, 30.f)];
        [userImg setImage:[UIImage imageNamed:@"add_pic.png"]];
        userImg.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:userImg];

        //self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        //self.imageView.backgroundColor = [UIColor grayColor];
        
        UILabel *storeNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(40.0f,asyncimageView.frame.size.height + 6.0f, 108.0f, 16)];
        storeNameLbl.textAlignment = NSTextAlignmentLeft;
        storeNameLbl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        storeNameLbl.backgroundColor = [UIColor clearColor];
        storeNameLbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:11.0f];
        storeNameLbl.text = @"czcsdfdsfsf";
        
        UILabel *cityLbl = [[UILabel alloc]initWithFrame:CGRectMake(40.0f,storeNameLbl.frame.size.height + storeNameLbl.frame.origin.y, 108.0f, 16)];
        cityLbl.textAlignment = NSTextAlignmentLeft;
        cityLbl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        cityLbl.backgroundColor = [UIColor clearColor];
        cityLbl.font = [UIFont fontWithName:@"Helvetica" size:11.0f];
        cityLbl.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:170/255.0f alpha:1.0f];
        cityLbl.text = @"meow~";

        [self.contentView addSubview:storeNameLbl];
        [self.contentView addSubview:cityLbl];

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
