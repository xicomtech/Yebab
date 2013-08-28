//
//  YBHomeViewController.m
//  Yebab
//
//  Created by xicom-213 on 4/25/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import "YBHomeViewController.h"
#import "HomeCustomCell.h"
#import "YBAppDelegate.h"
#import "commonFunction.h"
#import "userProfileViewController.h"

@interface YBHomeViewController ()

@end
NSString* USER_ID;
BOOL SHOW_LOADER;

@implementation YBHomeViewController
@synthesize responseArr,myString;
@synthesize  homeCustomTable;
@synthesize categoryId;

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
    loadingMore = YES;
    //[Connections showGlobalProgressHUDWithTitle:@"Loading..."];
    pageOffset = 1;
    if (SHOW_LOADER) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Please Wait";
        hud.detailsLabelText = @"Loading...";
        SHOW_LOADER = NO;
    }
         
    if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.homeCustomTable.bounds.size.height, self.homeCustomTable.frame.size.width, self.homeCustomTable.bounds.size.height)];
		view.delegate = self;
		[self.homeCustomTable addSubview:view];
		_refreshHeaderView = view;
	}
    
    [self reloadTableViewDataSource];
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    responseArr = [[NSMutableArray alloc] init];
}

-(void)reloadTableCell:(NSDictionary *)cellDetail andIndexpath:(NSIndexPath *)indexPath{
    [responseArr  replaceObjectAtIndex:indexPath.row withObject:cellDetail];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar_logo.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbutton setFrame:CGRectMake(0, 0, 50, 30)];
    [rightbutton setImage:[UIImage imageNamed:@"logout.png"] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(logoutButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = nextBtn;
    if (categoryId != nil) {
        UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftbutton setFrame:CGRectMake(0, 0, 51, 30)];
        [leftbutton setImage:[UIImage imageNamed:@"back_button.png"] forState:UIControlStateNormal];
        [leftbutton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
        self.navigationItem.leftBarButtonItem = backBtn;
    }
}

-(void)logoutButtonTapped{
    NSLog(@"Search button tapped");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LogoutSuccess" object:nil];
}
-(void)backButtonTapped{
    NSLog(@"Search button tapped");
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Connection Delagate

-(void)connectionDidRecievedResponse:(BOOL)isSuccess withData:(id)data andMessage:(NSString*)message{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    
    if (pageOffset > 1) {
        if ([data count]) {
            dataDic=data ;
            NSMutableArray *indexPathArr = [NSMutableArray arrayWithCapacity:[data count]];
            for (NSMutableDictionary *videoDic in data) {
                NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:[responseArr count] inSection:0];
                [responseArr insertObject:videoDic atIndex:[responseArr count]];
                [indexPathArr addObject:indexPath];
            }
            [self.homeCustomTable beginUpdates];
            [self.homeCustomTable insertRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationNone];
            /*
             NSIndexPath *deletedIndexPath = [NSIndexPath indexPathForRow:[articleList count] inSection:0];
             
             if (([self.homeCustomTable numberOfRowsInSection:0] > deletedIndexPath.row) && ([self.homeCustomTable numberOfRowsInSection:0] != 0)) {
             [self.homeCustomTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:deletedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
             }
             */
            [self.homeCustomTable endUpdates];
        }else {

            loadingMore = NO;
            
         // [self.homeCustomTable beginUpdates];
            
            NSIndexPath *deletedIndexPath = [NSIndexPath indexPathForRow:[responseArr count] inSection:0];
            if (([self.homeCustomTable numberOfRowsInSection:0] > deletedIndexPath.row) && ([self.homeCustomTable numberOfRowsInSection:0] != 0)) {
                [self.homeCustomTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:deletedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            
          //  [self.homeCustomTable endUpdates];
        
        }
        //[self loadImageData];
    }else {
        dataDic =[[NSMutableDictionary alloc]init];
        dataDic=data;
        
        [responseArr removeAllObjects];
        [responseArr addObjectsFromArray:data];
        [self.homeCustomTable reloadData];
    }
}
-(void)likeDidRecievedResponse:(BOOL)isSuccess withData:(id)data andMessage:(NSString*)message{
    if (isSuccess) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:[responseArr objectAtIndex:buttonIndexPath.row] ];
        NSMutableDictionary *countDic = [[NSMutableDictionary alloc]initWithDictionary:[dic objectForKey:@"counts"]];
        NSMutableDictionary *infoDic = [[NSMutableDictionary alloc]initWithDictionary:[dic objectForKey:@"info"]];
        if ([requestType isEqualToString:LIKE]) {
            [infoDic setObject:@"1" forKey:@"liked"];
        }else{
            [infoDic setObject:@"0" forKey:@"liked"];
        }
        [countDic setObject:[data objectForKey:@"likeCount"] forKey:@"likesCount"];
        [dic setObject:countDic forKey:@"counts"];
        [dic setObject:infoDic forKey:@"info"];

        [responseArr replaceObjectAtIndex:buttonIndexPath.row withObject:dic];
        HomeCustomCell *cell = (HomeCustomCell *)[self.homeCustomTable cellForRowAtIndexPath:buttonIndexPath];
        [cell.likeCountLabel setText:[NSString stringWithFormat:@"%@",[[dic objectForKey:@"counts"]objectForKey:@"likesCount"]]];
        NSLog(@"%@",data);
    }else{
        [commonFunction showAlertViewWithTitle:@"Alert!" andMessage:message andDelegate:nil];
    }
}

#pragma mark - UITableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (loadingMore  && [responseArr count] >= 10) {
        return [responseArr count] +1;
    }
    return [responseArr count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        
        NSString *identifier = @"Cell";
        HomeCustomCell *cell = (HomeCustomCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"HomeCustomCell" owner:nil options:nil];
            cell = [nibs objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.delegate = self;
        }
        NSMutableDictionary *cellContentDic = [NSMutableDictionary dictionaryWithDictionary:[self.responseArr objectAtIndex:indexPath.row]];
        NSLog(@"%@",cellContentDic);
        
        [cell.userNameLabel setText:[NSString stringWithFormat:@"%@",[[cellContentDic objectForKey:@"profile"]objectForKey:@"userName"]]];
        
        //////User Profile Pic Details 
         [cell.userDescriptionLabel setText:[NSString stringWithFormat:@"%@",[[cellContentDic objectForKey:@"info"]objectForKey:@"description"]]];
        [cell.dayAgoLabel setText:[NSString stringWithFormat:@"%@",[[cellContentDic objectForKey:@"info"]objectForKey:@"addedTime"]]];
        [cell.inThingsLabel setText:[NSString stringWithFormat:@"in %@",[[cellContentDic objectForKey:@"info"]objectForKey:@"albumName"]]];
        
        //////Comment Count/////
        if (![[[cellContentDic objectForKey:@"counts"]objectForKey:@"likesCount"] isEqualToString:@"0"]) {
            [cell.likeCountLabel setText:[NSString stringWithFormat:@"%@",[[cellContentDic objectForKey:@"counts"]objectForKey:@"likesCount"]]];
        }else{
            cell.likeImgView.hidden = YES;
        }
        
        if (![[[cellContentDic objectForKey:@"counts"]objectForKey:@"stickesCount"] isEqualToString:@"0"]) {
            [cell.storeCountLabel setText:[NSString stringWithFormat:@"%@",[[cellContentDic objectForKey:@"counts"]objectForKey:@"stickesCount"]]];
        }else{
            cell.stickImgView.hidden = YES;
        }
        
        if ([[[cellContentDic objectForKey:@"info"]objectForKey:@"liked"] intValue] != 0) {
            [cell.likeBtn setSelected:YES];
        }else{
            [cell.likeBtn setSelected:NO];
        }
         //[cell.likeCountLabel setText:[NSString stringWithFormat:@"%@",[[cellContentDic objectForKey:@"counts"]objectForKey:@"likesCount"]]];
         [cell.commentCountLabel setText:[NSString stringWithFormat:@"%@",[[cellContentDic objectForKey:@"counts"]objectForKey:@"commentsCount"]]];
         //[cell.storeCountLabel setText:[NSString stringWithFormat:@"%@",[[cellContentDic objectForKey:@"counts"]objectForKey:@"stickesCount"]]];hmm,i have also make up my mind to this , that i will persue corresp. mba and till then will do dev., and after comp. that will try to switch in mba profile 
        NSString *commentsCount = [[cellContentDic objectForKey:@"counts"]objectForKey:@"commentsCount"];
        
        CGRect wallSize =  cell.wallUserImage.frame;
        wallSize.size.height = [[[cellContentDic objectForKey:@"info"] objectForKey:@"imageHeight"] floatValue]/2;
        cell.wallUserImage.frame = wallSize;
        
        CGRect commentFrame = cell.imageInfoView.frame;
        commentFrame.origin.y = cell.wallUserImage.frame.origin.y + cell.wallUserImage.frame.size.height;
         

        if ([commentsCount intValue] == 0) {
            [cell.commentView setHidden:YES];
           // commentFrame.size.height -= 90.0f;
        }else{
            [cell.commentView setHidden:NO];
           // commentFrame.size.height -= 90.0f;

            NSArray * commentArr  = [cellContentDic objectForKey:@"comments"];
            [cell.commentCountUIButton setTitle:[NSString stringWithFormat:@"View All(%@)Comments ", commentsCount]forState:UIControlStateNormal] ;
            NSDictionary *commentDic = [commentArr objectAtIndex:0];
            
            NSString *userName = [commentDic objectForKey:@"userName"];
            NSString *comment = [NSString stringWithFormat:@"%@",[commentDic objectForKey:@"commentBody"]];
            NSString *commentDetail = [NSString stringWithFormat:@"%@\n%@", userName, comment];
            
            NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:commentDetail];
                        
            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:47.0f/255.0f green:125.0f/255.0f blue:191.0f/255.0f alpha:1.0f] range:NSMakeRange(0, [userName length])];
            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange([userName length]+1, [comment length])];
            UIFont *font = [UIFont fontWithName:@"Helvetica" size:12.0f];

            [attString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [commentDetail length])];

            cell.commentUserNameLabel1.attributedText = attString;
            
            if ([commentArr count] > 1) {
                //commentFrame.size.height += 90.0f;

                commentDic = [commentArr objectAtIndex:1];
                [cell.commentUserNameLabel2 setHidden:NO];

                NSString *userName = [commentDic objectForKey:@"userName"];
                NSString *comment = [NSString stringWithFormat:@"%@",[commentDic objectForKey:@"commentBody"]];
                NSString *commentDetail = [NSString stringWithFormat:@"%@\n%@", userName, comment];
                
                NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:commentDetail];
                
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:47.0f/255.0f green:125.0f/255.0f blue:191.0f/255.0f alpha:1.0f] range:NSMakeRange(0, [userName length])];
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange([userName length]+1, [comment length])];
                [attString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [commentDetail length])];
                cell.commentUserNameLabel2.attributedText = attString;
            }else{
                //commentFrame.size.height -= 45.0f;

                [cell.commentUserNameLabel2 setHidden:YES];
            }
        }
        cell.imageInfoView.frame = commentFrame;
        /*
        if ([[cellContentDic allKeys] containsObject:@"postImage"]) {
            cell.wallUserImage.image = [cellContentDic objectForKey:@"postImage"]; 
        }
        
        if ([[cellContentDic allKeys] containsObject:@"userImage"]) {
            cell.userImage.image = [cellContentDic objectForKey:@"userImage"];
        }
         */

        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(concurrentQueue, ^{
        UIImage *userImage, *postImage;

        if (![[cellContentDic allKeys] containsObject:@"userImage"]) {
            NSString *imagePath = [GET_IMAGE_HOST_URL stringByAppendingFormat:@"%@", [[cellContentDic objectForKey:@"profile"]objectForKey:@"userPicture"]];
            NSURL *dataURL = [NSURL URLWithString:imagePath];
            NSData *imgData = [NSData dataWithContentsOfURL:dataURL];
            userImage = [UIImage imageWithData:imgData];
        }
        if (![[cellContentDic allKeys] containsObject:@"postImage"]) {
                NSString *imagePath = [GET_IMAGE_HOST_URL stringByAppendingFormat:@"%@", [[cellContentDic objectForKey:@"info"]objectForKey:@"image"]];
                NSURL *dataURL = [NSURL URLWithString:[imagePath stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
                NSData *imgData = [NSData dataWithContentsOfURL:dataURL];
                postImage = [UIImage imageWithData:imgData];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![[cellContentDic allKeys] containsObject:@"userImage"]) {
                if (userImage!=nil) {
                    [cellContentDic setObject:userImage forKey:@"userImage"];
                    [self.responseArr replaceObjectAtIndex:indexPath.row withObject:cellContentDic];
                }
            }
            if (![[cellContentDic allKeys] containsObject:@"postImage"]) {
                if (postImage!=nil) {
                    [cellContentDic setObject:postImage forKey:@"postImage"];
                    [self.responseArr replaceObjectAtIndex:indexPath.row withObject:cellContentDic];
                }
            }
            cell.userImage.image = [cellContentDic objectForKey:@"userImage"];
            cell.wallUserImage.image = [cellContentDic objectForKey:@"postImage"];
           });
        });
 
        return cell;
    }
    @catch (NSException *exception) {
        NSString *identifier = @"loadingCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        for (UIView *v in cell.contentView.subviews) {
            [v removeFromSuperview];
        }
        
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadingView setFrame:CGRectMake(200.0f, 25.0f, 5.0f, 5.0f)];
        [loadingView startAnimating];
        [cell.contentView addSubview:loadingView];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(85.0f, 5.0f, 200.0f, 44.0f)];
        [lbl setFont:[UIFont systemFontOfSize:16.0]];
        [lbl setTextColor:[UIColor colorWithRed:96/255.0 green:104/255.0 blue:114/255.0 alpha:0.9]];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setText:@"Loading More"];
        [cell.contentView addSubview:lbl];
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    tableIndex = indexPath.row;
    NSLog(@"indexPath");
    homeDetailViewController *controller = [[homeDetailViewController alloc] initWithNibName:@"homeDetailViewController" bundle:nil];
    controller.delegate = self;
    controller.imageDetail = [[NSMutableDictionary alloc] initWithDictionary:[responseArr objectAtIndex:indexPath.row]];
    controller.cellIndexPath = indexPath;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger rowNumber = [responseArr count];
    if (indexPath.row == rowNumber && rowNumber >= 10 && loadingMore) {
        pageOffset ++;
        [self reloadTableViewDataSource];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [responseArr count]) 
        return 44.0f;
    else{
        NSMutableDictionary *cellContentDic = [NSMutableDictionary dictionaryWithDictionary:[self.responseArr objectAtIndex:indexPath.row]];
        NSString *commentsCount = [[cellContentDic objectForKey:@"counts"]objectForKey:@"commentsCount"];
        
        myString = [[NSString alloc]initWithFormat:@"%@",(![[[[cellContentDic objectForKey:@"info"] objectForKey:@"imageHeight"] class] isKindOfClass:[NSNull class]])?[[cellContentDic objectForKey:@"info"] objectForKey:@"imageHeight"]:@"null"];
  
         if ([myString isEqualToString:@"<null>"] ) {
             return 400;
        }
        else{
            float imgHeight = [[[cellContentDic objectForKey:@"info"] objectForKey:@"imageHeight"] floatValue];
            imgHeight = imgHeight/2 - 137.0f;
            if ([commentsCount intValue] == 1) {
                //imgHeight -= 45.0f;
            }else if([commentsCount intValue] == 0){
                //imgHeight -= 90.0f;
            }
            return 400 + imgHeight;
        }
    }
}

-(void)reloadTableViewDataSource{
    BOOL isLoading;
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
    [postParams setObject:USER_ID forKey:@"userId"];
    [postParams setObject:[NSString stringWithFormat:@"%d",pageOffset] forKey:@"offset"];
    if (categoryId != nil) {
        [postParams setObject:categoryId forKey:@"categoryId"];
    }
    (pageOffset > 1)?(isLoading = NO):(isLoading = YES);

    connectionObj = [[Connections alloc] init];
    [connectionObj setDelegate:self];
    [connectionObj setRequestType:home_Screen_Tab];
    [connectionObj sendRequestWithPath:home_Screen_Tab andParameters:postParams showLoader:isLoading];
}

/*
 * Author:  Vipul Singhania
 * Purpose: When loding is done on pull down this finction is called.
 * Date:    17Oct2012
 */
- (void)doneLoadingTableViewData{
	//  model should call this when its done loading
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.homeCustomTable];
}

#pragma mark - NSOperationQueue Functions
/*
 Author: Utkarsh Goel
 Purpose: Implement Lazy Loading of user image in activity feed listing by creating a NSOperatinQueue.
 Date Modified: 15-Oct-2012
 */
- (void)loadImageData {
    NSOperationQueue *queue = [NSOperationQueue new];
    for (int j = 0; j < [responseArr count]; j++) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:j inSection:0];
            /* Create our NSInvocationOperation to call loadDataWithOperation, passing in nil */
        NSInvocationOperation *operation1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadDataWithOperation1:) object:indexpath];
        NSInvocationOperation *operation2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadDataWithOperation2:) object:indexpath];
            /* Add the operation to the queue */
        [queue addOperation:operation1];
        [queue addOperation:operation2];
    }
}
/*
 Author: Vipul Singhania
 Purpose: Handling the image downloading and updating the images in challenges list.
 Date Modified: 04Jun2013
 */
- (void)loadDataWithOperation1:(NSIndexPath*)indexPath {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:[responseArr objectAtIndex:indexPath.row]];
    
    if (![[dic allKeys] containsObject:@"postImage"]) {
        NSString *imagePath = [GET_IMAGE_HOST_URL stringByAppendingFormat:@"%@", [[dic objectForKey:@"info"]objectForKey:@"image"]];
        NSURL *dataURL = [NSURL URLWithString:imagePath];
        NSData *imgData = [NSData dataWithContentsOfURL:dataURL];
        [dic setObject:[UIImage imageWithData:imgData] forKey:@"postImage"];
        [responseArr replaceObjectAtIndex:indexPath.row withObject:dic];
        [self performSelectorOnMainThread:@selector(reloadTableRow:) withObject:indexPath waitUntilDone:NO];
    }
}
/*
 Author: Vipul Singhania
 Purpose: Handling the image downloading and updating the images in challenges list.
 Date Modified: 04Jun2013
 */
- (void)loadDataWithOperation2:(NSIndexPath*)indexPath {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:[responseArr objectAtIndex:indexPath.row]];
    
    if (![[dic allKeys] containsObject:@"userImage"]) {
        //NSURL *dataURL = [NSURL URLWithString:[dic objectForKey:@"image_url"]];
        NSString *imagePath = [GET_IMAGE_HOST_URL stringByAppendingFormat:@"%@", [[dic objectForKey:@"profile"]objectForKey:@"userPicture"]];
        NSURL *dataURL = [NSURL URLWithString:imagePath];
        NSData *imgData = [NSData dataWithContentsOfURL:dataURL];
        [dic setObject:[UIImage imageWithData:imgData] forKey:@"userImage"];
        [responseArr replaceObjectAtIndex:indexPath.row withObject:dic];
        [self performSelectorOnMainThread:@selector(reloadTableRow:) withObject:indexPath waitUntilDone:NO];
    }
}

/*
 Author: Vipul Singhania
 Purpose: Replacing the cell with a new cell containing
 Date Modified: 04Jun2013
 */
-(void)reloadTableRow:(NSIndexPath*)indexPath{
    if ([responseArr count]) {
        // [self.feedTbl reloadRowsAtIndexPaths:[self indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.homeCustomTable  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark -
#pragma mark HomeCustomCellDelegate Methods

-(void)likeAction:(NSIndexPath *)indexPath{
   // [self.homeCustomTable reloadInputViews];
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
    [postParams setObject:USER_ID forKey:@"userId"];
    [postParams setObject:[[[responseArr objectAtIndex:indexPath.row] objectForKey:@"info"] objectForKey:@"imageId"] forKey:@"imageId"];
    buttonIndexPath = indexPath;
    Connections *connections = [[Connections alloc] init];
    [connections setDelegate:self];
    [connections setRequestType:LIKE];
    requestType = LIKE;
    [connections sendRequestWithPath:LIKE andParameters:postParams showLoader:YES];

}

-(void)unlikeAction:(NSIndexPath *)indexPath{
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
    [postParams setObject:USER_ID forKey:@"userId"];
    [postParams setObject:[[[responseArr objectAtIndex:indexPath.row] objectForKey:@"info"] objectForKey:@"imageId"] forKey:@"imageId"];
    buttonIndexPath = indexPath;
    Connections *connections = [[Connections alloc] init];
    [connections setDelegate:self];
    [connections setRequestType:UNLIKE];
    requestType = UNLIKE;

    [connections sendRequestWithPath:UNLIKE andParameters:postParams showLoader:YES];
}

-(void)showUserProfile:(NSIndexPath *)indexPath{
    userProfileViewController *controller = [[userProfileViewController alloc] initWithNibName:@"userProfileViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
/*
 * Author:  Vipul Singhania
 * Purpose: Starts refreshong the table view.
 * Date:    27Sept2012
 */

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    if (_reloading == NO) {
        pageOffset = 1;
        [self reloadTableViewDataSource];
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    }
}
/*
 * Author:  Vipul Singhania
 * Purpose: It notifies that table is still loading data.
 * Date:    27Sept2012
 */

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	// should return if data source model is reloading
	return _reloading; 
}
/*
 * Author:  Vipul Singhania
 * Purpose: Sets refresh date.
 * Date:    17Oct2012
 */

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidEndDragging:(UIScrollView *)sender willDecelerate:(BOOL)decelerate{
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:sender];
        //sender.contentInset = UIEdgeInsetsMake(5.0f, 0.0f, 0.0f, 0.0f);
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    [_refreshHeaderView egoRefreshScrollViewDidScroll:sender];
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    //sender.contentInset = UIEdgeInsetsMake(5.0f, 0.0f, 0.0f, 0.0f);

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
