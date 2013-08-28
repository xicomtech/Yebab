//
//  hashTagViewController.m
//  Yebab
//
//  Created by Xicom on 07/06/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import "hashTagViewController.h"

@interface hashTagViewController ()

@end

@implementation hashTagViewController

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
    self.navigationItem.title = @"Hash Tags";
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton setFrame:CGRectMake(0, 0, 51, 30)];
    [leftbutton setImage:[UIImage imageNamed:@"back_button.png"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem = backBtn;

    [self fetchHashTags];
    //[self fetchTrendingUsers];
    // Do any additional setup after loading the view from its nib.
}

-(void)fetchHashTags{
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
    Connections *connections = [[Connections alloc] init];
    [connections setDelegate:self];
    [connections setRequestType:HASH_TAGS];
    [connections sendRequestWithPath:HASH_TAGS andParameters:postParams showLoader:YES];
}
-(void)fetchTrendingUsers{
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
    Connections *connections = [[Connections alloc] init];
    [connections setDelegate:self];
    [connections setRequestType:TRENDING_USERS];
    [connections sendRequestWithPath:TRENDING_USERS andParameters:postParams showLoader:YES];
}
-(void)backButtonTapped{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Connection Delagate

-(void)connectionDidRecievedResponse:(BOOL)isSuccess withData:(id)data andMessage:(NSString *)message{
    if (isSuccess) {
        NSLog(@"%@",data);
        hashTagList = [[NSArray alloc] initWithArray:data];
        [self.hashTable reloadData];
    }
}

#pragma mark - UITableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [hashTagList count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] ;
    }
    cell.textLabel.text = [[hashTagList objectAtIndex:indexPath.row] objectForKey:@"hashTag"];
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0]];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setHashTable:nil];
    [super viewDidUnload];
}
@end
