//
//  productTitleBtn.m
//  Boss
//
//  Created by jiangfei on 16/5/31.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "productTitleBtn.h"

@implementation productTitleBtn

- (void)awakeFromNib
{
    [super awakeFromNib];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentRight;
    }
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    CGSize titleSize = [self.currentTitle sizeWithAttributes:dict];
    CGFloat y = 0;
    CGFloat w = titleSize.width;
    CGFloat x = (contentRect.size.width - w)/2;
    CGFloat h = contentRect.size.height;
    return CGRectMake(x, y, w, h);
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGSize size = self.currentImage.size;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    CGSize titleSize = [self.currentTitle sizeWithAttributes:dict];
    CGFloat titleW = titleSize.width;
    CGFloat x = (contentRect.size.width - titleW)/2 + titleW;
    CGFloat w = size.width;
    CGFloat h = size.height;
    CGFloat y = (contentRect.size.height - size.height)/2.0;
    return CGRectMake(x, y, w, h);
}
@end
