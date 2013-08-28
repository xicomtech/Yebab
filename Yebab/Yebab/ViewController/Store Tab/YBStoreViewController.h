//
//  YBStoreViewController.h
//  Yebab
//
//  Created by Xicom on 06/06/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterflowView.h"
#import "Connections.h"
#import "CollectionViewController.h"

@interface YBStoreViewController : UIViewController<WaterflowViewDelegate,WaterflowViewDatasource,UIScrollViewDelegate,ConnectionsDelegate>{
    int count;
    WaterflowView *flowView;
    NSMutableDictionary * imgDic;
    NSMutableArray *btnArray;
    NSString *requestType;
    NSInteger storeCategoryId, pageOffset;
    NSArray *categoryList, *tempStoreList;
    NSMutableArray *storeList, *flowStoreList;
    BOOL loadingMore;
    WaterflowCollectionViewController *controller;
}
@property (strong, nonatomic) IBOutlet UIView *listView;
@property (strong, nonatomic) IBOutlet UIScrollView *btnScrollView;

- (IBAction)changeLayout:(id)sender;
- (IBAction)categoryBtnTapped:(id)sender;
@property (strong, nonatomic) NSMutableArray * cellHeight;
@property (strong, nonatomic) IBOutlet UIView *categoryBtnView;
@property (strong, nonatomic) IBOutlet UITableView *storeTbl;
@property (strong, nonatomic) IBOutlet UIView *underLineView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *categoryBtnCollection;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *layoutCollection;
@property (strong, nonatomic) IBOutlet UIView *cityView;
@property (strong, nonatomic) IBOutlet UITableView *cityTbl;
- (IBAction)cityBtnTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *cityBtn;
@end
