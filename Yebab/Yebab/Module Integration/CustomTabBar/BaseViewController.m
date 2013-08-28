//
//  BaseViewController.m
//  raisedCenterTabBarSample
//
//  Created by utkarsh Goel on 06/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "BaseViewController.h"
#import "YBHomeViewController.h"
#import "YBDiscoverViewController.h"
#import "YBStoreViewController.h"
#import "YBMeViewController.h"
#import "YBCameraViewController.h"
#import "ExistingAlbumViewController.h"

//#define NAV_BAR_COLOR [UIColor colorWithRed:62.0f/255.0f green:117.0f/255.0f blue:174.0f/255.0f alpha:1.0f]

@implementation BaseViewController


// Create a view controller and setup it's tab bar item with a title and image
-(UINavigationController*) viewControllerWithTabTitle:(NSString*) title image:(UIImage*)image index:(int)tabButtonIndex
{	
	if (tabButtonIndex == 0) {
		UINavigationController* naviController = [[UINavigationController alloc] init];
       
        YBHomeViewController *controller = [[YBHomeViewController alloc] initWithNibName:@"YBHomeViewController" bundle:nil];
        [naviController setViewControllers:[NSArray arrayWithObject:controller]];        
		naviController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:0];

		return naviController;
	}
	if (tabButtonIndex == 1) {
		UINavigationController* naviController = [[UINavigationController alloc] init];
        
        YBDiscoverViewController *controllerDiscover = [[YBDiscoverViewController alloc] initWithNibName:@"YBDiscoverViewController" bundle:nil];
        [naviController setViewControllers:[NSArray arrayWithObject:controllerDiscover]];
		naviController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:1];
        return naviController;
	}
	
	if (tabButtonIndex == 2) {
		UINavigationController* naviController = [[UINavigationController alloc] init];
 //       YBCameraViewController *controller = [[YBCameraViewController  alloc] initWithNibName:@"YBCameraViewController" bundle:nil];
        
        ExistingAlbumViewController *controller = [[ExistingAlbumViewController  alloc] initWithNibName:@"ExistingAlbumViewController" bundle:nil];
        [naviController setViewControllers:[NSArray arrayWithObject:controller]];
		naviController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:4];
		return naviController;
	}
	
	if (tabButtonIndex == 3) {
		UINavigationController* naviController = [[UINavigationController alloc] init];        
        YBStoreViewController *controller = [[YBStoreViewController alloc] initWithNibName:@"YBStoreViewController" bundle:nil];
        [naviController setViewControllers:[NSArray arrayWithObject:controller]];
		naviController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:3];
		return naviController;
	}
    
    if (tabButtonIndex == 4) {
		UINavigationController* naviController = [[UINavigationController alloc] init];
        
		YBMeViewController *controller = [[YBMeViewController  alloc] initWithNibName:@"YBMeViewController" bundle:nil];
        [naviController setViewControllers:[NSArray arrayWithObject:controller]];
		naviController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:4];

		return naviController;
	}
	
	UINavigationController* naviController = [[UINavigationController alloc] init];
    
	naviController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:0];
	return naviController;
}

// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
	UIImageView *centerImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkin-normal.png"]];
	centerImg.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
	centerImg.frame = CGRectMake(0.0, 0.0, centerImg.frame.size.width, centerImg.frame.size.height);
	centerImg.tag = 8;
	[centerImg setUserInteractionEnabled:NO];
	
	CGFloat heightDifference = centerImg.frame.size.height - self.tabBar.frame.size.height;
	if (heightDifference < 0)
		centerImg.center = self.tabBar.center;
	else
	{
		CGPoint center = self.tabBar.center;
		center.y = center.y - heightDifference/2.0;
		centerImg.center = center;
	}
	
  [self.view addSubview:centerImg];
	
}

-(void) changeCenterImg:(BOOL)isSelected{
	
	UIImageView *centerImg = (UIImageView*)[self.view viewWithTag:8];
	if (isSelected) {
		[centerImg setImage:[UIImage imageNamed:@"checkin-normal-select.png"]];
	}else {
		[centerImg setImage:[UIImage imageNamed:@"checkin-normal.png"]];
	}
}

@end
