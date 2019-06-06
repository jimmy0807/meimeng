//
//  subRightNaviTitleView.m
//  Boss
//
//  Created by jiangfei on 16/5/19.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "subRightNaviTitleView.h"
@interface subRightNaviTitleView ()
/** view*/
@property (nonatomic,weak)UIView *lineView;
@end
@implementation subRightNaviTitleView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setImage:[UIImage imageNamed:@"navi_back_h"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"navi_back_h"] forState:UIControlStateHighlighted];
        [self setTitle:@"上一级" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self setUpSubView];
    }
    return self;
}
-(void)setUpSubView
{
    UIView *lineView = [[UIView alloc]init];
    _lineView = lineView;
    _lineView.backgroundColor = [UIColor blackColor];
    _lineView.alpha = 0.1;
    [self addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@1);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat x = 10;
    CGSize size = self.currentImage.size;
    CGFloat w = size.width;
    CGFloat h = size.height;
    CGFloat y = (contentRect.size.height - h)/2;
    return CGRectMake(x, y, w, h);
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat x = CGRectGetMaxX(self.imageView.frame);
    CGFloat y = 0;
    CGFloat w = contentRect.size.width -x;
    CGFloat h = contentRect.size.height;
    return CGRectMake(x, y, w, h);
}
@end
