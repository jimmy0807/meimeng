//
//  producSectionView.m
//  Boss
//
//  Created by jiangfei on 16/6/1.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "producSectionView.h"
@interface producSectionView ()
/** 左边的图标 */
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
/** 标题文字 */
@property (weak, nonatomic) IBOutlet UILabel *titleView;
/** 覆盖在图片和文字上的按钮 */
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end
@implementation producSectionView
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    self.titleView.textColor = [UIColor colorWithRed:11/255.0 green:169/255.0 blue:250/255.0 alpha:1];
}
#pragma mark 点击了按钮
- (IBAction)btnClick:(UIButton *)sender {
    //1.切换按钮的选中状态
    self.btn.selected = !self.btn.selected;
    //2.更新title的文字
    self.titleView.text = self.btn.selected?@"收起":@"更多信息";
    //3.旋转iconView
    CGFloat anger = self.btn.selected?-1:1;
    self.iconView.transform = CGAffineTransformRotate(self.iconView.transform, M_PI_2*anger);
    BOOL selected = self.btn.selected;
    //4.给block传参
    if (_selectedBlock) {
        _selectedBlock(selected);
    }
}

@end
