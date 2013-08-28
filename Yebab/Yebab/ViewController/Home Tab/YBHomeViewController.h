//
//  YBHomeViewController.h
//  Yebab
//
//  Created by xicom-213 on 4/25/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeCustomCell.h"
#import "Connections.h"
#import "EGORefreshTableHeaderView.h"
#import "LoadingMoreFooterView.h"
#import "homeDetailViewController.h"

@interface YBHomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ConnectionsDelegate,EGORefreshTableHeaderDelegate,homeCustomCelldelegate,homeDetailDelegate>{
    
    EGORefreshTableHeaderView *_refreshHeaderView;
     Connections *connectionObj;
    BOOL _reloading;
    NSMutableArray *responseArr;
    IBOutlet UITableView *homeCustomTable;
    NSInteger pageOffset;
    BOOL loadingMore;
    NSIndexPath *buttonIndexPath;
    NSString *requestType;
    //IBOutlet UITableView *homeTableView;
    //BOOL isUpdateMainView;
    
    NSString *myString ;
    NSMutableDictionary *dataDic ;
}
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@property(nonatomic,retain) NSMutableArray *responseArr;
@property(nonatomic,retain) IBOutlet UITableView *homeCustomTable;
@property (nonatomic, retain) NSString *categoryId;
@property (nonatomic, retain) NSString *myString ;
@end
