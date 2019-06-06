//
//  FastSaleCell.m
//  Boss
//
//  Created by jiangfei on 16/7/5.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "FastSaleCell.h"
@interface FastSaleCell ()
@property (weak, nonatomic) IBOutlet UIButton *cellTitleBtn;

@end
@implementation FastSaleCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
}
-(void)setTitleName:(NSString *)titleName
{
    if (titleName.length<3) {//数字
        [self.cellTitleBtn setTitle:titleName forState:UIControlStateNormal];
    }else{//图片名
        [self.cellTitleBtn setImage:[UIImage imageNamed:titleName] forState:UIControlStateNormal];
    }
}


- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    [self.cellTitleBtn setTitleColor:titleColor forState:UIControlStateNormal];
}

- (IBAction)titleBtnClick:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(fastSaleCellDidSelectedWithBtnTitle:)]) {
        [_delegate fastSaleCellDidSelectedWithBtnTitle:self.cellTitleBtn.currentTitle];
    }
}
@end
