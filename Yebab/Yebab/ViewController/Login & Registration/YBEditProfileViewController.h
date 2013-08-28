//
//  YBEditProfileViewController.h
//  Yebab
//
//  Created by xicom-213 on 4/5/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "commonFunction.h"
#import "Globals.h"
#import "YBSelectInterestViewController.h"

@interface YBEditProfileViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,ConnectionsDelegate>{
    IBOutlet UIScrollView *bgScroll;
    IBOutlet UIView       *storeRegisterView;
    IBOutlet UIButton     *storeChkBtn;
    
/****** Profile Pic View ******/
    IBOutlet UIButton *userPicBtn;
    
/****** Profile Details View ******/
    IBOutlet UITextField *nameTxt;
    IBOutlet UITextField *usernameTxt;
    IBOutlet UITextField *emailTxt;
    IBOutlet UITextField *passwordTxt;
    IBOutlet UITextField *confirmPasswordTxt;
    IBOutlet UITextField *countryTxt;
    IBOutlet UITextView  *bioTxt;
    IBOutlet UITextField *websiteTxt;
    
/****** Store Register View ******/
    IBOutlet UIButton    *storePicBtn;
    IBOutlet UITextField *storeNameTxt;
    IBOutlet UITextField *storeCityTxt;
    IBOutlet UITextField *storePhoneTxt;
    IBOutlet UITextField *storeMobileTxt;
    IBOutlet UITextField *storeAddressTxt;
    
    NSMutableDictionary *userdetailsDic;
    
    UIActionSheet *actionSheet;
    UIPickerView *countryPicker;
    NSArray *countriesList;
    NSArray *countries_code_list;
    UIToolbar* toolbar;
    IBOutlet UIImageView *countryFlag;
    Connections *connectionObj;
    BOOL shouldPost;
}
@property(nonatomic,retain)  NSMutableDictionary *userdetailsDic;
-(IBAction)storeChkBtnTapped:(id)sender;
-(IBAction)userPictureBtnClicked:(id)sender;
-(IBAction)storePictureBtnClicked:(id)sender;
-(void)registerUser;
-(BOOL)valiadateFieldsForStoreFormAlso:(BOOL)status;

@end
