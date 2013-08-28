//
//  categoryCell.m
//  Yebab
//
//  Created by Xicom on 05/06/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import "categoryCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation categoryCell
@synthesize  delegate;

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
-(void)loadData:(NSArray *)categoryArr{
    self.categoryView1.clipsToBounds = YES;
    self.categoryView1.layer.cornerRadius = 8.0f;
    self.categoryView2.clipsToBounds = YES;
    self.categoryView2.layer.cornerRadius = 8.0f;
    self.categoryView3.clipsToBounds = YES;
    self.categoryView3.layer.cornerRadius = 8.0f;

    switch ([categoryArr count]) {
        case 1:{
            NSString *catName = [[categoryArr objectAtIndex:0] objectForKey:@"categoryName"];
            [self.categoryImg1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[catName lowercaseString]]]];
            [self.categoryBtn1 setTag:[[[categoryArr objectAtIndex:0] objectForKey:@"categoryId"] intValue]];
            [self.categoryLabel1 setText:catName];
            self.categoryView2.hidden = YES;
            self.categoryView3.hidden = YES;
        }
            break;
        case 2:{
        
            NSString *catName1 = [[categoryArr objectAtIndex:0] objectForKey:@"categoryName"];
            [self.categoryImg1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[catName1 lowercaseString]]]];
            [self.categoryBtn1 setTag:[[[categoryArr objectAtIndex:0] objectForKey:@"categoryId"] intValue]];
            [self.categoryLabel1 setText:catName1];
            
            NSString *catName2 = [[categoryArr objectAtIndex:1] objectForKey:@"categoryName"];
            [self.categoryImg2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[catName2 lowercaseString]]]];
            [self.categoryBtn2 setTag:[[[categoryArr objectAtIndex:1] objectForKey:@"categoryId"] intValue]];
            [self.categoryLabel2 setText:catName2];
            self.categoryView3.hidden = YES;
        }
            break;
        case 3:{
            NSString *catName = [[categoryArr objectAtIndex:0] objectForKey:@"categoryName"];
            [self.categoryImg1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[catName lowercaseString]]]];
            [self.categoryBtn1 setTag:[[[categoryArr objectAtIndex:0] objectForKey:@"categoryId"] intValue]];
            [self.categoryLabel1 setText:catName];
            
            NSString *catName2 = [[categoryArr objectAtIndex:1] objectForKey:@"categoryName"];
            [self.categoryImg2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[catName2 lowercaseString]]]];
            [self.categoryBtn2 setTag:[[[categoryArr objectAtIndex:1] objectForKey:@"categoryId"] intValue]];
            [self.categoryLabel2 setText:catName2];
            
            NSString *catName3 = [[categoryArr objectAtIndex:2] objectForKey:@"categoryName"];
            [self.categoryImg3 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[catName3 lowercaseString]]]];
            [self.categoryBtn3 setTag:[[[categoryArr objectAtIndex:2] objectForKey:@"categoryId"] intValue]];
            [self.categoryLabel3 setText:catName3];
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)categoryBtnTapped:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [self.delegate categoryAction:btn.tag];
    
    
}
@end
