//
//  AllocationHeadView.m
//  Boss
//
//  Created by lining on 15/10/21.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "AllocationHeadView.h"
#import "UIView+LoadNib.h"
#import "UIImage+Resizable.h"

@implementation AllocationHeadView

+ (instancetype)createView
{
    AllocationHeadView *headView = [self loadFromNib];
    [headView initView];
    return headView;
}


- (void) initView
{
    self.head_bottom_bg.image = [[UIImage imageNamed:@"pos_cell_bg_b.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
}


- (void)setNeed_give:(bool)need_give
{
    if (need_give) {
        self.head_top_bg.image = [[UIImage imageNamed:@"pos_cell_bg_t.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        
    }
    else
    {
        self.head_top_bg.image = [[UIImage imageNamed:@"pos_text_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
    }
}

- (IBAction)switchBtnPressed:(UIButton *)sender {
    self.swithImgView.highlighted = !self.swithImgView.highlighted;
   
    self.need_give = self.swithImgView.highlighted;
}

- (IBAction)giveBtnPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didGiveBtnPressed)]) {
        [self.delegate didGiveBtnPressed];
    }
}

@end
