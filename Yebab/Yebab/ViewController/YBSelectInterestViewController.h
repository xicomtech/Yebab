//
//  YBSelectInterestViewController.h
//  Yebab
//
//  Created by xicom-213 on 4/18/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBSelectInterestCell.h"
#import "Connections.h"

@interface YBSelectInterestViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ConnectionsDelegate>{
    
   
    IBOutlet UIImageView *bgImg;
    IBOutlet UITableView *interestTable;
    IBOutlet UITableView *usersTableView;
    NSInteger tableIndex;
    NSMutableArray *responseArr;
}
@property (nonatomic, assign) BOOL isTrending;
@property(nonatomic,retain)NSMutableArray *responseArr;

@end
