//
//  PFTabarController.m
//  PalFinds
//
//  Created by utkarsh Goel on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GGTabarController.h"



@implementation GGTabarController
@synthesize tabarController=_tabarController;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [_tabarController.tabBar setBackgroundImage:[UIImage imageNamed:@"bottom_tabs.png"]];
    [_tabarController.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"home_tab.png"]];
    [_tabarController.tabBar setTintColor:[UIColor clearColor]];
    [self.view addSubview:_tabarController.view];
    //[_tabarController setSelectedIndex:2];  //To show desired tab at first.
}
#pragma mark -
#pragma mark UITabBarControllerDelegate methods


// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	switch (_tabarController.selectedIndex) {
        case 0:
            [_tabarController.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"home_tab.png"]];
            break;
        case 1:
            [_tabarController.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"discover_tab.png"]];
            break;
        case 2:
            [_tabarController.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"camera_tab.png"]];
            break;
        case 3:
            [_tabarController.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"store_tab.png"]];
            break;
        case 4:
            [_tabarController.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"me_tab.png"]];
            break;
            
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}
- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[_tabarController viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
	[_tabarController viewWillDisappear:animated];
	[super viewWillDisappear:animated];
}
/*
- (void)viewDidUnload {
    self.tabarController=nil;
	[super viewDidUnload];
}
*/
/*
- (void)dealloc {
	SAFE_RELEASE(_tabarController);
    [super dealloc];
}

*/
@end
