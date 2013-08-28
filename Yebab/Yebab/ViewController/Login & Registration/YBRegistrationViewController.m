//
//  YBRegistrationViewController.m
//  Yebab
//
//  Created by xicom-213 on 4/4/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import "YBRegistrationViewController.h"
#import "YBEditProfileViewController.h"
#import "YBLoginViewController.h"
#import "YBSelectInterestViewController.h"
#import "YBInviteFriendViewController.h"

@interface YBRegistrationViewController ()

@end
NSString* USER_ID;

@implementation YBRegistrationViewController

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
    [bgScroll setContentSize:CGSizeMake(320, 568)];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [bgScroll setContentOffset:CGPointZero];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Facebook Login handler
/*
 * Author:  Sudhanshu Srivastava
 * Purpose: Here we handle facebook login action.
 * Date:    29Jan2013
 */
-(IBAction)facebookBtnPressed:(id)sender{
    [Connections showGlobalProgressHUDWithTitle:@"Connecting Facebook..."];
    loginOption = @"facebook";
    commonFunction *func = [[commonFunction alloc] init];
    func.delegate = self;
    [func fbLogin];
}
#pragma mark - Twitter Login handler
/*
 * Author:  Vipul Singhania
 * Purpose: Here we handle twitter login action.
 * Date:    29Jan2013
 */
-(IBAction)twitterBtnPressed:(id)sender{
    loginOption = @"twitter";
    [Connections showGlobalProgressHUDWithTitle:@"Connecting Twitter..."];
    commonFunction *func  = [[commonFunction alloc] init];
    func.delegate = self;
    [func performSelector:@selector(twitterLogin:) withObject:self afterDelay:0.0f];
}
-(IBAction)emailBtnPressed:(id)sender{
    
    YBEditProfileViewController *controller = [[YBEditProfileViewController alloc] initWithNibName:@"YBEditProfileViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)loginBtnPressed:(id)sender{

     /* 
     //[[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil];
  
    YBInviteFriendViewController *controller = [[YBInviteFriendViewController alloc] initWithNibName:@"YBInviteFriendViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
  */
   
    YBLoginViewController *controller = [[YBLoginViewController alloc] initWithNibName:@"YBLoginViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];

  
}
#pragma mark - LoginDelegate
-(void)validateUserAccount:(NSDictionary*)user{
    
    NSLog(@"validate user Account: %@",user);
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:user];
    if ([loginOption isEqualToString:@"facebook"]) {
        [dic setObject:@"facebook" forKey:@"user_type"];
        NSDictionary *responseDic = (NSDictionary*)[commonFunction formatUserDic:dic];
        if ([[responseDic allKeys] containsObject:@"facebook_id"]) {
            NSLog(@"facebook_id: %@",[responseDic objectForKey:@"facebook_id"]);
            Connections *connection = [[Connections alloc] init];
            [connection setDelegate:self];
            [connection sendRequestWithPath:[NSString stringWithFormat:@"register/facebook"] andParameters:[NSDictionary dictionaryWithObjectsAndKeys:[responseDic objectForKey:@"facebook_id"],@"facebookId",[responseDic objectForKey:@"facebook_access_token"],@"accessToken", nil] showLoader:YES];
        }
    }else if ([loginOption isEqualToString:@"twitter"]){
        if ([[user allKeys] count]) {
             [dic setObject:@"twitter" forKey:@"user_type"];
            
            NSDictionary *responseDic = (NSDictionary*)[commonFunction formatUserDic:dic];
            NSLog(@"oauth token: %@ and oauth token secret:%@, oauth verifier: %@",[DMTwitter shared].oauth_token,[DMTwitter shared].oauth_token_secret,[DMTwitter shared].oauth_verifier);
            NSLog(@"twitter response token: %@, secret:%@, verifier:%@",TWITTER_OAUTH_TOKEN,TWITTER_OAUTH_SECRET,TWITTER_OAUTH_VERIFIER);
            Connections *connection = [[Connections alloc] init];
            [connection setDelegate:self];
            [connection sendRequestWithPath:[NSString stringWithFormat:@"register/twitter"] andParameters:[NSDictionary dictionaryWithObjectsAndKeys:[DMTwitter shared].oauth_token,@"oauthToken",[DMTwitter shared].oauth_token_secret,@"oauthTokenSecret",[DMTwitter shared].oauth_verifier,@"oauthVerfierToken",[responseDic objectForKey:@"twitter_id"],@"twitterId", nil] showLoader:YES];
        }
    }   
}
#pragma mark - Connection Delegate
-(void)connectionDidRecievedResponse:(BOOL)isSuccess withData:(id)data andMessage:(NSString *)message{
    [Connections dismissGlobalHUD];
    NSLog(@"data:%@",data);

    if (isSuccess) {
        NSLog(@"success");
        if ([[data objectForKey:@"Status"]isEqual: @"InComplete"]) {
            
            YBEditProfileViewController *controller = [[YBEditProfileViewController alloc] initWithNibName:@"YBEditProfileViewController" bundle:nil];
            controller.userdetailsDic = [data mutableCopy];
            [self.navigationController pushViewController:controller animated:YES];
        }
        else if([[data objectForKey:@"Status"]isEqual: @"partiallyComplete"]){
            
            YBSelectInterestViewController *controllerFollow = [[YBSelectInterestViewController alloc] initWithNibName:@"YBSelectInterestViewController" bundle:nil];
            [self.navigationController pushViewController:controllerFollow animated:YES];
        }
        else if([[data objectForKey:@"Status"]isEqual: @"Complete"]){
            
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil];
    }
    }else{
        NSLog(@"failure");
    }
}
#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
