//
//  userProfileViewController.m
//  Yebab
//
//  Created by Xicom on 11/06/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import "userProfileViewController.h"

@interface userProfileViewController ()

@end

@implementation userProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.title = @"User Name";
    [self tabChanged:[self.tabBtnCollection objectAtIndex:0]];
    
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton setFrame:CGRectMake(0, 0, 51, 30)];
    [leftbutton setImage:[UIImage imageNamed:@"back_button.png"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem = backBtn;
}
-(void)backButtonTapped{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPhotoLbl:nil];
    [self setAlbumLbl:nil];
    [self setFollowingLbl:nil];
    [self setFollowerLbl:nil];
    [self setTabBtnCollection:nil];
    [super viewDidUnload];
}

- (IBAction)tabChanged:(id)sender {
    for (UIButton *btn in self.tabBtnCollection) {
        [btn setSelected:NO];
    }
    UIButton *senderBtn = (UIButton *)sender;
    if ([senderBtn isSelected]) {
        [senderBtn setSelected:NO];
    }else{
        [senderBtn setSelected:YES];
    }
}
@end
