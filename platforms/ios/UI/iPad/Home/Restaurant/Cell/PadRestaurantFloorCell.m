//
//  PadRestaurantFloorCell.m
//  Boss
//
//  Created by XiaXianBing on 2016-2-24.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadRestaurantFloorCell.h"

@implementation PadRestaurantFloorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.frame = CGRectMake(0.0, 0.0, kPadRestaurantFloorCellWidth, kPadRestaurantFloorCellHeight);
        
        self.leftLine = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.5, kPadRestaurantFloorCellHeight)];
        self.leftLine.backgroundColor = [UIColor clearColor];
        self.leftLine.image = [UIImage imageNamed:@"pad_restaurant_floor_left_line"];
        self.leftLine.hidden = YES;
        [self.contentView addSubview:self.leftLine];
        
        self.background = [[UIImageView alloc] initWithFrame:self.bounds];
        self.background.backgroundColor = [UIColor clearColor];
        self.background.image = [UIImage imageNamed:@"pad_restaurant_floor_n"];
        [self.contentView addSubview:self.background];
        
        self.titleLabel = [[UITextField alloc] initWithFrame:CGRectMake(4.0, 4.0, self.frame.size.width - 8.0, self.frame.size.height - 8.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:16.0];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = COLOR(170.0, 177.0, 177.0, 1.0);
        self.titleLabel.enabled = NO;
        self.titleLabel.delegate = self;
        self.titleLabel.placeholder = @"请输入";
        [self.contentView addSubview:self.titleLabel];
        
        self.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    
    return self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.delegate didFloorNameChanged:textField.text];
}

@end
