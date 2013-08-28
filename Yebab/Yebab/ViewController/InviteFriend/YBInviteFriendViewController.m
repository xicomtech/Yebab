//
//  YBInviteFriendViewController.m
//  Yebab
//
//  Created by sushil on 02/05/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import "YBInviteFriendViewController.h"
#import "InviteFriendCell.h"
#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>
#import <AddressBookUI/AddressBookUI.h>


@interface YBInviteFriendViewController ()

@end

@implementation YBInviteFriendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
      self.title = @"Invite Friends";
     inviteFlagInt =1;
    ///////Memory Allocate ////
       emailFrdArray     = [[NSMutableArray alloc] init];
       fullNameFrdArray  = [[NSMutableArray alloc] init];
       phoneNoFrdArray   = [[NSMutableArray alloc] init];

    NSMutableArray      *allResults        = [[NSMutableArray alloc] init];
    NSMutableDictionary *emailListDic      = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *phonNumberListDic = [[NSMutableDictionary alloc] init];
    NSArray             *allPeople         = [[NSArray alloc] init];
    
     ABAddressBookRef    _addressBookRef    = ABAddressBookCreateWithOptions(NULL, NULL);
     if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(_addressBookRef, ^(bool granted, CFErrorRef error) {
            // First time access has been granted, add the contact
           // [self _addContactToAddressBook];
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        //[self _addContactToAddressBook];
    }
    else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
    }
    
    if (!_addressBookRef) {
        NSLog(@"opening address book");
    }
    allPeople = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(_addressBookRef);
    NSLog(@"%@",allPeople);
    
    for (id record in allPeople){
        NSString *firstName = (__bridge NSString *)ABRecordCopyValue((__bridge ABRecordRef)(record), kABPersonFirstNameProperty);
        
        NSString *lastName = (__bridge NSString *)ABRecordCopyValue((__bridge ABRecordRef)(record), kABPersonLastNameProperty);
        
        fullNameStr = nil;
        if (ABPersonGetCompositeNameFormat() == kABPersonCompositeNameFormatFirstNameFirst)
            fullNameStr = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        else
            fullNameStr = [NSString stringWithFormat:@"%@, %@", lastName, firstName];
        
        if (![allResults containsObject:fullNameStr])
            [fullNameFrdArray addObject:fullNameStr];
        
        CFTypeRef emailProp = ABRecordCopyValue((__bridge ABRecordRef)record, kABPersonEmailProperty);
       /// NSString *
        emailStr = [((__bridge NSMutableArray *)ABMultiValueCopyArrayOfAllValues(emailProp))objectAtIndex:0];
        if (!emailStr) {
            emailStr = @"";
        }
        [emailListDic setObject:emailStr forKey:@"Email"];
        [emailFrdArray addObject:emailStr];
        
        CFTypeRef phoneProp = ABRecordCopyValue((__bridge ABRecordRef)record, kABPersonPhoneProperty);
      ///  NSString *
        phoneNoStr = [((__bridge NSMutableArray *)ABMultiValueCopyArrayOfAllValues(phoneProp)) objectAtIndex:0 ];
        if (!phoneNoStr) {
            phoneNoStr = @"";
        }
        [phonNumberListDic setObject:phoneNoStr forKey:@"Number"];
       
        [phoneNoFrdArray addObject:phoneNoStr];
        
        CFRelease((__bridge CFTypeRef)(record));
    }
     CFRelease(_addressBookRef);
     allPeople = nil;
}
-(IBAction)EmailAndSmsButtonAction:(id)sender{

    if ([sender tag]==1){
         [emailBtn setSelected:YES];
        [smsBtn setSelected:NO];
        inviteFlagInt =1;
    }
    else{
        [smsBtn setSelected:YES];
        [emailBtn setSelected:NO];
        inviteFlagInt =2;
    }
    [inviteFriendTable reloadData];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationItem setHidesBackButton:NO];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton setFrame:CGRectMake(0, 0, 51, 30)];
    [leftbutton setImage:[UIImage imageNamed:@"back_button.png"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbutton setFrame:CGRectMake(0, 0, 51, 30)];
    [rightbutton setImage:[UIImage imageNamed:@"done_button.png"] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(doneButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = nextBtn;
}

#pragma mark UIButton Action
-(void)backButtonTapped{
    NSLog(@"back button Pressed");
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)doneButtonTapped{
    NSLog(@"next button pressed");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil];
}
#pragma mark
#pragma mark - UITableView Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [fullNameFrdArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     
    static NSString *CellIdentifier       = @"Cell1";
     InviteFriendCell *cell = (InviteFriendCell*)[tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[InviteFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"InviteFriendCell" owner:nil options:nil];
    cell = [nibs objectAtIndex:0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    cell.textLabel.textColor        = [UIColor darkGrayColor];
    
    if (inviteFlagInt ==1){
            cell.emailLable.text     = [emailFrdArray objectAtIndex:indexPath.row];
            cell.inviteButton.hidden = NO;
    }else{
         cell.emailLable.text        = [phoneNoFrdArray objectAtIndex:indexPath.row];
         cell.inviteButton.hidden    = YES;
    }
    cell.nameLable.text              = [fullNameFrdArray objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (inviteFlagInt==2) {
        
        [self buttonPressed:[phoneNoFrdArray objectAtIndex:indexPath.row]];
     }
}
- (void)buttonPressed:(NSArray *)buttonArray
{
   [self sendSMS:@"Yebab of SMS..." recipientList:buttonArray];
}
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller1 = [[MFMessageComposeViewController alloc] init];
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE withAnimation:UIStatusBarAnimationSlide];
    if([MFMessageComposeViewController canSendText])
    {
        controller1.body = bodyOfMessage;
        controller1.recipients = [NSArray arrayWithObject:recipients];
        controller1.messageComposeDelegate = self;
        [self presentModalViewController:controller1 animated:YES];
    }
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissModalViewControllerAnimated:YES];

//    [self dismissModalViewControllerAnimated:YES];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
        else if (result == MessageComposeResultSent)
            NSLog(@"Message sent");
            else 
                NSLog(@"Message failed")  ;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
