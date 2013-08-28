//
//  createAlbumViewController.h
//  Yebab
//
//  Created by Xicom on 12/06/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connections.h"
@protocol SecondViewControllerDelegate;

@interface createAlbumViewController : UIViewController<UITextFieldDelegate,ConnectionsDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSArray *categoryList;
    NSString *requestType;
    NSDictionary *categoryDic;
    
    BOOL buttonClick ;
    NSArray *albumList;

     int selectedRow;
 
    UITableView *categoryTbl ;
    
    id<SecondViewControllerDelegate> delegate;
    NSMutableArray *arForIPs ;
    NSMutableArray *arFollower ;
    
}

@property (nonatomic, retain) id<SecondViewControllerDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *arForIPs ;
@property (nonatomic, retain) NSMutableArray *arFollower ;
@property (strong, nonatomic) IBOutlet UITableView *categoryTbl;
@property (strong, nonatomic) NSArray *categoryList;

@end


@protocol SecondViewControllerDelegate
- (void)secondViewControllerDidFinish:(createAlbumViewController*)createAlbumViewController;
@end

