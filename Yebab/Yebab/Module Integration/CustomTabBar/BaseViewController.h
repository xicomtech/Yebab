//
//  BaseViewController.h
//  raisedCenterTabBarSample
//
//  Created by utkarsh Goel on 06/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface BaseViewController : UITabBarController
{
}

// Create a view controller and setup it's tab bar item with a title and image
//-(UIViewController*) viewControllerWithTabTitle:(NSString*)title image:(UIImage*)image;
-(UINavigationController*) viewControllerWithTabTitle:(NSString*) title image:(UIImage*)image index:(int)tabButtonIndex;

// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage;
-(void) changeCenterImg:(BOOL)isSelected;


@end
