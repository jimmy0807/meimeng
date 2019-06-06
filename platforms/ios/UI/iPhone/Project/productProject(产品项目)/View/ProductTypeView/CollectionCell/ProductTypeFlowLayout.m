//
//  ProductTypeFlowLayout.m
//  Boss
//
//  Created by jiangfei on 16/5/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ProductTypeFlowLayout.h"

@implementation ProductTypeFlowLayout
/**
 *显示的边界发生改变重新布局:系统重新调用prepareLayout
 */
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

/**
 *  初始化layout
 */
-(void)prepareLayout
{
    [super prepareLayout];
    CGFloat margin = 15;
    CGFloat itemW = (IC_SCREEN_WIDTH - 3*margin)/2;
    CGFloat itemH = itemW + 30;
    self.headerReferenceSize = CGSizeMake(IC_SCREEN_WIDTH, 50);
    self.footerReferenceSize = CGSizeMake(0, IC_SCREEN_HEIGHT*0.5);
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    if (self.size.width == 0) {
        self.itemSize = CGSizeMake(itemW, itemH);
    }else{
         self.itemSize = self.size;
    }
   
   
}
-(void)setHeadSize:(CGSize)headSize
{
    _headSize = headSize;
    
    self.headerReferenceSize = headSize;
}
-(void)setSize:(CGSize)size
{
    _size = size;
    self.itemSize = size;
    CGFloat margin = 15;
    if (size.width == IC_SCREEN_WIDTH) {
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
        self.sectionInset = UIEdgeInsetsMake(margin, margin, 0, margin);
    }
}

@end
