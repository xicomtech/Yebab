//
//  commonFunction.m
//  shareHappiness
//
//  Created by Xicom on 12/02/13.
//  Copyright (c) 2013 Xicom. All rights reserved.
//

#import "commonFunction.h"
#import "Connections.h"
#import "YBAppDelegate.h"

BOOL IS_UPLOADING;
NSDictionary* SHARE_DIC;
@implementation commonFunction
@synthesize delegate;

static commonFunction *_commonFunction;

/*
 * Author:   Vipul Singhania
 * Purpose:  Create common function object
 * Date:   11Sept2012
 */
+ (commonFunction*)commonFun {
    if (_commonFunction == nil) {
        _commonFunction = [[commonFunction alloc] init];
    }
    return _commonFunction;
}

#pragma mark - Facebook Login handler
/*
 * Author:  Sudhanshu Srivastava
 * Purpose: Here we handle facebook login action.
 * Date:    29Jan2013
 */
- (void)fbLogin{
    [Connections showGlobalProgressHUDWithTitle:@"Connecting Facebook..."];
    
    YBAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (appDelegate.fbSession == nil || !appDelegate.fbSession.isOpen) {
        appDelegate.fbSession = [[FBSession alloc] initWithPermissions:FB_PERMISSION_ARR];
    }
    
    if (appDelegate.fbSession.state == FBSessionStateCreatedTokenLoaded || appDelegate.fbSession.state == FBSessionStateCreated) {
        [appDelegate.fbSession openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            [FBSession setActiveSession:appDelegate.fbSession];
            [self loadFBDetails];
        }];
    }else if (appDelegate.fbSession.state == FBSessionStateOpen){
        [FBSession setActiveSession:appDelegate.fbSession];
        [self loadFBDetails];
    }
}

/*
 * Author:  Sudhanshu Srivastava
 * Purpose: Here we load user details from facebook.
 * Date:    30Jan2013
 */
-(void)loadFBDetails {
    YBAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (appDelegate.fbSession.isOpen) {
        NSLog(@"open");
        [[FBRequest requestForGraphPath:@"me?fields=id,name,username,first_name,last_name,location,hometown,gender,bio,birthday,email"]
         startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *result, NSError *error)
         {
             // Did everything come back okay with no errors?
             if (!error && result)
             {
                 //NSLog(@"result: %@", result);
                 [self.delegate validateUserAccount:result];
             }else {
                 UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Error!" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [al show];
             }
         }];
    }else {
        NSLog(@"not open");
        [Connections dismissGlobalHUD];
    }
}

/*
 * Author:  Vipul Singhania
 * Purpose: Here we handle twiiter login action.
 * Date:    13Feb2013
 */
- (void)twitterLogin:(UIViewController *)controller{
    
    if ([DMTwitter shared].oauth_token_authorized) {
        [[DMTwitter shared] validateTwitterCredentialsWithCompletition:^(BOOL credentialsAreValid, NSDictionary *userData) {
            if (credentialsAreValid){
                [self.delegate validateUserAccount:userData];
            }
        }];
    }else{
        // prompt login
        [[DMTwitter shared] newLoginSessionFrom:controller.navigationController
           progress:^(DMOTwitterLoginStatus currentStatus) {
               NSLog(@"current status = %@",[commonFunction readableCurrentLoginStatus:currentStatus]);
           } completition:^(NSString *screenName, NSString *user_id, NSError *error) {
               
               if (error != nil) {
                   NSLog(@"Twitter login failed: %@",error);
               } else {
                   NSLog(@"Welcome %@!",screenName);
                   
                   // store our auth data so we can use later in other sessions
                   [[DMTwitter shared] saveCredentials];
                   
                   // you can use this call in order to validate your credentials
                   // or get more user's info data
                   [[DMTwitter shared] validateTwitterCredentialsWithCompletition:^(BOOL credentialsAreValid, NSDictionary *userData) {
                       if (credentialsAreValid){
                           [self.delegate validateUserAccount:userData];
                       }
                   }];
               }
           }];
    }
}
/*
 * Author:  Vipul Singhania
 * Purpose: Here we handle twitter login action.
 * Date:    29Jan2013
 */
+ (NSString *) readableCurrentLoginStatus:(DMOTwitterLoginStatus) cstatus {
    switch (cstatus) {
        case DMOTwitterLoginStatus_PromptUserData:
            return @"Prompt for user data and request token to server";
        case DMOTwitterLoginStatus_RequestingToken:
            return @"Requesting token for current user's auth data...";
        case DMOTwitterLoginStatus_TokenReceived:
            return @"Token received from server";
        case DMOTwitterLoginStatus_VerifyingToken:
            return @"Verifying token...";
        case DMOTwitterLoginStatus_TokenVerified:
            return @"Token verified";
        default:
            return @"[unknown]";
    }
}
/*
 * Author:  Sudhanshu Srivastava
 * Purpose: To validate email.
 * Date:    05Feb2013
 */
+(BOOL)validateEmail:(NSString *)email
{
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", EMAIL_REG_EXP];
    BOOL isValid = [emailTest evaluateWithObject:email];
    return isValid;
}

/*
 * Author:  Utkarsh Goel
 * Purpose: To validate String.
 * Date:    22Apr2013
 */
+(BOOL)isValidString:(NSString *)text
{
    NSString *trimmedText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(trimmedText.length>0){
        return YES;
    }
    return NO;
}

+(BOOL)isValidUsername:(NSString *)text
{
    NSString *trimmedText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    trimmedText = [trimmedText stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PASSWORD_REG_EXP];
    BOOL isValid = [passwordTest evaluateWithObject:trimmedText];
    return isValid;
}

/*
 * Author:  Utkarsh Goel
 * Purpose: To validate url's.
 * Date:    22Apr2013
 */
- (BOOL) validateUrl: (NSString *) candidate {
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

/*
 * Author:  Utkarsh Goel
 * Purpose: To show AlertView.
 * Date:    08Apr2013
 */
+(void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString*)message andDelegate:(id)object{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:object cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alert show];
}

/*
 * Author:  Sudhanshu Srivastava
 * Purpose: Here we format user dictionary as per signup screen requirement.
 * Date:    30Jan2013
 */
+(NSDictionary*)formatUserDic:(NSDictionary*)userDic {
    NSMutableDictionary *mUserDic = [NSMutableDictionary dictionary];
    NSString *loginOption = [userDic objectForKey:@"user_type"];
    
    if ([loginOption isEqualToString:@"facebook"]) {
        [mUserDic setObject:([userDic objectForKey:@"id"])?[userDic objectForKey:@"id"]:@""           forKey:@"facebook_id"];
        [mUserDic setObject:[(YBAppDelegate*)[[UIApplication sharedApplication] delegate] fbSession].accessToken     forKey:@"facebook_access_token"];
        /*[mUserDic setObject:([userDic objectForKey:@"first_name"])?[userDic objectForKey:@"first_name"]:@"" forKey:@"First Name"];
        [mUserDic setObject:([userDic objectForKey:@"last_name"])?[userDic objectForKey:@"last_name"]:@""   forKey:@"Last Name"];
        [mUserDic setObject:([userDic objectForKey:@"email"])?[userDic objectForKey:@"email"]:@""           forKey:@"Email Address"];
        [mUserDic setObject:([userDic objectForKey:@"username"])?[userDic objectForKey:@"username"]:@""     forKey:@"Username"];
        [mUserDic setObject:([[userDic objectForKey:@"location"] objectForKey:@"name"])?[[userDic objectForKey:@"location"] objectForKey:@"name"]:@""     forKey:@"country"];
        [mUserDic setObject:([[userDic objectForKey:@"hometown"] objectForKey:@"name"])?[[userDic objectForKey:@"hometown"] objectForKey:@"name"]:@""     forKey:@"hometown"];
        [mUserDic setObject:([userDic objectForKey:@"bio"])?[userDic objectForKey:@"bio"]:@""     forKey:@"about"];
        
        [mUserDic setObject:@".jpg"     forKey:@"photo_name"];
        [mUserDic setObject:@"1"    forKey:@"facebook_login"];
        [mUserDic setObject:@"1"    forKey:@"status"];
        [mUserDic setObject:@"facebook" forKey:@"login_with"];
        
        [mUserDic setObject:@"" forKey:@"Password"];
        [mUserDic setObject:@"" forKey:@"Confirm Password"];
        [mUserDic setObject:([userDic objectForKey:@"gender"])?[[userDic objectForKey:@"gender"] capitalizedString]:@"" forKey:@"Gender"];
        
        if (([userDic objectForKey:@"birthday"])) {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"MM/dd/yyyy"];
            NSDate *dt = [df dateFromString:[userDic objectForKey:@"birthday"]];
            [df setDateFormat:@"dd/MM/yyyy"];
            [mUserDic setObject:[df stringFromDate:dt]     forKey:@"Birthday"];
        }else {
            [mUserDic setObject:@""     forKey:@"Birthday"];
        }*/
    }else{
        [mUserDic setObject:([userDic objectForKey:@"id_str"])?[userDic objectForKey:@"id_str"]:@""           forKey:@"twitter_id"];
        /*[mUserDic setObject:([userDic objectForKey:@"name"])?[userDic objectForKey:@"name"]:@"" forKey:@"First Name"];
        [mUserDic setObject:@""     forKey:@"Last Name"];
        [mUserDic setObject:@""     forKey:@"Email Address"];
        [mUserDic setObject:([userDic objectForKey:@"screen_name"])?[userDic objectForKey:@"screen_name"]:@""     forKey:@"Username"];
        [mUserDic setObject:([userDic objectForKey:@"description"])?[userDic objectForKey:@"description"]:@""     forKey:@"about"];
        [mUserDic setObject:([userDic objectForKey:@"location"])?[userDic objectForKey:@"location"]:@""     forKey:@"hometown"];
        
        
        [mUserDic setObject:@".jpeg"     forKey:@"photo_name"];
        [mUserDic setObject:@"1"    forKey:@"twitter_login"];
        [mUserDic setObject:@"1"    forKey:@"status"];
        [mUserDic setObject:@"twitter" forKey:@"login_with"];
        
        
        [mUserDic setObject:@"" forKey:@"Password"];
        [mUserDic setObject:@"" forKey:@"Confirm Password"];
        [mUserDic setObject:([userDic objectForKey:@"gender"])?[[userDic objectForKey:@"gender"] capitalizedString]:@"" forKey:@"Gender"];
        
        if (([userDic objectForKey:@"birthday"])) {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"MM/dd/yyyy"];
            NSDate *dt = [df dateFromString:[userDic objectForKey:@"birthday"]];
            [df setDateFormat:@"dd/MM/yyyy"];
            [mUserDic setObject:[df stringFromDate:dt]     forKey:@"Birthday"];
        }else {
            [mUserDic setObject:@""     forKey:@"Birthday"];
        }*/
    }
    [mUserDic setObject:loginOption forKey:@"user_type"];
    
    return mUserDic;
}
@end
