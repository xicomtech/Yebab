//
//  YBAppDelegate.m
//  Yebab
//
//  Created by xicom-213 on 4/4/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import "YBAppDelegate.h"

#import "YBRegistrationViewController.h"
#import "DMTwitterCore.h"


@implementation YBAppDelegate
@synthesize fbSession = _fbSession;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFinished) name:@"LoginSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutFinished) name:@"LogoutSuccess" object:nil];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    USER_ID = [userDefault objectForKey:@"userId"];
    if (USER_ID != nil) {
        [self.navigationController setNavigationBarHidden:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil];
    }else{
        YBRegistrationViewController *controller = [[YBRegistrationViewController alloc] initWithNibName:@"YBRegistrationViewController" bundle:nil];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
        self.window.rootViewController = self.navigationController;
    }
    [self.window makeKeyAndVisible];
    
    return YES;
}
/*
 * Author:  Sudhanshu Srivastava
 * Purpose: To handle openURL callback from Facebook & Twitter.
 * Date:    29Jan2013
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"application open Url source: %@",url);
    // attempt to extract a token from the url
    NSString *urlString = [NSString stringWithFormat:@"%@",url];
    if ([urlString hasPrefix:@"tw"]) {
        return [[DMTwitter shared].currentLoginController handleTokenRequestResponseURL:url];
    }else if([urlString hasPrefix:@"fb"]) {
        return [self.fbSession handleOpenURL:url];
    }
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [self.fbSession handleDidBecomeActive];
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Login Notification Methods
-(void)loginFinished
{    
	tabBarcontroller=[[GGTabarController alloc] initWithNibName:@"GGTabarController" bundle:nil];
    [tabBarcontroller setWantsFullScreenLayout:YES];
    self.window.rootViewController = tabBarcontroller;
    [self.window makeKeyAndVisible];

}
-(void)logoutFinished
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:@"userId"];
    [userDefault synchronize];
    NSLog(@"%@",self.navigationController.viewControllers);
    if (![self.navigationController.viewControllers count]) {
        YBRegistrationViewController *controller = [[YBRegistrationViewController alloc] initWithNibName:@"YBRegistrationViewController" bundle:nil];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
        self.window.rootViewController = self.navigationController;

    }
    [self.navigationController popToRootViewControllerAnimated:NO];
    self.window.rootViewController = self.navigationController;
}

@end
