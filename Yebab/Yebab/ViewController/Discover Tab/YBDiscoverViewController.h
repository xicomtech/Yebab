//
//  YBDiscoverViewController.h
//  Yebab
//
//  Created by sushil on 02/05/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connections.h"
#import "categoryCell.h"

@interface YBDiscoverViewController : UIViewController<ConnectionsDelegate,UITextFieldDelegate,categoryCellDelegate>{
    NSString *requestType;
    NSMutableArray *categoryList;
}
@property (strong, nonatomic) IBOutlet UIView *discoverListView;
@property (strong, nonatomic) IBOutlet UIScrollView *discoverScroll;
- (IBAction)hashTagBtnTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *categoryTbl;
- (IBAction)searchBtnTapped:(id)sender;
- (IBAction)userBtnTapped:(id)sender;
- (IBAction)pictureBtnTapped:(id)sender;
@end
