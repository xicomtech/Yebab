//
//  PFTabarController.h
//  PalFinds
//
//  Created by utkarsh Goel on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Globals.h"
#import "tabBarMediator.h"

@interface GGTabarController : UIViewController<UITabBarControllerDelegate> {
    IBOutlet tabBarMediator *_tabarController;
}
@property(nonatomic, retain) tabBarMediator *tabarController;

@end
