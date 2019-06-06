//
//  ProductTypeTitleBtn.m
//  Boss
//
//  Created by jiangfei on 16/5/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ProductTypeTitleBtn.h"

@implementation ProductTypeTitleBtn
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.5] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
    CGFloat width = 25;
    CGFloat height = 25;
    CGFloat x = (contentRect.size.width - width)/2;
    CGFloat y = 5;
    return CGRectMake(x, y, width, height);
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    CGSize size = [self.currentTitle sizeWithAttributes:
                   dict];
    CGFloat y = CGRectGetMaxY(self.imageView.frame);
    CGFloat h = contentRect.size.height - y;
    CGFloat w = contentRect.size.width;
    CGFloat x = (w-size.width)/2;
    return CGRectMake(x, y, w, h);
    
}

@end
