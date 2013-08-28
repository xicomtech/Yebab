//
//  hashTagViewController.h
//  Yebab
//
//  Created by Xicom on 07/06/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connections.h"

@interface hashTagViewController : UIViewController<ConnectionsDelegate>{
    NSArray *hashTagList;
}
@property (strong, nonatomic) IBOutlet UITableView *hashTable;

@end
