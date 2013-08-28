//
//  ExistingAlbumViewController.m
//  Yebab
//
//  Created by Virendra on 23/07/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import "ExistingAlbumViewController.h"
#import "YBCameraViewController.h"

@interface ExistingAlbumViewController ()

@end

@implementation ExistingAlbumViewController
@synthesize albumId ,imageUrlString,albumType,albumLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.title = @"Edit Album";
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbutton setFrame:CGRectMake(0, 0, 50, 30)];
    [rightbutton setImage:[UIImage imageNamed:@"save_button.png"] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(editAlbumService) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = nextBtn;
    
    isShowSheet = YES;
    [self followerService];
    
    //Custom ToolBar added to move keypad down for Numeric keypad
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    
    _priceTextField.inputAccessoryView = numberToolbar;
    
    serviceCount=1 ;
    currencyListArray =[[NSArray alloc]initWithObjects:@"AED",@"SAR",@"OMR",@"AED",@"BHD",@"QAR",@"EGP",@"JOD",@"MAD",@"DZD",@"DOL",@"EUR",@"PND",nil];
}

//toolbar button action moving keypad down, with removing text from UITextfield
-(void)cancelNumberPad{
  
    [_priceTextField resignFirstResponder];
    _priceTextField.text = @"";
}

//action for ,toolbar done button
-(void)doneWithNumberPad{
    [_priceTextField resignFirstResponder];
}


-(void)editAlbumService {
    Connections *connections = [[Connections alloc] init];
    [connections setDelegate:self];
    
    requestType = EDIT_IMAGE_ALBUM;
    [connections setRequestType:EDIT_IMAGE_ALBUM];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
    [postParams setObject:[userDefault objectForKey:@"userId"] forKey:@"userId"];
    
    if ([_captionTextField.text length] > 0) {
        
        [postParams setObject:_captionTextField.text forKey:@"image_description"];
        NSNumber * myNumber =[NSNumber numberWithInt:[albumId integerValue]];
        
        [postParams setObject:imageUrlString forKey:@"image_url"];
        if ([_selectAlbumBtn.titleLabel.text length] > 0) {
             [postParams setObject:myNumber forKey:@"albumId"];
            
            if (number == 1) {
                [postParams setObject:_priceTextField.text forKey:@"price"];
                [postParams setObject:_currencyButton.titleLabel.text forKey:@"currency"];
                [postParams setObject:_locationTextField.text forKey:@"location"];
                [connections sendRequestWithPath:EDIT_IMAGE_ALBUM andParameters:postParams showLoader:YES]; 
            }else{
                [connections sendRequestWithPath:EDIT_IMAGE_ALBUM andParameters:postParams showLoader:YES];
            }
           
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Select Album Name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Enter Description" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (isShowSheet) {
        isShowSheet = NO;
        [ self openCamera];
    }
}

- (IBAction)selectImgSourceBtnTapped:(id)sender {
    [self openCamera];
}

- (IBAction)createAlbum:(id)sender {
    [_locationTextField resignFirstResponder];
    [_priceTextField resignFirstResponder];
    [_captionTextField resignFirstResponder];
    [self createNewAlbum];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
        NSLog(@"result: %@", _locationTextField.text);
        NSLog(@"result: %@", _priceTextField.text);
}

- (void)followerService {
    if (![existingAlbumList count]){
        Connections *connections = [[Connections alloc] init];
        [connections setDelegate:self];
        
        requestType = ADD_ALBUM;
        [connections setRequestType:ADD_ALBUM];
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [connections sendRequestWithPath:ADD_ALBUM andParameters:[NSDictionary dictionaryWithObjectsAndKeys:[userDefault objectForKey:@"userId"],@"userId",nil] showLoader:YES];
        
    }
}
- (IBAction)currencyList:(id)sender {
    NSString *listValue=[[NSString alloc]initWithFormat:@"currencyList"];
    [self selectAlbumActionSheet:listValue];
}

- (IBAction)existingAlbumList:(id)sender {
    [_locationTextField resignFirstResponder];
    [_priceTextField resignFirstResponder];
    [_captionTextField resignFirstResponder];
    
    NSString *listValue=[[NSString alloc]initWithFormat:@"albumList"];
    [self selectAlbumActionSheet:listValue];
}

- (void)selectAlbumActionSheet:(NSString *)list {
    NSString *languageTitleString = [[NSString alloc]init];
    _selectAlbumBtn.titleLabel.text=[existAlbumArray objectAtIndex:0];
    
    _createAlbumActionSheet = [[UIActionSheet alloc] initWithTitle:languageTitleString delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Done",nil];
    _createAlbumActionSheet.delegate= self ;
   
    if ([list isEqualToString:@"albumList"]) {
        _createAlbumPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,80, 320, 200)];
        _createAlbumPicker.dataSource = self;
        _createAlbumPicker.delegate = self;
        _createAlbumPicker.showsSelectionIndicator=YES ;
        _createAlbumPicker.tag=1 ;
        
        /* Select the previous selected value, which for me is stored in 'currentPosition' */
        [_createAlbumPicker selectRow:0 inComponent:0 animated:NO];

         [_createAlbumActionSheet addSubview:_createAlbumPicker];
    }
    else{
        UIPickerView *currencyPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,80, 320, 200)];
        currencyPicker.dataSource = self;
        currencyPicker.delegate = self;
        currencyPicker.showsSelectionIndicator=YES ;
       currencyPicker.tag=2 ;
        
        /* Select the previous selected value, which for me is stored in 'currentPosition' */
        [currencyPicker selectRow:0 inComponent:0 animated:NO];

         [_createAlbumActionSheet addSubview:currencyPicker];
    }
    
    _createAlbumActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [_createAlbumActionSheet showInView:self.view];
    /* Make sure the UIActionSheet is big enough to fit your UIPickerView and it's buttons */
    [_createAlbumActionSheet setBounds:CGRectMake(0,0, 320, 411)];
    
}

#pragma mark - Connection Delagate

-(void)connectionDidRecievedResponse:(BOOL)isSuccess withData:(id)data andMessage:(NSString *)message{
    NSString *msgString =[[NSString alloc]initWithFormat:@"%@",[data objectForKey:@"message"]];
//    NSString *descpString =[[NSString alloc]initWithFormat:@"%@",[data objectForKey:@"description"]];
    if ([msgString isEqualToString:@"Uploaded successsfully"]) {
        imageUrlString=[[NSString alloc]initWithFormat:@"%@",[data objectForKey:@"location"]];
        serviceCount= serviceCount+1;
    }
    else if (serviceCount>3){
        serviceCount=1 ;
        _currencyButton.hidden=YES;
        _priceTextField.hidden=YES;
        _locationTextField.hidden=YES;
        [_captionTextField setText:@""];
        [_captionTextField setPlaceholder:@"Add Description"];
        albumLabel.text=@"Select Album Name";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Album Edited Successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
else{
    existAlbumArray =[[NSMutableArray alloc]init];
    existingAlbumList= [[NSArray alloc] initWithArray:[data objectForKey:@"albums"]];
    for (int i = 0; i<existingAlbumList.count; i++) {
        [existAlbumArray insertObject:[[existingAlbumList objectAtIndex:i] objectForKey:@"title"] atIndex:i];
        serviceCount=serviceCount+1 ;
    }
    }
}

#pragma mark - UIPickerDelegate
/* Defines the total number of Components (like groups in a UITableView) in a UIPickerView */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag==1) {
        return existAlbumArray.count;
    }
    else{
        return currencyListArray.count;
    }
    return 0 ;
}


/* What to do when a row from a UIPickerView is selected. This will trigger each time you scroll the UIPickerView, so only lightweight stuff. */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView.tag==1) {
        
    row = [_createAlbumPicker selectedRowInComponent:0];
    albumLabel.text =[existAlbumArray objectAtIndex:row];
//    _selectAlbumBtn.titleLabel.text =[existAlbumArray objectAtIndex:row];
    
    albumId=[[NSString alloc]init];
    albumId=[[existingAlbumList objectAtIndex:row ] objectForKey:@"id"] ;
    albumType=[[existingAlbumList objectAtIndex:row ] objectForKey:@"type"] ;
    
         number = [albumType intValue];
    
        if (number == 1) {
            _currencyButton.hidden=NO;
            _locationTextField.hidden=NO;
            _priceTextField.hidden=NO;
        }else{
            _currencyButton.hidden=YES;
            _priceTextField.hidden=YES;
            _locationTextField.hidden=YES;
        }
}
else{
    _currencyButton.titleLabel.text=[currencyListArray objectAtIndex:row];
    }
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)rows forComponent:(NSInteger)component {
    
    if (thePickerView.tag==1) {
        NSString *reason =[[NSString alloc]init];
        reason= [existAlbumArray objectAtIndex:rows] ;
        return reason;
    }
    else{
        NSString *reason =[[NSString alloc]init];
        reason= [currencyListArray objectAtIndex:rows] ;
        return reason;
    }
    return nil;
}

-(void)createNewAlbum{
    YBCameraViewController *controller = [[YBCameraViewController  alloc] initWithNibName:@"YBCameraViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1.12412


-(void)openCamera{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        // Insert the overlay
        overlay = [[OverlayViewController alloc] initWithNibName:@"OverlayViewController" bundle:nil];
        overlay.delegate=self ;
        
       UINavigationController *navCtroller = [[UINavigationController alloc] initWithRootViewController:overlay];
        [self.navigationController presentViewController:navCtroller animated:YES completion:nil];
    }
}

- (void)secondViewControllerDidFinish:(OverlayViewController *)overlayViewController
{
    self.imgView.image=overlayViewController.image ;
    image=overlayViewController.image ;
    
    Connections *connections = [[Connections alloc] init];
    [connections setDelegate:self];
    
    requestType = SAVE_IMAGE;
    [connections setRequestType:SAVE_IMAGE];
    
//    [ self saveProfile];
    
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
    [postParams setObject:image forKey:@"file"];
    [connections sendRequestWithPath:SAVE_IMAGE andParameters:postParams showLoader:YES];

}


/*-(void)saveProfile
{
    NSString *apiUrl;
    NSMutableDictionary* jsonObject = [[NSMutableDictionary alloc]init];

//    [jsonObject setObject:USER_ID forKey:@"id"];
    apiUrl=kPostCreateProfile;
    //            }
//    [jsonObject setObject:@"T_Yebab" forKey:@"first_name"];
//    [jsonObject setObject:@"UpImage" forKey:@"last_name"];
//    [jsonObject setObject:@"Male" forKey:@"gender"];
//
//    [jsonObject setObject:@"2013-10-24" forKey:@"birth_date"];
//    [jsonObject setObject:@"UpImage" forKey:@"job_title"];
//    [jsonObject setObject:@"Up" forKey:@"industry"];
//    [jsonObject setObject:@"UpImage" forKey:@"prefered_airline"];
//    [jsonObject setObject:@"UpImage" forKey:@"prefered_hotel"];
//    [jsonObject setObject:@"UpImage" forKey:@"home_city"];
//    [jsonObject setObject:@"UpImage" forKey:@"favorite_city"];
//    [jsonObject setObject:@"UpImage" forKey:@"travel"];
//    [jsonObject setObject:@"UpImage" forKey:@"like_to_talk"];
//    [jsonObject setObject:@"UpImage" forKey:@"biggest_vice"];
//    [jsonObject setObject:@"UpImage" forKey:@"best_travel_experience"];
//    [jsonObject setObject:@"UpImage" forKey:@"worst_travel_experience"];
//    [jsonObject setObject:@"1" forKey:@"visibility"];
//    [jsonObject setObject:@"UpImage" forKey:@"expense_budget"];
    
    //NSData *imageData = UIImagePNGRepresentation(imageProfile);
    [jsonObject setObject:image forKey:@"files"];
    Connections *connection = [[Connections alloc] init];
    connection.delegate = self;
 //   [connection sendRequestWithPath:[NSString stringWithFormat:@"%@",apiUrl] andParameters:jsonObject showLoader:YES ];
   [connection sendRequestWithPath:[NSString stringWithFormat:@"%@",apiUrl] andParameters:jsonObject showLoader:YES methodName:apiUrl];
  
}*/




- (void)viewDidUnload {
    [self setLocationTextField:nil];
    [self setPriceTextField:nil];
    [self setSelectAlbumBtn:nil];
    [super viewDidUnload];
}
@end
