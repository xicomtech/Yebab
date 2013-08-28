//
//  ExistingAlbumViewController.h
//  Yebab
//
//  Created by Virendra on 23/07/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connections.h"
#import "OverlayViewController.h"


@interface ExistingAlbumViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,ConnectionsDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,CameraImageDelegate>{
    
    NSString *requestType;
    NSArray *existingAlbumList, *currencyListArray ;
    NSMutableArray *existAlbumArray ;
    
    BOOL isShowSheet;
    UIImage *image ;
    OverlayViewController *overlay ;
    
    NSString *albumId ;
    UIImagePickerController *imagePicker ;
    NSString *imageUrlString ;
    NSURL *url  ;
    NSData *dataImage ;
    NSString *albumType ;
    int number ;

    UILabel *albumLabel ;
    int serviceCount ;
}
@property (nonatomic,retain)IBOutlet UILabel *albumLabel ;
@property (nonatomic,retain)NSString *albumId ;
@property (nonatomic,retain)NSData *dataImage ;
@property (nonatomic,retain)NSString *albumType ;

@property (nonatomic,retain)NSString *imageUrlString ;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *captionTextField;
@property (weak, nonatomic) IBOutlet UIButton *selectAlbumBtn;
@property (weak, nonatomic) IBOutlet UIButton *albumBtnClick;
@property (weak, nonatomic) IBOutlet UIButton *currencyButton ;

@property (nonatomic,retain)UIActionSheet *createAlbumActionSheet ;
@property (nonatomic,retain)UIPickerView *createAlbumPicker;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;


- (IBAction)existingAlbumList:(id)sender  ;
@end
