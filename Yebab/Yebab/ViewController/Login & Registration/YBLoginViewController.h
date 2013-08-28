//
//  YBLoginViewController.h
//  Yebab
//
//  Created by xicom-213 on 4/11/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connections.h"
#import "commonFunction.h"


@interface YBLoginViewController : UIViewController<ConnectionsDelegate,UITextFieldDelegate>{
    IBOutlet UIView *loginFieldView;
    IBOutlet UITextField *usernameTxt;
    IBOutlet UITextField *passwordTxt;
}
-(IBAction)loginButtonPressed:(id)sender;

@end
