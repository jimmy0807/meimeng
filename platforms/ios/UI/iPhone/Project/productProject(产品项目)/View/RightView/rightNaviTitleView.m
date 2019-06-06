//
//  rightNaviTitleView.m
//  Boss
//
//  Created by jiangfei on 16/5/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "rightNaviTitleView.h"
@interface rightNaviTitleView ()
/** 文字label*/
@property (nonatomic,weak)UILabel *nameLabel;
/** 数字label*/
@property (nonatomic,weak)UILabel *countLabel;
/** 灰线*/
@property (nonatomic,weak)UIView *lineView;
@end
@implementation rightNaviTitleView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubView];
    }
    return self;
}
//添加子控件
-(void)addSubView
{
    //文字label
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"全部";
    self.nameLabel = nameLabel;
    [self addSubview:self.nameLabel];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
     //数量label
    UILabel *countLabel = [[UILabel alloc]init];
    self.countLabel = countLabel;
    countLabel.font = [UIFont systemFontOfSize:13];
    countLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    countLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_countLabel];
    //灰线
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor blackColor];
    lineView.alpha = 0.2;
    self.lineView = lineView;
    [self addSubview:self.lineView];
}
-(void)setCount:(NSUInteger)count
{
    _count = count;
    if (count == 0) {
        self.nameLabel.hidden = YES;
        self.countLabel.text = nil;
        self.lineView.hidden = YES;
        return;
    }else{
        self.nameLabel.hidden = NO;
        self.lineView.hidden = NO;
    }
    self.countLabel.text = [NSString stringWithFormat:@"%zd",count];
    [self layoutIfNeeded];
    
    //nameLabel
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(self.mas_height);
        make.width.equalTo(@60);
    }];
    
    
    //countLabel
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(self.mas_height);
        make.width.equalTo(@60);
    }];
    //lineView
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-2);
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@1);
    }];
    
}

@end
