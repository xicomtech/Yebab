//
//  YBDiscoverViewController.m
//  Yebab
//
//  Created by sushil on 02/05/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import "YBDiscoverViewController.h"
#import "YBHomeViewController.h"
#import "hashTagViewController.h"
#import "YBSelectInterestViewController.h"

@interface YBDiscoverViewController ()

@end

@implementation YBDiscoverViewController

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
    self.navigationItem.title = @"Discover";
    categoryList = [[NSMutableArray alloc] init];
    [self fetchCategory];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.title = @"Discover";
}
-(void)nextBtnTapped{
    
}
-(void)fetchCategory{
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
    Connections *connections = [[Connections alloc] init];
    [connections setDelegate:self];
    requestType = DISCOVER_SCREEN;
    [connections setRequestType:DISCOVER_SCREEN];
    [connections sendRequestWithPath:DISCOVER_SCREEN andParameters:postParams showLoader:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)createCategoryView{
    int totalCount = [categoryList count];
    UIView *categoryView = [[UIView alloc] init];
    [categoryView setBackgroundColor:[UIColor clearColor]];
    for (int i = 0; i< totalCount; i++) {
        NSArray *categoryArr = [categoryList objectAtIndex:i];
        UIView *catSubView = [[UIView alloc] initWithFrame:CGRectMake(0,100*i , 320, 100)];
        for (int j = 0; j< [categoryArr count]; j++) {
            NSString *categoryName = [[categoryArr objectAtIndex:j] objectForKey:@"categoryName"];

            UIView *catView = [[UIView alloc] initWithFrame:CGRectMake(105*j +5, 5, 100, 90)];
            UIImageView *catImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 90)];
            [catImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[categoryName lowercaseString]]]];

            UIImageView *labelBckImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 70, 100, 20)];
            [labelBckImg setImage:[UIImage imageNamed:@"image_overlay.png"]];
            
            UIButton *catBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [catBtn setFrame:CGRectMake(0, 0, 100, 90)];
            [catBtn addTarget:self action:@selector(categoryBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
            [catBtn setTag:[[[categoryArr objectAtIndex:j] objectForKey:@"categoryId"] intValue]];
            
            UILabel *catName = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 100, 20)];
            [catName setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0f]];
            [catName setTextColor:[UIColor whiteColor]];
            [catName setTextAlignment:NSTextAlignmentCenter];
            [catName setText:categoryName];
            [catName setBackgroundColor:[UIColor clearColor]];
            
            [catView addSubview:catImg];
            [catView addSubview:labelBckImg];
            [catView addSubview:catName];
            [catView addSubview:catBtn];
            
            catView.clipsToBounds = YES;
            catView.layer.cornerRadius = 8.0f;
            [catSubView addSubview:catView];
        }
        [categoryView addSubview:catSubView];
    }
    [categoryView setFrame:CGRectMake(0, 158, 320, 100*totalCount)];
    [self.discoverListView addSubview:categoryView];
    CGRect discoverFrame = self.discoverListView.frame;
    discoverFrame.size.height = categoryView.frame.size.height + 160;
    [self.discoverListView setFrame:discoverFrame];
    [self.discoverScroll setContentSize:CGSizeMake(320, categoryView.frame.size.height +215.0f)];
}

-(IBAction)categoryBtnTapped:(id)sender{
     UIButton *btn = (UIButton *)sender;
    YBHomeViewController *controller = [[YBHomeViewController alloc] initWithNibName:@"YBHomeViewController" bundle:nil];
    controller.categoryId = [NSString stringWithFormat:@"%d",btn.tag];
    [self.navigationController pushViewController:controller animated:YES];

}
#pragma mark - Connection Delagate

-(void)connectionDidRecievedResponse:(BOOL)isSuccess withData:(id)data andMessage:(NSString *)message{
    if (isSuccess) {
        NSLog(@"%d",[data count]);
        if ([requestType isEqualToString:DISCOVER_SCREEN]) {
            NSMutableArray *tempArr =[[NSMutableArray alloc] init];
            for (int i = 0; i <[data count]; i++) {
                if ([tempArr count]<3) {
                    [tempArr addObject:[data objectAtIndex:i]];
                }else{
                    NSArray *arr = [NSArray arrayWithArray:tempArr];
                    [categoryList addObject:arr];
                    [tempArr removeAllObjects];
                    [tempArr addObject:[data objectAtIndex:i]];
                }
            }
            if ([tempArr count]) {
                [categoryList addObject:tempArr];
            }
            [self createCategoryView];
            //[self.categoryTbl reloadData];
           // [self.categoryTbl setFrame:CGRectMake(self.categoryTbl.frame.origin.x,self.categoryTbl.frame.origin.y , self.categoryTbl.frame.size.width,100* [categoryList count])];
        }else if ([requestType isEqualToString:HASH_TAGS]){
            NSLog(@"%@",data);
        }
    }
}
/*
#pragma mark - UITableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [categoryList count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        [self.discoverScroll setContentSize:CGSizeMake(320, self.categoryTbl.contentSize.height+213.0f)];
        NSString *identifier = @"Cell";
        categoryCell *cell = (categoryCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"categoryCell" owner:nil options:nil];
            cell = [nibs objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.delegate = self;
        }
        NSArray *arr = [NSArray arrayWithArray:[categoryList objectAtIndex:indexPath.row]];
        [cell loadData:arr];
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
-(void)categoryAction:(NSInteger)btnTag{
    YBHomeViewController *controller = [[YBHomeViewController alloc] initWithNibName:@"YBHomeViewController" bundle:nil];
    controller.categoryId = [NSString stringWithFormat:@"%d",btnTag];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)searchBtnTapped:(id)sender {
    NSLog(@"dgnkdfnhklnfgklhn");
}


- (IBAction)pictureBtnTapped:(id)sender {
}


- (IBAction)hashTagBtnTapped:(id)sender {
    hashTagViewController *controller = [[hashTagViewController alloc] initWithNibName:@"hashTagViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    /*
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
    Connections *connections = [[Connections alloc] init];
    [connections setDelegate:self];
    requestType = HASH_TAGS;
    [connections setRequestType:HASH_TAGS];
    [connections sendRequestWithPath:HASH_TAGS andParameters:postParams showLoader:YES];
     */
}


- (IBAction)userBtnTapped:(id)sender {
    YBSelectInterestViewController *controller = [[YBSelectInterestViewController alloc] initWithNibName:@"YBSelectInterestViewController" bundle:nil];
    controller.isTrending = YES;
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)viewDidUnload {
    [self setCategoryTbl:nil];
    [self setDiscoverScroll:nil];
    [self setDiscoverListView:nil];
    [super viewDidUnload];
}

@end
