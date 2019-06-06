//
//  GiveCell.m
//  Boss
//
//  Created by lining on 15/10/30.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "GiveCell.h"
#import "UIView+LoadNib.h"
#import "UIView+Frame.h"

@implementation GiveCell

+ (instancetype)createCell
{
   return [self loadFromNib];
}

- (void)itemWithName:(NSString *)name
{
    [self itemWithName:name count:nil];
}


- (void)itemWithName:(NSString *)name count:(NSString *)count
{
    self.deleteBtn.hidden = false;
    self.imgView.hidden = false;
    self.imgView.image = [UIImage imageNamed:@"pos_delete.png"];
    self.nameLabel.text = name;
    if (count == nil) {
        self.countLabel.hidden = true;
        self.countLabel.text = @"";
    }
    else
    {
        self.countLabel.hidden = false;
        self.countLabel.text = count;
    }
}


- (void)lastItem
{
    self.countLabel.text = @"";
    self.nameLabel.text = @"添加一条";
    self.imgView.image = [UIImage imageNamed:@"pos_add.png"];
    self.imgView.hidden = false;
    self.deleteBtn.hidden = true;
}

- (void)hideDeleteView:(bool)hidden
{
    self.deleteBtn.hidden = hidden;
    self.imgView.hidden = hidden;
}

- (IBAction)deleteBtnPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didDeleteBtnPressedAtIndexPath:)]) {
        [self.delegate didDeleteBtnPressedAtIndexPath:self.indexPath];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.imgView.hidden && self.countLabel.hidden) {
        self.nameLabel.x = 25;
        self.nameLabel.width = 360 + 30;
    }
    else if (self.imgView.hidden)
    {
        self.nameLabel.x = 25;
        self.nameLabel.width = 304 + 30;
    }
    else if (self.countLabel.hidden)
    {
        self.nameLabel.x = 53;
        self.nameLabel.width = 360;
    }
    else
    {
        self.nameLabel.x = 53;
        self.nameLabel.width = 304;
    }
    
}

@end
