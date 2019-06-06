//
//  BottomBtnView.m
//  Boss
//
//  Created by jiangfei on 16/6/13.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BottomBtnView.h"
@interface BottomBtnView ()
@property (weak, nonatomic) IBOutlet UIButton *countBtn;

@end
@implementation BottomBtnView

+ (instancetype)createView
{
    return [self loadFromNib];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.count = 0;
}

-(void)setCount:(NSUInteger)count
{
    _count = count;
    if (count == 0) {
        [self.countBtn setTitle:@"请选择" forState:UIControlStateNormal];
    }
    else
    {
        [self.countBtn setTitle:[NSString stringWithFormat:@"已选择(%d)",count] forState:UIControlStateNormal];
    }
    
}
- (IBAction)sureBtnPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didSureBtnPressed)]) {
        [self.delegate didSureBtnPressed];
    }
}
@end
