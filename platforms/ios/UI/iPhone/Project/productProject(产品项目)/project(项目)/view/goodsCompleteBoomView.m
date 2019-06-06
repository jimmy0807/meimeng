//
//  goodsCompleteBoomView.m
//  Boss
//
//  Created by jiangfei on 16/6/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "goodsCompleteBoomView.h"
@interface goodsCompleteBoomView ()

@property (weak, nonatomic) IBOutlet UIButton *delete;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UIButton *allBtnCover;


@end
@implementation goodsCompleteBoomView
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.allBtnCover.tag = 0;
    self.delete.tag = 1;
    self.autoresizingMask = UIViewAutoresizingNone;
    self.backgroundColor = VCBackgrodColor;
}
- (IBAction)allSeletedBtnClick:(UIButton *)sender {
    NSLog(@"全选...");
    self.imageBtn.selected = !self.imageBtn.selected;
    self.allBtnCover.selected = self.imageBtn.selected;
    if (_completeBoomBlock) {
        _completeBoomBlock(sender);
    }
}

- (IBAction)deleteBtnClick:(UIButton *)sender {
    NSLog(@"删除...");
    if (_completeBoomBlock) {
        _completeBoomBlock(sender);
    }
}


@end
