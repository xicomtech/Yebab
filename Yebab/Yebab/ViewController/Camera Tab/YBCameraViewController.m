
//
//  YBCameraViewController.m
//  Yebab
//
//  Created by Xicom on 07/06/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import "YBCameraViewController.h"

@interface YBCameraViewController ()

@end

@implementation YBCameraViewController
@synthesize selectAlbumButton,createAlbumButton ,userTypeView,albumTxtFld,addButton;
@synthesize followerArray ,categoryListId,editAlbumView;
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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.title = @"Create Album";
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbutton setFrame:CGRectMake(0, 0, 50, 30)];
    [rightbutton setImage:[UIImage imageNamed:@"save_button.png"] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(saveAlbumService) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = nextBtn;
    
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton setFrame:CGRectMake(0, 0, 51, 30)];
    [leftbutton setImage:[UIImage imageNamed:@"back_button.png"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem = backBtn;

    
    
    [self userTypeBtnTapped:[self.userBtnCollection objectAtIndex:0]];
    [self shareTypeBtnTapped:[self.shareBtnCollection objectAtIndex:0]];
    addButton.titleLabel.text=@"Add photo";
    isShowSheet = YES;
    typeDic=[[NSMutableDictionary alloc]init];
    followerArray =[[NSMutableArray alloc]init];
    typeValue=1 ;
    [self followerService];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (isShowSheet) {
     [self businessTypeBtnTapped:[self.businessBtnCollection objectAtIndex:0]];
    }
}

-(void)backButtonTapped{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidUnload {
    [self setBusinessBtnCollection:nil];
    [self setShareBtnCollection:nil];
    [self setUserBtnCollection:nil];
    [self setImgView:nil];
    [self setCaptionTxt:nil];
 //   [self setListView:nil];
    [self setCurrencyTxtFld:nil];
    [self setAlbumTxtFld:nil];

    [super viewDidUnload];
}

#pragma mark - UITextField Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    [self.listView removeFromSuperview];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    for (int i=0; i<albumList.count; i++) {
        
        NSLog(@"result: %@", [[existingAlbumList objectAtIndex:i]objectForKey:@"title"]);
        NSLog(@"result: %@", albumTxtFld.text);
        
        if ([albumTxtFld.text isEqualToString:[[existingAlbumList objectAtIndex:i]objectForKey:@"title"]]){
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Album Name Exist" message:@"Please enter unique album name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [al show];
        }
    }
    
}

#pragma mark Button Action

- (IBAction)businessTypeBtnTapped:(id)sender {
    if (typeValue==1) {
    
    for (UIButton *btn in self.businessBtnCollection) {
        [btn setSelected:NO];
    }
    UIButton *senderBtn = (UIButton *)sender;
    [senderBtn setSelected:YES];
    if (senderBtn.tag ==11) {
        catType=0;
        }
    else{
        catType=1;
        }
    }
    else{
        UIButton *senderBtn = (UIButton *)sender;
        [senderBtn setSelected:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"User Don't have any store" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)userTypeBtnTapped:(id)sender {
    for (UIButton *btn in self.userBtnCollection) {
        [btn setSelected:NO];
    }
    UIButton *senderBtn = (UIButton *)sender;
    [senderBtn setSelected:YES];
     if (senderBtn.tag ==32) {
         [self followerBtnTapped];
    }
}


- (IBAction)shareTypeBtnTapped:(id)sender {
    for (UIButton *btn in self.shareBtnCollection) {
        [btn setSelected:NO];
    }
    UIButton *senderBtn = (UIButton *)sender;
    [senderBtn setSelected:YES];
    
    if (senderBtn.tag == 22) {
        userType=NO ;
        self.userTypeView.hidden = NO;
    }else{
        userType=YES ;
        self.userTypeView.hidden =YES ;
    }
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

- (void)saveAlbumService {
    addAlbum=YES;
    
    Connections *connections = [[Connections alloc] init];
    [connections setDelegate:self];
    
    requestType = SAVE_ALBUM;
    [connections setRequestType:SAVE_ALBUM];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
    [postParams setObject:[userDefault objectForKey:@"userId"] forKey:@"userId"];
    
    if ([albumTxtFld.text length] > 0) {
        [postParams setObject:albumTxtFld.text forKey:@"albumName"];
        
        int catNumber =[categoryListId integerValue];
        
        if (catNumber != 0) {
            NSNumber *catNum = [NSNumber numberWithInteger:catNumber];
            [postParams setObject:catNum forKey:@"albumCategory"];
            NSNumber *number = [NSNumber numberWithInteger: catType];
            if (number != 0) {
                [postParams setObject:number forKey:@"albumType"];
                if (userType) {
                    [connections sendRequestWithPath:SAVE_ALBUM andParameters:postParams showLoader:YES];
                }else{
                
                    if (followerArray.count != 0) {
                        [postParams setObject:followerArray forKey:@"albumContributors"];
                        [connections sendRequestWithPath:SAVE_ALBUM andParameters:postParams showLoader:YES];
                    }else{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Select Followers" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    }
                }
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Select Album Type" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Select Album Category" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Album Name cannot be blank" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
 
}

#pragma mark - Connection Delagate

-(void)connectionDidRecievedResponse:(BOOL)isSuccess withData:(id)data andMessage:(NSString *)message{
    if (isSuccess) {
        NSLog(@"%d",[data count]);
        if ([requestType isEqualToString:DISCOVER_SCREEN]) {
            albumList = [[NSArray alloc] initWithArray:data];
            catogeryList =[[NSMutableArray alloc]init];
            for (int i = 0; i<albumList.count; i++) {
                [catogeryList insertObject:[[albumList objectAtIndex:i] objectForKey:@"categoryName"] atIndex:i];
            }
            
          [self selectCatogeryActionSheet];
        }
        else{
            _captionTxt.text=@"" ;
            _currencyTxtFld.text=@"" ;
            albumTxtFld.text=@"" ;
            selectAlbumButton.titleLabel.text=@"Dresses" ;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Album created successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    else{
        NSDictionary *dataDic =[[NSMutableDictionary alloc]init];
        dataDic=data;
        followerList = [[NSArray alloc] initWithArray:[data objectForKey:@"followers"]];
        existingAlbumList= [[NSArray alloc] initWithArray:[data objectForKey:@"albums"]];
        typeDic=[data objectForKey:@"user"];
        NSString *typeString =[typeDic objectForKey:@"has_store"];
        typeValue =[typeString integerValue];
        if (typeValue == 0) {
  //          _typeView.hidden=YES ;
            userTypeView.hidden=YES;
            _subUserView.hidden=YES;
            _typeLabel.hidden=YES;
        }
    }
}


- (void)selectCatogeryActionSheet {
    NSString *languageTitleString = [[NSString alloc]init];
    selectAlbumButton.titleLabel.text=[catogeryList objectAtIndex:0];
    
    catogeryPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,80, 320, 200)];
    catogeryPicker.dataSource = self;
    catogeryPicker.delegate = self;
    catogeryPicker.showsSelectionIndicator=YES ;
    
    /* Select the previous selected value, which for me is stored in 'currentPosition' */
    [catogeryPicker selectRow:0 inComponent:0 animated:NO];
    
    catogeryActionSheet = [[UIActionSheet alloc] initWithTitle:languageTitleString delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Done",nil];
    catogeryActionSheet.delegate= self ;

    [catogeryActionSheet addSubview:catogeryPicker];
    catogeryActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [catogeryActionSheet showInView:self.view];
    /* Make sure the UIActionSheet is big enough to fit your UIPickerView and it's buttons */
    [catogeryActionSheet setBounds:CGRectMake(0,0, 320, 411)];

 }


#pragma mark - UIPickerDelegate
/* Defines the total number of Components (like groups in a UITableView) in a UIPickerView */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return catogeryList.count;
}


/* What to do when a row from a UIPickerView is selected. This will trigger each time you scroll the UIPickerView, so only lightweight stuff. */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    row = [catogeryPicker selectedRowInComponent:0];
    //selectAlbumButton.titleLabel.text=@"Dresses" ;
    selectAlbumButton.titleLabel.text =[catogeryList objectAtIndex:row];
    languageValueString=[catogeryList objectAtIndex:row];
    categoryListId =[[albumList objectAtIndex:row] objectForKey:@"categoryId"] ;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)rows forComponent:(NSInteger)component {
    NSString *reason =[[NSString alloc]init];
   reason= [catogeryList objectAtIndex:rows] ;
    return reason;
}

#pragma mark - ActionSheet Delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet==catogeryActionSheet){
        if (languageValueString.length  > 0) {
            selectAlbumButton.titleLabel.text=languageValueString ;
        }else{
            selectAlbumButton.titleLabel.text=@"Dresses" ;
        }
        
    }
    else{
//        if(buttonIndex == 0){
//            [self openCamera];
//        }else if (buttonIndex == 1){
//            [self openAlbum];
//        }else if (buttonIndex == 2){
//            [self createNewAlbum];
//        }

   }
    
}


    
//-(void)openAlbum{
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
//        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//        imagePicker.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//        imagePicker.allowsEditing = YES;
//        imagePicker.delegate = self;
//        [self presentModalViewController:imagePicker animated:YES];
//    }
//}
//
//-(void)openCamera{
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
//        imagePicker.allowsEditing = YES;
//        imagePicker.delegate = self;
//        [self presentModalViewController:imagePicker animated:YES];
//    }
//}
//
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
//    self.imgView.image = image;
//    addButton.titleLabel.text=@"";
//    [self dismissModalViewControllerAnimated:YES];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectAlbumBtnTapped:(id)sender {
    [self.captionTxt resignFirstResponder];
    [self.currencyTxtFld resignFirstResponder];
    [self.albumTxtFld resignFirstResponder];

    if (![albumList count]) {
        NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
        Connections *connections = [[Connections alloc] init];
        [connections setDelegate:self];
        requestType = DISCOVER_SCREEN;
        [connections setRequestType:DISCOVER_SCREEN];
        [connections sendRequestWithPath:DISCOVER_SCREEN andParameters:postParams showLoader:YES];
    }else{

        [self selectCatogeryActionSheet];
    }
}

//- (IBAction)selectImgSourceBtnTapped:(id)sender {
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add from Camera",@"Add from album", nil];
//    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
//   
//}

- (void)followerBtnTapped {
    if ([followerList count]){
    createAlbumViewController *controller = [[createAlbumViewController alloc] initWithNibName:@"createAlbumViewController" bundle:nil];
         NSLog(@"list:%@",followerList);
        controller.categoryList=followerList ;
        controller.delegate=self;
    [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)secondViewControllerDidFinish:(createAlbumViewController *)createAlbumViewController
{
 //   createAlbumView.delegate=self ;
    followerArray = createAlbumViewController.arFollower;
    //NSLog(@"list:%@",followerArray);
    // Do something with the array 
}

@end
