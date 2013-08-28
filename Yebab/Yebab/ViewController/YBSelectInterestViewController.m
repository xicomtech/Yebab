//
//  YBSelectInterestViewController.m
//  Yebab
//
//  Created by xicom-213 on 4/18/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import "YBSelectInterestViewController.h"
#import "YBInviteFriendViewController.h"

@interface YBSelectInterestViewController ()

@end

@implementation YBSelectInterestViewController
@synthesize responseArr, isTrending;

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
    
    [bgImg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]]];
    
    Connections *connection = [[Connections alloc] init];
    [connection setDelegate:self];
    [connection sendRequestWithPath:TRENDING_USERS andParameters:[NSDictionary dictionary] showLoader:YES];
}
-(void)connectionDidRecievedResponse:(BOOL)isSuccess withData:(id)data andMessage:(NSString*)message{
    NSLog(@"connectionDidRecievedResponse: Data: %@, message: %@",data,message);
    if (isSuccess) {
        if ([data count]) {
            self.responseArr = [[NSMutableArray alloc] initWithArray:data];
            [usersTableView reloadData];
            NSLog(@"%@",responseArr);
        }
    }    
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
    if (!isTrending) {
        UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightbutton setFrame:CGRectMake(0, 0, 51, 30)];
        [rightbutton setImage:[UIImage imageNamed:@"next_button.png"] forState:UIControlStateNormal];
        [rightbutton addTarget:self action:@selector(nextButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
        self.navigationItem.rightBarButtonItem = nextBtn;
    }
}

-(void)backButtonTapped{
    NSLog(@"back button Pressed");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)nextButtonTapped{
    NSLog(@"next button pressed");
    
    YBInviteFriendViewController  *inviteFriendView = [[YBInviteFriendViewController alloc]initWithNibName:@"YBInviteFriendViewController" bundle:nil];
    [self.navigationController pushViewController:inviteFriendView animated:YES];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController.navigationBar.topItem setTitle:@"User Suggestion"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar.topItem setTitle:@""];
}

#pragma mark - UITableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.responseArr count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"Cell";
    YBSelectInterestCell *cell = (YBSelectInterestCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"YBSelectInterestCell" owner:nil options:nil];
        cell = [nibs objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    NSMutableDictionary *cellContentDic = [NSMutableDictionary dictionaryWithDictionary:[self.responseArr objectAtIndex:indexPath.row]];
    
    [cell.userNameLbl setText:[NSString stringWithFormat:@"%@",[cellContentDic objectForKey:@"userName"]]];
    [cell.followersCountLbl setText:[NSString stringWithFormat:@"%@",[cellContentDic objectForKey:@"followersCount"]]];
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //this will start the image loading in bg
    dispatch_async(concurrentQueue, ^{
        UIImage *userImage;
        
        if (![[cellContentDic allKeys] containsObject:@"userImage"]) {
            NSURL *dataURL = [NSURL URLWithString:[GET_IMAGE_HOST_URL stringByAppendingFormat:@"%@", [cellContentDic objectForKey:@"userPicture"]]];
            NSData *imgData = [NSData dataWithContentsOfURL:dataURL];
            userImage = [UIImage imageWithData:imgData];
        }  
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![[cellContentDic allKeys] containsObject:@"userImage"]) {
                [cellContentDic setObject:userImage forKey:@"userImage"];
                [self.responseArr replaceObjectAtIndex:indexPath.row withObject:cellContentDic];
            }
            cell.userImage.image = [cellContentDic objectForKey:@"userImage"];
        });
    });
   
    for (NSMutableDictionary *dict in [cellContentDic objectForKey:@"pins"]) {
    NSMutableDictionary *pinDic = [NSMutableDictionary dictionaryWithDictionary:dict];
        
        dispatch_async(concurrentQueue, ^{
            UIImage *userImage;
            if (![[dict allKeys] containsObject:@"pinImage"]) {
                [pinDic setObject:@"" forKey:@"pinImage"];
                if ([dict objectForKey:@"pinPicture"]) {
                    NSURL *dataURL = [NSURL URLWithString:[[GET_IMAGE_HOST_URL stringByAppendingFormat:@"%@", [dict objectForKey:@"pinPicture"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    NSData *imgData = [NSData dataWithContentsOfURL:dataURL];
                    userImage = [UIImage imageWithData:imgData];
                }
            }else{
                userImage = [dict objectForKey:@"pinImage"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (userImage) {
                    if (![[pinDic objectForKey:@"pinImage"] isKindOfClass:[UIImage class]]) {
                        [pinDic setObject:userImage forKey:@"pinImage"];
                        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[cellContentDic objectForKey:@"pins"] objectAtIndex:[[cellContentDic objectForKey:@"pins"] indexOfObject:dict]]];
                        [dic setObject:userImage forKey:@"pinImage"];
                        NSMutableArray *arr = [NSMutableArray arrayWithArray:[[self.responseArr objectAtIndex:indexPath.row] objectForKey:@"pins"]];
                        [arr replaceObjectAtIndex:[[cellContentDic objectForKey:@"pins"] indexOfObject:dict] withObject:dic];
                        [cellContentDic setObject:arr forKey:@"pins"];
                        [self.responseArr replaceObjectAtIndex:indexPath.row withObject:cellContentDic];
                    }
                    if ([[pinDic objectForKey:@"pinImage"] isKindOfClass:[UIImage class]]) {
                        switch ([[cellContentDic objectForKey:@"pins"] indexOfObject:pinDic]) {
                            case 0:
                                [cell.followUser1 setImage:[pinDic objectForKey:@"pinImage"]];
                                break;
                            case 1:
                                [cell.followUser2 setImage:[pinDic objectForKey:@"pinImage"]];
                                break;
                            case 2:
                                [cell.followUser3 setImage:[pinDic objectForKey:@"pinImage"]];
                                break;
                            case 3:
                                [cell.followUser4 setImage:[pinDic objectForKey:@"pinImage"]];
                                break;
                            case 4:
                                [cell.followUser5 setImage:[pinDic objectForKey:@"pinImage"]];
                                break;
                                
                            default:
                                break;
                        }
                    }                
                }                
            });
        });
    }
    [cell.followbutton addTarget:self action:@selector(followButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//cell.followbutton
    /*
    if ([[cellContentDic allKeys] containsObject:@"image"]) {
        [cell.userImage setImage:[cellContentDic objectForKey:@"image"]];
    }*/
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    tableIndex = indexPath.row;
    NSLog(@"indexPath");
 
}
- (IBAction)followButtonClick:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    UITableViewCell *cell  = (UITableViewCell *)button.superview.superview;
    NSIndexPath *indexPath = [usersTableView indexPathForCell:cell];
    NSLog(@"%d",indexPath.row);
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
