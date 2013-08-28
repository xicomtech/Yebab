//
//  storeCell.m
//  Yebab
//
//  Created by Xicom on 06/06/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import "storeCell.h"

@implementation storeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadData:(NSDictionary *)dic{
    self.storeName.text = [dic objectForKey:@"storeName"];
    self.cityName.text =  [dic objectForKey:@"storeCities"];
    self.storeLogo.image = [dic objectForKey:@"storeLogoImage"];
}
@end
