//
//  createAlbumViewController.m
//  Yebab
//
//  Created by Xicom on 12/06/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import "createAlbumViewController.h"

@interface createAlbumViewController ()

@end

@implementation createAlbumViewController
@synthesize  categoryTbl,categoryList,arForIPs;
@synthesize delegate,arFollower;

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
    self.navigationItem.title = @"Select Followers";

    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton setFrame:CGRectMake(0, 0, 51, 30)];
    [leftbutton setImage:[UIImage imageNamed:@"back_button.png"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbutton setFrame:CGRectMake(0, 0, 50, 30)];
    [rightbutton setImage:[UIImage imageNamed:@"save_button.png"] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = nextBtn;

    arForIPs=[NSMutableArray array];
    arFollower = [NSMutableArray array];;
     NSLog(@"list:%@",categoryList);
    
}
-(void)backButtonTapped{
    [arFollower removeAllObjects];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

//method called to navigate back
-(IBAction)cancel:(id)sender{
   [self.navigationController popViewControllerAnimated:YES];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [categoryList count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        NSString *identifier = @"City Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
            
        }
        
        if([arForIPs containsObject:indexPath]){
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            } else {
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
            cell.textLabel.text = [[categoryList objectAtIndex:indexPath.row]objectForKey:@"username"];

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
    
     selectedRow = [indexPath row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [arForIPs removeObject:indexPath];
        
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
       [arForIPs addObject:indexPath];
        [arFollower addObject:[categoryList objectAtIndex:indexPath.row]];
        
    }[delegate secondViewControllerDidFinish:self];
        [categoryTbl reloadData];
         
}

@end
