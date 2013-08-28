//
//  YBRegistrationViewController.h
//  Yebab
//
//  Created by xicom-213 on 4/4/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connections.h"
#import "commonFunction.h"
#import <MessageUI/MessageUI.h>

@interface YBRegistrationViewController : UIViewController<LoginDelegate,ConnectionsDelegate>{
    IBOutlet UIScrollView *bgScroll;
    NSString *loginOption;
}

-(IBAction)facebookBtnPressed:(id)sender;
-(IBAction)twitterBtnPressed:(id)sender;
-(IBAction)emailBtnPressed:(id)sender;
-(IBAction)loginBtnPressed:(id)sender;

@end
