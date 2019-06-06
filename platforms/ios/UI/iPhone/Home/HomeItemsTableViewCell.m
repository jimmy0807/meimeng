//
//  HomeItemsTableViewCell.m
//  Boss
//
//  Created by jimmy on 15/5/29.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "HomeItemsTableViewCell.h"

@implementation HomeItemsTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeTableviewItemsBG.png"]];

    int width = IC_SCREEN_WIDTH / 3;
    for ( int i = 0; i < 3; i++ )
    {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * width, 0, width, self.contentView.frame.size.height);
        btn.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
        btn.tag = 101 + i;
        [btn setBackgroundImage:[UIImage imageNamed:@"HomeTableviewItems_H.png"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(didItemButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
    }
    
    return self;
}

- (void)didItemButtonPressed:(UIButton*)sender
{
    UIView* view = sender.superview;
    while (![view isKindOfClass: [UITableView class]] && view != nil)
    {
        view = view.superview;
    }
    
    NSIndexPath *indexPath = [(UITableView*)view indexPathForCell:self];
    [self.delegate didItemButtonPressed:(sender.tag - 101 + indexPath.row * 3) cell:self];
}

- (void)setItemImage:(UIImage*)image atIndex:(NSInteger)index
{
    UIButton* btn = (UIButton*)[self.contentView viewWithTag:101 + index];
    [btn setImage:image forState:UIControlStateNormal];
    btn.hidden = (image == nil);
}

@end
