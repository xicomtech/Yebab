//
//  YBLoginViewController.m
//  Yebab
//
//  Created by xicom-213 on 4/11/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import "YBLoginViewController.h"
#import "YBAppDelegate.h"
#import "YBSelectInterestViewController.h"

@interface YBLoginViewController ()

@end
NSString* USER_ID;
BOOL SHOW_LOADER;
@implementation YBLoginViewController

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
    // Do any additional setup after loading the view from its nib.
    
    [loginFieldView setCenter:self.view.center];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar_logo.png"] forBarMetrics:UIBarMetricsDefault];
//     [self.navigationItem setHidesBackButton:YES];
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton setFrame:CGRectMake(0, 0, 51, 30)];
    [leftbutton setImage:[UIImage imageNamed:@"back_button.png"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem = backBtn;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)backButtonTapped{
    NSLog(@"back button Pressed");
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)loginButtonPressed:(id)sender{
    NSLog(@"login Btn Pressed");
    if (![usernameTxt.text length]) {
        [commonFunction showAlertViewWithTitle:@"Alert!" andMessage:@"Username can not be blank." andDelegate:nil];
    }else if (![passwordTxt.text length]){
        [commonFunction showAlertViewWithTitle:@"Alert!" andMessage:@"Password can not be blank." andDelegate:nil];
    }else{
        Connections *connection = [[Connections alloc] init];
        [connection setDelegate:self];
        [connection sendRequestWithPath:[NSString stringWithFormat:@"register/username"] andParameters:[NSDictionary dictionaryWithObjectsAndKeys:usernameTxt.text,@"username",passwordTxt.text,@"password",nil] showLoader:YES];
    }    
}
#pragma mark - Connection Delegate
-(void)connectionDidRecievedResponse:(BOOL)isSuccess withData:(id)data andMessage:(NSString *)message{
    
    NSLog(@"%@",data);
    //if (isSuccess) {
    if ([[data objectForKey:@"Status"]isEqual: @"InComplete"]) {
            
        [commonFunction showAlertViewWithTitle:[NSString stringWithFormat:@"%@",[data objectForKey:@"message"]]andMessage:message andDelegate:nil];
          
    }else if([[data objectForKey:@"Status"]isEqual: @"partiallyComplete"]){
        YBSelectInterestViewController *controllerFollow = [[YBSelectInterestViewController alloc] initWithNibName:@"YBSelectInterestViewController" bundle:nil];
        [self.navigationController pushViewController:controllerFollow animated:YES];
        
    }else if([[data objectForKey:@"Status"]isEqual: @"Complete"]){
        
        USER_ID = [data objectForKey:@"userId"];///@"18";
        SHOW_LOADER = YES;
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:USER_ID forKey:@"userId"];
        [userDefault synchronize];
        
        NSLog(@"%@", USER_ID);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil];
    }else{
    [commonFunction showAlertViewWithTitle:[NSString stringWithFormat:@"%@",[data objectForKey:@"message"]]andMessage:message andDelegate:nil];
   }
   /// }
}
#pragma mark -UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == usernameTxt)
        [passwordTxt becomeFirstResponder];
    else
		[passwordTxt resignFirstResponder];
    
    if ([textField returnKeyType] == UIReturnKeyDone)
        [self performSelector:@selector(loginButtonPressed:) withObject:nil afterDelay:0.0];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
