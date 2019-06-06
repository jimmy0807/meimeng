//
//  BSSectionFooter.m
//  Boss
//
//  Created by XiaXianBing on 15/8/18.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSSectionFooter.h"

@implementation BSSectionFooter

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
        self.bounds = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, kBSSectionFooterHeight);
        
        self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kBSSectionFooterHeight - 0.5, IC_SCREEN_WIDTH, 0.5)];
        self.lineImageView.backgroundColor = [UIColor clearColor];
        self.lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
        [self.contentView addSubview:self.lineImageView];
    }
    
    return self;
}

@end
