//
//  tabBarMediator.m
//  raisedCenterTabBarSample
//
//  Created by utkarsh Goel on 06/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "tabBarMediator.h"



@implementation tabBarMediator

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    	
	self.viewControllers = [NSArray arrayWithObjects:
                            [self viewControllerWithTabTitle:@"" image:[UIImage imageNamed:@""] index:0],
                            [self viewControllerWithTabTitle:@"" image:[UIImage imageNamed:@""] index:1],
                            [self viewControllerWithTabTitle:@"" image:[UIImage imageNamed:@""] index:2],
                            [self viewControllerWithTabTitle:@"" image:[UIImage imageNamed:@""] index:3],
                            [self viewControllerWithTabTitle:@"" image:[UIImage imageNamed:@""] index:4],
                            nil];

	//[self willAppearIn:[[self.tabBarController viewControllers] objectAtIndex:0]];
}

-(void)willAppearIn:(UIViewController *)viewController
{
	//[self addCenterButtonWithImage:[UIImage imageNamed:@"checkin-normal.png"] highlightImage:nil];
   // [self.tabBarController setSelectedIndex:3];
}
/*
-(void)changeCenterImage:(BOOL)isSelected{
	[self changeCenterImg:isSelected];
}
 */
@end
