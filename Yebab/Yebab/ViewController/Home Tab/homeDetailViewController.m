//
//  homeDetailViewController.m
//  Yebab
//
//  Created by Xicom on 23/05/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import "homeDetailViewController.h"
#import "commonFunction.h"

@interface homeDetailViewController ()

@end


@implementation homeDetailViewController
@synthesize imageDetail, delegate, cellIndexPath;

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
    [self settingImageView];
    [self fetchComments];
    self.commentTxtView.selectedRange = NSMakeRange(0, 0);
    imgDic = [[NSMutableDictionary alloc] init];
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton setFrame:CGRectMake(0, 0, 51, 30)];
    [leftbutton setImage:[UIImage imageNamed:@"back_button.png"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem = backBtn;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.delegate reloadTableCell:imageDetail andIndexpath:cellIndexPath];
    
}
-(void)fetchComments{
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
    [postParams setObject:[[imageDetail objectForKey:@"info"] objectForKey:@"imageId"] forKey:@"imageId"];
    
    Connections *connections = [[Connections alloc] init];
    [connections setDelegate:self];
    requestType = GET_COMMENT;
    [connections setRequestType:GET_COMMENT];
    [connections sendRequestWithPath:GET_COMMENT andParameters:postParams showLoader:YES];
    [self.commentTxtView resignFirstResponder];
}

-(void)settingImageView{
    
    [self.userNameLbl setText:[NSString stringWithFormat:@"%@",[[imageDetail objectForKey:@"profile"]objectForKey:@"userName"]]];
    
    //////User Profile Pic Details
    [self.imgDescLbl setText:[NSString stringWithFormat:@"%@",[[imageDetail objectForKey:@"info"]objectForKey:@"description"]]];
    [self.dayAgoLbl setText:[NSString stringWithFormat:@"%@",[[imageDetail objectForKey:@"info"]objectForKey:@"addedTime"]]];
    
    [self.inThingsLbl setText:[NSString stringWithFormat:@"in %@",[[imageDetail objectForKey:@"info"]objectForKey:@"albumName"]]];
    
    //////Comment Count/////
    [self.likeCountLbl setText:[NSString stringWithFormat:@"%@",[[imageDetail objectForKey:@"counts"]objectForKey:@"likesCount"]]];
    [self.stickCountLbl setText:[NSString stringWithFormat:@"%@",[[imageDetail objectForKey:@"counts"]objectForKey:@"stickesCount"]]];
    
    NSString *commentsCount = [[imageDetail objectForKey:@"counts"]objectForKey:@"commentsCount"];
    [self.userCmnt setText:[NSString stringWithFormat:@"Comments(%@)",commentsCount]];
    float nextYcoordinate = 100.0f;
    
    if ([[[imageDetail objectForKey:@"info"]objectForKey:@"relatedShop"] intValue] != 0) {
        CGRect wallSize = self.userDescView.frame;
        wallSize.size.height = 131.0f;
        self.userDescView.frame = wallSize;
        CGRect btnViewSize = self.buttonView.frame;
        btnViewSize.origin.y = 131.0f;
        self.buttonView.frame = btnViewSize;
        CGRect commentViewSize = self.commentView.frame;
        commentViewSize.origin.y = btnViewSize.origin.y + btnViewSize.size.height +10;
        self.commentView.frame = commentViewSize;
        
        CGRect callBtn = self.calBtn.frame;
        callBtn.origin.x = 51.0f;
        callBtn.origin.y = 59.0f;
        self.calBtn.frame = callBtn;
        
        CGRect msgBtn = self.msgBtn.frame;
        msgBtn.origin.x = 170.0f;
        msgBtn.origin.y = 59.0f;
        self.msgBtn.frame = msgBtn;
        
        CGRect locLbl = self.locationLbl.frame;
        locLbl.origin.y = 103.0f;
        self.locationLbl.frame = locLbl;
        

        [self.userDescView addSubview:self.calBtn];
        [self.userDescView addSubview:self.msgBtn];
    }
    
    if ([commentsCount intValue] == 0) {
        //[self.commentView setHidden:YES];
        //[self.commentCountUIButton setTitle:[NSString stringWithFormat:@"View All(%@)Comments " ,commentsCount]forState:UIControlStateNormal] ;
    }else{
        NSMutableArray * commentArr  = [[NSMutableArray alloc] initWithArray:[imageDetail objectForKey:@"comments"]];
        
        for (int i = 0; i < [commentArr count]; ++i) {
            
            UIView *singleCommentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, nextYcoordinate, 320, 60)];
            UIImageView *userImg = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 50.0f, 50.0f)];
            [userImg setImage:[UIImage imageNamed:@"add_pic.png"]];
            UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 59.0f, 320.0f, 1.0f)];
            [lineImg setImage:[UIImage imageNamed:@"line.png"]];
            
            UILabel *userNameLbl =[[UILabel alloc] initWithFrame:CGRectMake(63.0f, 10, 175.0f, 15.0f)];
            UILabel *commentLbl =[[UILabel alloc] initWithFrame:CGRectMake(63.0f, 25.0f, 238.0f, 30.0f)];
            UILabel *dayLbl =[[UILabel alloc] initWithFrame:CGRectMake(253.0f, 5, 62.0f, 21.0f)];
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[commentArr objectAtIndex:i]];
            
            /*
            [userNameLbl setText:@"vldjldmfjb"];
            [commentLbl setText:@"vlcxjvdfjvoxojb vlcxjvdf jvoxojb vlcxjv dfjvo ojb vlcxjv dfjvoxojb vlcxjvdfjvoxojb"];
            [dayLbl setText:@"2 Day ago"];
             */
            
            [userNameLbl setText:[dic objectForKey:@"userName"]];
            [commentLbl setText:[dic objectForKey:@"commentBody"]];
            [dayLbl setText:[NSString stringWithFormat:@"%@ ago",[dic objectForKey:@"timestamp"]]];
            
            [commentLbl setNumberOfLines:2];
            [userNameLbl setTextColor:[UIColor colorWithRed:47.0/255.0f green:125.0f/255.0f blue:191/255.0f alpha:1.0f]];
            [commentLbl setTextColor:[UIColor darkGrayColor]];
            [dayLbl setTextColor:[UIColor lightGrayColor]];            
            
            if (![[imgDic allKeys] containsObject:[dic objectForKey:@"userId"]]) {
                
                // thumbnail for this row is not found in cache, so get it from remote website
                __block NSData *imageData = nil;

                dispatch_queue_t imageQueue = dispatch_queue_create("queueForCellImage", NULL);
                dispatch_async(imageQueue, ^{
                    NSString *imagePath = [GET_IMAGE_HOST_URL stringByAppendingFormat:@"%@", [dic objectForKey:@"userPicture"]];
                    NSURL *dataURL = [NSURL URLWithString:imagePath];
                    imageData = [[NSData alloc] initWithContentsOfURL:dataURL];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        userImg.image = [UIImage imageWithData:imageData];
                        
                        if (imageData) {
                            [imgDic setObject:imageData forKey:[dic objectForKey:@"userId"]];
                        }
                    });
                });
                
            } else {
                // thumbnail is in cache
                NSData *image = [imgDic objectForKey:[dic objectForKey:@"userId"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    userImg.image = [UIImage imageWithData:image];
                });
            }

            UIFont *font1 = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
            UIFont *font2 = [UIFont fontWithName:@"Helvetica" size:13.0f];
            UIFont *font3 = [UIFont fontWithName:@"Helvetica" size:10.0f];
            
            [userNameLbl setFont:font1];
            [commentLbl setFont:font2];
            [dayLbl setFont:font3];
            
            [singleCommentView addSubview:userImg];
            [singleCommentView addSubview:userNameLbl];
            [singleCommentView addSubview:commentLbl];
            [singleCommentView addSubview:dayLbl];
            [singleCommentView addSubview:lineImg];
            
            [self.commentView addSubview:singleCommentView];
            nextYcoordinate = singleCommentView.frame.origin.y + singleCommentView.frame.size.height;
        }
    }
    
    CGRect commentViewFrame = self.commentView.frame;
    commentViewFrame.size.height = nextYcoordinate +20;
    self.commentView.frame = commentViewFrame;
    
    CGRect imageInfoFrame = self.imageInfoView.frame;
    imageInfoFrame.size.height = self.commentView.frame.origin.y + self.commentView.frame.size.height;
    self.imageInfoView.frame = imageInfoFrame;
    
    if (![[imageDetail allKeys] containsObject:@"userImage"]) {
        UIImage *userImage;
        NSString *imagePath = [GET_IMAGE_HOST_URL stringByAppendingFormat:@"%@", [[imageDetail objectForKey:@"profile"]objectForKey:@"userPicture"]];
        NSURL *dataURL = [NSURL URLWithString:imagePath];
        NSData *imgData = [NSData dataWithContentsOfURL:dataURL];
        userImage = [UIImage imageWithData:imgData];
        [imageDetail setObject:userImage forKey:@"userImage"];
        
    }else{
        self.userImg.image = [imageDetail objectForKey:@"userImage"];
    }
    
    if (![[imageDetail allKeys] containsObject:@"postImage"]) {
        UIImage *postImage;
        NSString *imagePath = [GET_IMAGE_HOST_URL stringByAppendingFormat:@"%@", [[imageDetail objectForKey:@"info"]objectForKey:@"image"]];
        NSURL *dataURL = [NSURL URLWithString:[imagePath stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        NSData *imgData = [NSData dataWithContentsOfURL:dataURL];
        postImage = [UIImage imageWithData:imgData];
        [imageDetail setObject:postImage forKey:@"postImage"];
    }else{
        self.wallUserImg.image = [imageDetail objectForKey:@"postImage"];
    }
    
    CGRect wallSize =  self.wallUserImg.frame;
    wallSize.size.height = [[[imageDetail objectForKey:@"info"] objectForKey:@"imageHeight"] floatValue]/2;
    self.wallUserImg.frame = wallSize;
    
    CGRect commentFrame = self.imageInfoView.frame;
    commentFrame.origin.y = self.wallUserImg.frame.origin.y + self.wallUserImg.frame.size.height;
    self.imageInfoView.frame = commentFrame;
    
    [self.scrollView setContentSize:CGSizeMake(320, commentFrame.origin.y + commentFrame.size.height + 50)];
}

-(void)backButtonTapped{
    NSLog(@"back button Pressed");
    [self.navigationController popViewControllerAnimated:YES];
}
/*
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
 */

#pragma mark - Connection Delagate

-(void)connectionDidRecievedResponse:(BOOL)isSuccess withData:(id)data andMessage:(NSString *)message{
    if (isSuccess) {
        if ([requestType isEqualToString:POST_COMMENT]) {
            NSMutableDictionary *countDic = [[NSMutableDictionary alloc]initWithDictionary:[imageDetail objectForKey:@"counts"]];
            [countDic setObject:[data objectForKey:@"commentCount"] forKey:@"commentsCount"];
            [imageDetail setObject:countDic forKey:@"counts"];
            NSString *commentsCount = [[imageDetail objectForKey:@"counts"]objectForKey:@"commentsCount"];
            [self.userCmnt setText:[NSString stringWithFormat:@"Comments(%@)",commentsCount]];
            NSMutableArray *comments = [[NSMutableArray alloc] initWithArray:[imageDetail objectForKey:@"comments"]];
            [comments insertObject:data atIndex:0];
            [imageDetail setObject:comments forKey:@"comments"];
            [self settingImageView];

            [self textViewShouldEndEditing:self.commentTxtView];
        }
        else if ([requestType isEqualToString:GET_COMMENT]){
            [imageDetail setObject:data forKey:@"comments"];
            [self settingImageView];
        }
    }
}
-(void)likeDidRecievedResponse:(BOOL)isSuccess withData:(id)data andMessage:(NSString*)message{
    if (isSuccess) {

        NSMutableDictionary *countDic = [[NSMutableDictionary alloc]initWithDictionary:[imageDetail objectForKey:@"counts"]];
        NSMutableDictionary *infoDic = [[NSMutableDictionary alloc]initWithDictionary:[imageDetail objectForKey:@"info"]];
        
        if ([requestType isEqualToString:LIKE]) {
            [infoDic setObject:@"1" forKey:@"liked"];
        }else{
            [infoDic setObject:@"0" forKey:@"liked"];
        }
        [imageDetail setObject:infoDic forKey:@"info"];

        [countDic setObject:[data objectForKey:@"likeCount"] forKey:@"likesCount"];
        [imageDetail setObject:countDic forKey:@"counts"];
        [self.likeCountLbl setText:[NSString stringWithFormat:@"%@",[[imageDetail objectForKey:@"counts"]objectForKey:@"likesCount"]]];
        NSLog(@"%@",data);
    }else{
        [commonFunction showAlertViewWithTitle:@"Alert!" andMessage:message andDelegate:nil];
    }
}
#pragma mark - TextView Delegates

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (!isEditing) {
        dispatch_async(dispatch_get_main_queue(), ^{
            textView.selectedRange = NSMakeRange(0, 0);
        });
    }
    [self.scrollView setContentOffset:CGPointMake(0.0f, [[[imageDetail objectForKey:@"info"] objectForKey:@"imageHeight"] floatValue]/2 + 100) animated:YES];
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    isEditing = NO;
    [self.scrollView setContentOffset:CGPointMake(0.0f, [[[imageDetail objectForKey:@"info"] objectForKey:@"imageHeight"] floatValue]/2) animated:YES];
    textView.textColor = [UIColor lightGrayColor];
    textView.text = @"Type Your Comment";
    [textView resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    textView.textColor = [UIColor blackColor];
    if([text isEqualToString:@"\n"]) {
        [self.scrollView setContentOffset:CGPointMake(0.0f, [[[imageDetail objectForKey:@"info"] objectForKey:@"imageHeight"] floatValue]/2) animated:YES];
        [textView resignFirstResponder];
        if (!isEditing) {
            textView.textColor = [UIColor lightGrayColor];
        }
        return NO;
    }
    if (!isEditing) {
        textView.text = @"";
        isEditing = YES;
    }
    if ([textView.text length]> 160) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWallUserImg:nil];
    [self setUserImg:nil];
    [self setUserNameLbl:nil];
    [self setInThingsLbl:nil];
    [self setDayAgoLbl:nil];
    [self setLikeCountLbl:nil];
    [self setImgDescLbl:nil];
    [self setLocationLbl:nil];
    [self setStickCountLbl:nil];
    [self setCommentView:nil];
    [self setScrollView:nil];
    [self setImageInfoView:nil];
    [self setUserCmnt:nil];
    [self setCommentTxtView:nil];
    [self setUserDescView:nil];
    [self setShopDescView:nil];
    [self setButtonView:nil];
    [self setMsgBtn:nil];
    [self setCalBtn:nil];
    [self setLikeBtn:nil];
    [super viewDidUnload];
}

- (IBAction)postCommentTapped:(id)sender {
    NSString *commentText = [self.commentTxtView.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"%@",imgDic);
    if (isEditing && [commentText length]) {
        isEditing = NO;
        NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
        [postParams setObject:USER_ID forKey:@"userId"];
        [postParams setObject:[[imageDetail objectForKey:@"info"] objectForKey:@"imageId"] forKey:@"imageId"];
        [postParams setObject:self.commentTxtView.text forKey:@"comment"];
        
        Connections *connections = [[Connections alloc] init];
        [connections setDelegate:self];
        requestType = POST_COMMENT;
        [connections setRequestType:POST_COMMENT];
        [connections sendRequestWithPath:POST_COMMENT andParameters:postParams showLoader:YES];
        [self.commentTxtView resignFirstResponder];
 
    }else{
        [commonFunction showAlertViewWithTitle:@"Cannot Post blank comment" andMessage:@"" andDelegate:nil];
    }
}

- (IBAction)likeBtnTapped:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
    [postParams setObject:USER_ID forKey:@"userId"];
    [postParams setObject:[[imageDetail objectForKey:@"info"] objectForKey:@"imageId"] forKey:@"imageId"];
    Connections *connections = [[Connections alloc] init];
    [connections setDelegate:self];
    if ([btn isSelected]) {
        requestType = UNLIKE;
        [btn setBackgroundImage:[UIImage imageNamed:@"like_icon_new.png"] forState:UIControlStateNormal];
        [connections setRequestType:UNLIKE];
        [connections sendRequestWithPath:UNLIKE andParameters:postParams showLoader:YES];
        [btn setSelected:NO];
    }else{
        requestType = LIKE;
        [btn setBackgroundImage:[UIImage imageNamed:@"like_icon_new_hover.png"] forState:UIControlStateNormal];
        [connections setRequestType:LIKE];
        [connections sendRequestWithPath:LIKE andParameters:postParams showLoader:YES];
        [btn setSelected:YES];
    }
}

- (IBAction)stickBtnTapped:(id)sender {
}

- (IBAction)commentBtnTapped:(id)sender {
    
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
    [postParams setObject:[[imageDetail objectForKey:@"info"] objectForKey:@"imageId"] forKey:@"imageId"];

    Connections *connections = [[Connections alloc] init];
    [connections setDelegate:self];
    [connections setRequestType:POST_COMMENT];
    [connections sendRequestWithPath:POST_COMMENT andParameters:postParams showLoader:YES];
}


- (IBAction)callBtnTapped:(id)sender {
    NSString *number = [[imageDetail objectForKey:@"info"] objectForKey:@"shopPhone"];
    if (![number isEqual:(id)[NSNull null]]) {
        NSString *str = [NSString stringWithFormat:@"tel:// %@",number];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]]; 
    }else{
        [commonFunction showAlertViewWithTitle:@"No Phone Number found!" andMessage:@"" andDelegate:nil];

    }
}

- (IBAction)msgBtnTapped:(id)sender {
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init] ;
    NSString *emailAddress = [[imageDetail objectForKey:@"info"] objectForKey:@"shopMail"];
    if (![emailAddress isEqual:(id)[NSNull null]]) {
        if([MFMailComposeViewController canSendMail]){
            mailer.mailComposeDelegate = self;
            NSArray *toRecipients = [NSArray arrayWithObjects:emailAddress, nil];
            [mailer setToRecipients:toRecipients];
            [self presentViewController:mailer animated:YES completion:nil];
        }else{
            [commonFunction showAlertViewWithTitle:@"Email Not Supported" andMessage:@"" andDelegate:nil];

        }
    }else{
        [commonFunction showAlertViewWithTitle:@"No email found!" andMessage:@"" andDelegate:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Mail saved: you saved the email message in the drafts folder.");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
			break;
		default:
			NSLog(@"Mail not sent.");
			break;
	}
    // Remove the mail view
	[self dismissModalViewControllerAnimated:YES];
}
@end
