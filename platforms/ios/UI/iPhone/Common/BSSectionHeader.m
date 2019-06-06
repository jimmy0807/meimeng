//
//  BSSectionHeader.m
//  Boss
//
//  Created by XiaXianBing on 15/8/18.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSSectionHeader.h"

@implementation BSSectionHeader

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.autoresizingMask = 0xff;
        self.contentView.autoresizingMask = 0xff;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.bounds = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, kBSSectionHeaderHeight);
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kBSSectionHeaderHeight - 0.5, IC_SCREEN_WIDTH, 0.5)];
        lineImageView.backgroundColor = [UIColor clearColor];
        lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
        [self.contentView addSubview:lineImageView];
    }
    
    return self;
}

@end
