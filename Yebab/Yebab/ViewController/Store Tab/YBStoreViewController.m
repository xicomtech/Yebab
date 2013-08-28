//
//  YBStoreViewController.m
//  Yebab
//
//  Created by Xicom on 06/06/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import "YBStoreViewController.h"
#import "storeCell.h"
#import <QuartzCore/QuartzCore.h>
#import "WaterFlowLayout.h"
#import "ColllectionViewCell.h"

@interface YBStoreViewController ()
@property (nonatomic,retain) NSMutableArray *imageUrls;
@property (nonatomic,readwrite) int currentPage;
@end

@implementation YBStoreViewController
@synthesize imageUrls=_imageUrls;
@synthesize currentPage=_currentPage;
@synthesize  cellHeight = _cellHeight;

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
    [Connections showGlobalProgressHUDWithTitle:@"Loading..."];
    loadingMore = YES;
    flowStoreList = [[NSMutableArray alloc] init];
    imgDic = [[NSMutableDictionary alloc] init];
    _cellHeight = [[NSMutableArray alloc] init];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar_logo.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbutton setFrame:CGRectMake(0, 0, 50, 30)];
    [rightbutton setImage:[UIImage imageNamed:@"icon_search.png"] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(searchBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = nextBtn;
    [self changeLayout:[_layoutCollection objectAtIndex:0]];
    
    /*
    WaterFlowLayout *layout = [[WaterFlowLayout alloc]init];
    controller = [[WaterflowCollectionViewController alloc]initWithCollectionViewLayout:layout];
     */

    //[self.listView addSubview:controller.view];
    self.currentPage = 1;
    self.imageUrls = [NSMutableArray array];
    self.imageUrls = [NSArray arrayWithObjects:@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://photo.l99.com/bigger/22/1284013907276_zb834a.jpg",@"http://www.webdesign.org/img_articles/7072/BW-kitten.jpg",@"http://www.raiseakitten.com/wp-content/uploads/2012/03/kitten.jpg",@"http://imagecache6.allposters.com/LRG/21/2144/C8BCD00Z.jpg",nil];
    btnArray = [[NSMutableArray alloc] init];
    storeList = [[NSMutableArray alloc] init];

    [self fetchCategory];

    /*
    self.categoryBtnView.clipsToBounds = YES;
    self.categoryBtnView.layer.cornerRadius = 5.0f;
    self.categoryBtnView.layer.borderColor = [UIColor redColor].CGColor;
    self.categoryBtnView.layer.borderWidth = 1.0f;
     */

    // Do any additional setup after loading the view from its nib.
}
-(void)addWaterflowLayout{
    flowView = [[WaterflowView alloc] initWithFrame:CGRectMake(0, 10.0f, 320.0f, self.view.window.frame.size.height - 183)];
    flowView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    flowView.flowdatasource = self;
    flowView.flowdelegate = self;
    [self.listView addSubview:flowView];    
}
-(void)createBtnScroll{
    float previousXCordinate = 0.0f;
    
    NSInteger totalCount = [categoryList count];
    for (int i = 0 ; i < totalCount; i++) {
        NSString *btnTitle = [[categoryList objectAtIndex:i] objectForKey:@"categoryName"];
        CGSize textLabelSize = [btnTitle sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(previousXCordinate, 0, textLabelSize.width + 20.0f, 35)];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:27/255.0f green:173/255.0f blue:124/255.0f alpha:1.0f ] forState:UIControlStateSelected];
        [btn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
        [btn setTitle:btnTitle forState:UIControlStateNormal];
        [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [btn addTarget:self action:@selector(categoryBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:[[[categoryList objectAtIndex:i] objectForKey:@"categoryId"]intValue]];
        [btnArray addObject:btn];
        [self.btnScrollView addSubview:btn];
        previousXCordinate += btn.frame.size.width;
    }
    [self.btnScrollView setContentSize:CGSizeMake(previousXCordinate, 35)];
    [self categoryBtnTapped:[btnArray objectAtIndex:0]];
}

-(void)fetchStoreData{
    BOOL isLoading;
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
    [postParams setObject:[NSString stringWithFormat:@"%d",pageOffset] forKey:@"offset"];
    [postParams setObject:[NSString stringWithFormat:@"%d",storeCategoryId] forKey:@"categoryId"];
    (pageOffset > 1)?(isLoading = NO):(isLoading = YES);

    Connections *connections = [[Connections alloc] init];
    [connections setDelegate:self];
    requestType = STORE_SCREEN;
    [connections setRequestType:STORE_SCREEN];
    [connections sendRequestWithPath:STORE_SCREEN andParameters:postParams showLoader:isLoading];
}

-(void)fetchCategory{
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
    Connections *connections = [[Connections alloc] init];
    [connections setDelegate:self];
    requestType = DISCOVER_SCREEN;
    [connections setRequestType:DISCOVER_SCREEN];
    [connections sendRequestWithPath:DISCOVER_SCREEN andParameters:postParams showLoader:NO];
}
-(void)searchBtnTapped{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeLayout:(id)sender {
    //[self.storeTbl setHidden:YES];
    UIButton *btn = (UIButton *)sender;
    if (![btn isSelected]) {
        for (UIButton *btn1 in _layoutCollection) {
            [btn1 setSelected:NO];
        }
        [btn setSelected:YES];
    }
    if ([btn.titleLabel.text isEqualToString:@"grid"]) {
        [flowView setHidden:NO];
        [self.storeTbl setHidden:YES];
    }else{
        [flowView setHidden:YES];
        [self.storeTbl setHidden:NO];
    }
}


- (IBAction)categoryBtnTapped:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (![btn isSelected]) {
        for (UIButton *btn1 in btnArray) {
            [btn1 setSelected:NO];
        }
        
        [btn setSelected:YES];
        CGRect underLineViewSize = self.underLineView.frame;
        underLineViewSize.origin.x = btn.frame.origin.x;
        underLineViewSize.origin.y = btn.frame.size.height - underLineViewSize.size.height;
        underLineViewSize.size.width = btn.frame.size.width;
        self.underLineView.frame = underLineViewSize;
        [self.btnScrollView addSubview:self.underLineView];
        storeCategoryId = btn.tag;
        pageOffset = 1;
//        [imgDic removeAllObjects];
//        [storeList removeAllObjects];
//        [flowStoreList removeAllObjects];
//        [self.cellHeight removeAllObjects];
        [self fetchStoreData];
    }
}

- (IBAction)cityBtnTapped:(id)sender {
    if (![self.cityView isHidden]  ) {
        self.cityView.hidden =YES;
        return;
    }
    self.cityView.hidden = NO;
}

-(void)customInit{
    @try {
        
       CGFloat minHeight = 0.0f;
    NSInteger minHeightAtColumn = 0;
    NSInteger _cellCount = [storeList count];

    for (int i = 0; i< _cellCount ; i++)
    {
        //the first pics
        if(self.cellHeight.count < 2)
        {
            if ([[[storeList objectAtIndex:i] objectForKey:@"pictureHeight"]isEqual:(id)[NSNull null]]) {
                [self.cellHeight  addObject:[NSMutableArray arrayWithObject:[NSNumber numberWithFloat:246]]];
                minHeight = 246.0f;
            }else{
                [self.cellHeight  addObject:[NSMutableArray arrayWithObject:[NSNumber numberWithFloat:[[[storeList objectAtIndex:i] objectForKey:@"pictureHeight"] floatValue]]]];
                minHeight = [[[storeList objectAtIndex:i] objectForKey:@"pictureHeight"] floatValue];
            }
            [flowStoreList addObject:[NSMutableArray arrayWithObject:[storeList objectAtIndex:i]]];
            //[self.cellIndex addObject:[NSMutableArray arrayWithObject:[NSNumber numberWithInt:i]]];
            minHeightAtColumn ++;
            continue;
        }
        //find the column with the shortest height and insert the cell height into self.cellHeight[column]
        for (int j = 0; j< 2; j++)
        {
            NSMutableArray *cellHeightInPresentColumn = [NSMutableArray arrayWithArray:[self.cellHeight objectAtIndex:j]];
            if (floor([[cellHeightInPresentColumn lastObject]floatValue]) <= minHeight )
            {
                minHeight = [[cellHeightInPresentColumn lastObject]floatValue] +10;
                minHeightAtColumn = j;
            }
            /*else if (floor([[cellHeightInPresentColumn lastObject]floatValue]) == minHeight ){
                if (j < 1) {
                    if ([[self.cellHeight objectAtIndex:j+1] count] < [[self.cellHeight objectAtIndex:j] count]) {
                        minHeight = [[cellHeightInPresentColumn lastObject]floatValue] +10;
                        minHeightAtColumn = j+1;
                    }else{
                        minHeight = [[cellHeightInPresentColumn lastObject]floatValue] +10;
                        minHeightAtColumn = j;
                    }
                }else{
                    minHeight = [[cellHeightInPresentColumn lastObject]floatValue] +10;
                    minHeightAtColumn = j;
                }
                break;
            }
             */
        }
        if ([[[storeList objectAtIndex:i] objectForKey:@"pictureHeight"]isEqual:(id)[NSNull null]]) {
            [[self.cellHeight objectAtIndex:minHeightAtColumn] addObject:[NSNumber numberWithFloat:minHeight += 246]];
        }else{
            [[self.cellHeight objectAtIndex:minHeightAtColumn] addObject:[NSNumber numberWithFloat:minHeight +=[[[storeList objectAtIndex:i] objectForKey:@"pictureHeight"] floatValue]]];
        }
        [[flowStoreList objectAtIndex:minHeightAtColumn] addObject:[storeList objectAtIndex:i]];
    }
   // NSLog(@"%@",self.cellHeight);
   // NSLog(@"%@",flowStoreList);
    if (![[self.listView subviews] containsObject:flowView ]) {
        [self addWaterflowLayout];
    }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception debugDescription]);
    }
    
}


#pragma mark - Connection Delagate

-(void)connectionDidRecievedResponse:(BOOL)isSuccess withData:(id)data andMessage:(NSString *)message{
    if (isSuccess) {
        if ([data count]) {            
        if ([requestType isEqualToString:DISCOVER_SCREEN]) {
            categoryList = [[NSArray alloc] initWithArray:data];
            [self createBtnScroll];
        }else if ([requestType isEqualToString:STORE_SCREEN]){
            if (pageOffset > 1) {
                if ([data count]) {
                    NSMutableArray *indexPathArr = [NSMutableArray arrayWithCapacity:[data count]];
                    for (NSMutableDictionary *videoDic in data) {
                        NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:[storeList count] inSection:0];
                        [storeList insertObject:videoDic atIndex:[storeList count]];
                        [indexPathArr addObject:indexPath];
                    }
                    [self.storeTbl beginUpdates];
                    [self.storeTbl insertRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationNone];
                    [self.storeTbl endUpdates];
                }else {
                    [self.storeTbl beginUpdates];
                    NSIndexPath *deletedIndexPath = [NSIndexPath indexPathForRow:[storeList count] inSection:0];
                    if (([self.storeTbl numberOfRowsInSection:0] > deletedIndexPath.row) && ([self.storeTbl numberOfRowsInSection:0] != 0)) {
                        [self.storeTbl deleteRowsAtIndexPaths:[NSArray arrayWithObject:deletedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }
                    [self.storeTbl endUpdates];
                    loadingMore = NO;
                }
            }else {
                [storeList removeAllObjects];
                [storeList addObjectsFromArray:data];
                [self.storeTbl reloadData];
            }
            [self.cellHeight removeAllObjects];
            [flowStoreList removeAllObjects];
            [self customInit];
            [flowView reloadData];
            [self loadImageData];
        }
    }
        
    }
else{
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Response Data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [al show];
}
}

#pragma mark - UITableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 101) {
        if (loadingMore  && [storeList count] >= 10) {
            return [storeList count] +1;
        }
        return [storeList count];
    }
    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        if (tableView.tag == 101) {
            NSString *identifier = @"Cell";
            storeCell *cell = (storeCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"storeCell" owner:nil options:nil];
                cell = [nibs objectAtIndex:0];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
            [cell loadData:[storeList objectAtIndex:indexPath.row]];
            return cell;
        }else{
            NSString *identifier = @"City Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
            }
            cell.textLabel.text = @"New Delhi";
            return cell;
        }
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
    if (tableView.tag == 101) {
    }else{
        self.cityView.hidden = YES;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 101) {
        if (indexPath.row == [storeList count])
            return 44.0f;
        else
            return 75.0f;
    }
    return 33.0f;
}

-(void)tableView:(UITableView *) tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger rowNumber = [storeList count];
    if (indexPath.row == rowNumber && rowNumber >= 10 && loadingMore) {
        pageOffset++;
        [self fetchStoreData];
    }
}


#pragma mark- WaterflowDataSource

- (NSInteger)numberOfColumnsInFlowView:(WaterflowView *)flowView
{
    return 2;
}

- (NSInteger)flowView:(WaterflowView *)flowView numberOfRowsInColumn:(NSInteger)column
{
    if (![flowStoreList count]) {
        return 0;
    }
    return [[flowStoreList objectAtIndex:column] count];
}

- (WaterFlowCell*)flowView:(WaterflowView *)flowView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	WaterFlowCell *cell = [flowView_ dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil)
	{
		cell  = [[WaterFlowCell alloc] initWithReuseIdentifier:CellIdentifier];
		cell.backgroundColor = [UIColor whiteColor];
        cell.clipsToBounds = YES;
        
        cell.layer.cornerRadius = 6.0f;
        cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.layer.borderWidth = 1.0f;
        
        
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		[cell addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleToFill;
		imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
		imageView.layer.borderWidth = 1;
		imageView.tag = 1001;
        
        UIImageView *line= [[UIImageView alloc] init];
        [line setImage:[UIImage imageNamed:@"line.png"]];
        line.alpha = 0.5f;
        line.tag = 1002;
        // line.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [cell addSubview:line];
        
        UIImageView *userImg= [[UIImageView alloc] init];
        [userImg setImage:[UIImage imageNamed:@"add_pic.png"]];
        //userImg.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        userImg.tag = 1003;
        [cell addSubview:userImg];
        
        UILabel *storeNameLbl = [[UILabel alloc]init];
        storeNameLbl.textAlignment = NSTextAlignmentLeft;
        //  storeNameLbl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        storeNameLbl.backgroundColor = [UIColor clearColor];
        storeNameLbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:11.0f];
        storeNameLbl.tag = 1004;
        [cell addSubview:storeNameLbl];
        
        UILabel *cityLbl = [[UILabel alloc]initWithFrame:CGRectMake(40.0f,storeNameLbl.frame.size.height + storeNameLbl.frame.origin.y, 108.0f, 16)];
        cityLbl.textAlignment = NSTextAlignmentLeft;
        //cityLbl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        cityLbl.backgroundColor = [UIColor clearColor];
        cityLbl.font = [UIFont fontWithName:@"Helvetica" size:11.0f];
        cityLbl.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:170/255.0f alpha:1.0f];
        cityLbl.tag = 1005;
        [cell addSubview:cityLbl];
    }
    /*
    if (indexPath.row == 0 && indexPath.section == 0) {
        NSLog(@"vlcxjkvnkxnbjkxjvbjk  cvj bi");
    }
     */
	NSDictionary *storeDic = [[NSDictionary alloc] initWithDictionary:[[flowStoreList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    float height = [self flowView:nil heightForRowAtIndexPath:indexPath];
    
	UIImageView *asyncimageView  = (UIImageView *)[cell viewWithTag:1001];
	asyncimageView.frame = CGRectMake(0, 0, 150.0f, height-46);
    asyncimageView.image = [[imgDic objectForKey:[storeDic objectForKey:@"storeId"]] objectForKey:@"storeImage"];
    
    UIImageView *lineImg  = (UIImageView *)[cell viewWithTag:1002];
    lineImg.frame = CGRectMake(0, asyncimageView.frame.size.height, self.view.frame.size.width / 2 , 1.5f);
    
    UIImageView *storeLogoImg  = (UIImageView *)[cell viewWithTag:1003];
    storeLogoImg.frame = CGRectMake(5.0f, asyncimageView.frame.size.height+ 8.0f, 30.0f, 30.f);
    storeLogoImg.image = [[imgDic objectForKey:[storeDic objectForKey:@"storeId"]] objectForKey:@"storeLogoImage"];
    
    UILabel *storeNameLbl  = (UILabel *)[cell viewWithTag:1004];
    storeNameLbl.frame = CGRectMake(40.0f,asyncimageView.frame.size.height + 6.0f, 108.0f, 16);
    storeNameLbl.text = [storeDic objectForKey:@"storeName"];
    
    UILabel *cityLbl  = (UILabel *)[cell viewWithTag:1005];
    cityLbl.frame = CGRectMake(40.0f,storeNameLbl.frame.size.height + storeNameLbl.frame.origin.y, 108.0f, 16);
    cityLbl.text = [storeDic objectForKey:@"storeCities"];
    
	return cell;
}

#pragma mark-
#pragma mark- WaterflowDelegate

-(CGFloat)flowView:(WaterflowView *)flowView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	float height = 0;
    NSDictionary *storeDic  = [[NSDictionary alloc] initWithDictionary:[[flowStoreList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    if ([[storeDic objectForKey:@"pictureHeight"] isEqual:(id)[NSNull null]]) {
        return 246;
    }
    height = [[storeDic objectForKey:@"pictureHeight"] floatValue]/2;
    return height + 46.0f;
}


- (void)flowView:(WaterflowView *)flowView didSelectAtCell:(WaterFlowCell *)cell ForIndex:(int)index
{
    
}

- (void)flowView:(WaterflowView *)_flowView willLoadData:(int)page
{
    pageOffset = page;
    [self fetchStoreData];
    //make a judegement to decide whether to call reloadData or reloadFailed
}
#pragma mark - NSOperationQueue Functions
/*
 Author: Utkarsh Goel
 Purpose: Implement Lazy Loading of user image in activity feed listing by creating a NSOperatinQueue.
 Date Modified: 15-Oct-2012
 */
- (void)loadImageData {
    NSOperationQueue *queue = [NSOperationQueue new];
    for (int j = 0; j < [storeList count]; j++) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:j inSection:0];
        /* Create our NSInvocationOperation to call loadDataWithOperation, passing in nil */
        NSInvocationOperation *operation1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadDataWithOperation1:) object:indexpath];
        NSInvocationOperation *operation2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadDataWithOperation2:) object:indexpath];

        /* Add the operation to the queue */
        [queue addOperation:operation2];
        [queue addOperation:operation1];
    }
}
/*
 Author: Vipul Singhania
 Purpose: Handling the image downloading and updating the images in challenges list.
 Date Modified: 04Jun2013
 */
- (void)loadDataWithOperation1:(NSIndexPath*)indexPath {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:[storeList objectAtIndex:indexPath.row]];
    NSString *storeId = [dic objectForKey:@"storeId"];
    NSMutableDictionary *allImgDic = [[NSMutableDictionary alloc]initWithDictionary:[imgDic objectForKey:storeId]];
    
    if (![[dic allKeys] containsObject:@"storeImage"]) {
        NSString *imagePath = [GET_IMAGE_HOST_URL stringByAppendingFormat:@"%@", [dic objectForKey:@"storePicture"]];
        NSURL *dataURL = [NSURL URLWithString:[imagePath stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        NSData *imgData = [NSData dataWithContentsOfURL:dataURL];
        
        dic = [[NSMutableDictionary alloc]initWithDictionary:[storeList objectAtIndex:indexPath.row]];
        [dic setObject:[UIImage imageWithData:imgData] forKey:@"storeImage"];
        [storeList replaceObjectAtIndex:indexPath.row withObject:dic];
        allImgDic = [[NSMutableDictionary alloc]initWithDictionary:[imgDic objectForKey:storeId]];
        [allImgDic setObject:[UIImage imageWithData:imgData] forKey:@"storeImage"];
        [imgDic setObject:allImgDic forKey:storeId];
        [self performSelectorOnMainThread:@selector(reloadTableRow:) withObject:indexPath waitUntilDone:YES];
    }
}
/*
 Author: Vipul Singhania
 Purpose: Handling the image downloading and updating the images in challenges list.
 Date Modified: 04Jun2013
 */
- (void)loadDataWithOperation2:(NSIndexPath*)indexPath {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:[storeList objectAtIndex:indexPath.row]];
    NSString *storeId = [dic objectForKey:@"storeId"];
    NSMutableDictionary *allImgDic = [[NSMutableDictionary alloc]initWithDictionary:[imgDic objectForKey:storeId]];

    if (![[dic allKeys] containsObject:@"storeLogoImage"]) {
        NSString *imagePath = [GET_IMAGE_HOST_URL stringByAppendingFormat:@"%@", [dic objectForKey:@"storeLogo"]];
        NSURL *dataURL = [NSURL URLWithString:[imagePath stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        NSData *imgData = [NSData dataWithContentsOfURL:dataURL];
        
        dic = [[NSMutableDictionary alloc]initWithDictionary:[storeList objectAtIndex:indexPath.row]];
        [dic setObject:[UIImage imageWithData:imgData] forKey:@"storeLogoImage"];
        [storeList replaceObjectAtIndex:indexPath.row withObject:dic];
        allImgDic = [[NSMutableDictionary alloc]initWithDictionary:[imgDic objectForKey:storeId]];
        [allImgDic setObject:[UIImage imageWithData:imgData] forKey:@"storeLogoImage"];
        [imgDic setObject:allImgDic forKey:storeId];
        [self performSelectorOnMainThread:@selector(reloadTableRow:) withObject:indexPath waitUntilDone:YES];
    }
}

/*
 Author: Vipul Singhania
 Purpose: Replacing the cell with a new cell containing
 Date Modified: 04Jun2013
 */
-(void)reloadTableRow:(NSIndexPath*)indexPath{
    if ([storeList count]) {
        // [self.feedTbl reloadRowsAtIndexPaths:[self indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.storeTbl  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        [flowView reloadData];
    }
}

- (void)viewDidUnload {
    [self setStoreTbl:nil];
    [self setUnderLineView:nil];
    [self setCategoryBtnCollection:nil];
    [self setCategoryBtnView:nil];
    [self setLayoutCollection:nil];
    [self setListView:nil];
    [self setCityView:nil];
    [self setCityTbl:nil];
    [self setCityBtn:nil];
    [self setBtnScrollView:nil];
    [super viewDidUnload];
}

@end
