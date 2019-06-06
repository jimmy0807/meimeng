//
//  MemberFunctionCell.m
//  Boss
//
//  Created by lining on 16/3/17.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberFunctionCell.h"

@interface MemberFunctionCell ()

@end

@implementation MemberFunctionCell

+ (instancetype)createCell
{
    MemberFunctionCell *cell = [self loadFromNib];
    cell.items = @[cell.view1,cell.view2,cell.view3];
    cell.imgs = @[cell.img1,cell.img2,cell.img3];
    cell.labels = @[cell.label1,cell.label2,cell.label3];
    return cell;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)setItem:(FunctionItem *)item withIndex:(NSInteger)idx
{
    UIView *itemView = self.items[idx];
    UIImageView *imgView = self.imgs[idx];
    UILabel *label = self.labels[idx];
    
    if (item == nil) {
        itemView.hidden = true;
        
    }
    else
    {
        itemView.hidden = false;
        imgView.image = [UIImage imageNamed:item.imageName];
        label.text = item.title;
    }
}


- (IBAction)itemButtonPressed:(UIButton *)sender {
    
    NSInteger idx = self.row * ROW_ITEM_COUNT + (sender.tag - 101);
    NSLog(@"idx: %d",idx);
    if ([self.delegate respondsToSelector:@selector(didSelectedItemAtIdx:)]) {
        [self.delegate didSelectedItemAtIdx:idx];
    }
}


@end


@implementation FunctionItem

@end
