//
//  YBMeViewController.m
//  Yebab
//
//  Created by Xicom on 07/06/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import "YBMeViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface YBMeViewController ()

@end

@implementation YBMeViewController

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
    self.userInfoView.clipsToBounds = YES;
    self.userInfoView.layer.cornerRadius = 5.0f;
    self.userInfoView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.userInfoView.layer.borderWidth = 1.0f;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.title = @"User Name";
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbutton setFrame:CGRectMake(0, 0, 50, 30)];
    [rightbutton setImage:[UIImage imageNamed:@"settings_button.png"] forState:UIControlStateNormal];
    //[rightbutton addTarget:self action:@selector(nextBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    //self.navigationItem.rightBarButtonItem = nextBtn;
    
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton setFrame:CGRectMake(0, 0, 51, 30)];
    [leftbutton setImage:[UIImage imageNamed:@"add_user.png"] forState:UIControlStateNormal];
    //[leftbutton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem = backBtn;
    [self tabChanged:self.followingBtn];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"me_tab.png"]];
}


- (void)viewDidUnload {
    [self setUserInfoView:nil];
    [self setFollowingBtn:nil];
    [self setYouBtn:nil];
    [self setEmailBtn:nil];
    [self setPhotoLbl:nil];
    [self setAlbumLbl:nil];
    [self setFollowerLbl:nil];
    [self setFollowingLbl:nil];
    [self setUserNameLbl:nil];
    [super viewDidUnload];
}
- (IBAction)tabChanged:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [self.followingBtn setSelected:NO];
    [self.youBtn setSelected:NO];
    [self.emailBtn setSelected:NO];
    
    if ([btn isSelected]) {
        [btn setSelected:NO];
    }else{
        [btn setSelected:YES];
    }
}
@end
