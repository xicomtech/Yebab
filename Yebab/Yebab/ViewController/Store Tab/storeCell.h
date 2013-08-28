//
//  storeCell.h
//  Yebab
//
//  Created by Xicom on 06/06/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface storeCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *storeLogo;
@property (strong, nonatomic) IBOutlet UILabel *storeName;
@property (strong, nonatomic) IBOutlet UILabel *cityName;
-(void)loadData:(NSDictionary *)dic;
@end
