//
//  goodsBoomView.m
//  Boss
//
//  Created by jiangfei on 16/6/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "goodsBoomView.h"
@interface goodsBoomView ()

@end
@implementation goodsBoomView
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = VCBackgrodColor;
}
- (IBAction)addBtnClick:(UIButton *)sender {
    
   
    if ([_delegate respondsToSelector:@selector(goodsBoomViewAddBtnClick)]) {
        [_delegate goodsBoomViewAddBtnClick];
    }
    
}


@end
