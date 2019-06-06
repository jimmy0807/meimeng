//
//  FilterMonthCell.m
//  Boss
//
//  Created by lining on 16/5/24.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "FilterMonthCell.h"

@implementation FilterMonthCell

+ (instancetype)createCell
{
    FilterMonthCell *cell = [self loadFromNib];
    cell.buttons = @[cell.button1,cell.button2,cell.button3,cell.button4];
//    for (UIButton *btn in cell.buttons) {
//        [btn setTitleColor:COLOR(72, 72, 72, 1) forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//    }
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

- (void)setBtnTitle:(NSString *)title atIndex:(NSInteger)index selected:(BOOL)selected
{
    NSInteger idx = index % self.buttons.count;
    UIButton *btn = self.buttons[idx];
    btn.selected = selected;
    if (title.length > 0) {
        btn.hidden = false;
        [btn setTitle:title forState:UIControlStateNormal];
        btn.tag = 101 + index;
    }
    else
    {
        btn.hidden = true;
    }
   
}

- (IBAction)buttonPressed:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSLog(@"month: %d",btn.tag - 101);
    if ([self.delegate respondsToSelector:@selector(didSelectedBtnAtIndex:)]) {
        [self.delegate didSelectedBtnAtIndex:btn.tag - 101];
    }
}


@end
