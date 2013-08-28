//
//  YBCameraViewController.h
//  Yebab
//
//  Created by Xicom on 07/06/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connections.h"
#import "createAlbumViewController.h"

@interface YBCameraViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,ConnectionsDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,SecondViewControllerDelegate>{
    
    NSMutableArray *catogeryList;
    NSMutableString *categoryListId ;
    NSArray *albumList;
    NSString *requestType;
    BOOL isShowSheet;
    
    UIButton *selectAlbumButton ;
    UIButton *createAlbumButton ;
    UIPickerView *catogeryPicker ;
    UIActionSheet *catogeryActionSheet ;
    NSString *languageValueString ;
    
    NSArray *existingAlbumList ;
    NSArray *followerList ;
    
    UITextField *albumTxtFld;
    UIButton *addButton;
    NSMutableDictionary *typeDic ;
    NSMutableArray *followerArray ;
//    UIImage *image ;
    int catType ;
    BOOL addAlbum ;
    int typeValue ;
    BOOL userType ;
}
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *businessBtnCollection;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *shareBtnCollection;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *userBtnCollection;

@property (strong, nonatomic) IBOutlet UITextField *albumTxtFld;
@property (strong, nonatomic) IBOutlet UITextField *currencyTxtFld;
@property (strong, nonatomic) IBOutlet  UIButton *selectAlbumButton ;
@property (strong, nonatomic) IBOutlet UIButton *createAlbumButton, *addButton, *selectExistAlbumButton;

@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UITextField *captionTxt;
@property (strong, nonatomic) IBOutlet UIView *subUserView;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel ;
@property (strong, nonatomic) IBOutlet UIView *userTypeView ,*typeView ;
@property (strong, nonatomic) IBOutlet UIView *editAlbumView;
@property (strong, nonatomic)NSMutableArray *followerArray ;
@property (strong, nonatomic)NSMutableString *categoryListId ;

- (IBAction)selectAlbumBtnTapped:(id)sender;
- (IBAction)selectImgSourceBtnTapped:(id)sender;

- (IBAction)businessTypeBtnTapped:(id)sender;
- (IBAction)userTypeBtnTapped:(id)sender;
- (IBAction)shareTypeBtnTapped:(id)sender;

- (void)followerService ;
- (void)followerBtnTapped ;
@end
