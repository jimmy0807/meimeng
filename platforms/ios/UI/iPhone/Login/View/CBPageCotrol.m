//
//  CBPageCotrol.m
//  CardBag
//
//  Created by lining on 14-2-27.
//  Copyright (c) 2014年 Everydaysale. All rights reserved.
//

#import "CBPageCotrol.h"

#define kPageDotMarginSize  10
@interface CBPageCotrol ()
{
    NSInteger prePage;
}
@property(nonatomic, strong)NSMutableArray* imageViews;
@property(nonatomic, strong)UIImage* image;
@property(nonatomic, strong)UIImage* highlightImage;
@end

@implementation CBPageCotrol

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame withImg:(UIImage *)image highlightImg:(UIImage *)highlightImage numberOfPages:(NSInteger)page
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.image = image;
        self.highlightImage = highlightImage;
        [self reloadViewsWithPageCount:page];
    }
    
    return self;
}

- (void)reloadViewsWithPageCount:(NSInteger)count
{
    for (UIView* v in self.imageViews )
    {
        [v removeFromSuperview];
    }
    
    self.imageViews = [NSMutableArray array];
    
    CGFloat width = self.image.size.width;
    CGFloat heigth = self.image.size.height;
    CGFloat xCoord = 0.0;
    CGFloat startPosX = (self.frame.size.width - count * width - (count - 1) * kPageDotMarginSize) / 2;
    for (int i = 0; i < count; i++)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(startPosX + xCoord, (self.frame.size.height - heigth)/2.0, width, heigth)];
        imgView.image = self.image;
        imgView.highlightedImage = self.highlightImage;
        imgView.tag = 101+i;
        
        [self addSubview:imgView];
        [self.imageViews addObject:imgView];
        xCoord += (width + kPageDotMarginSize);
    }
    
    prePage = -1;
    self.currentPage = 0;
}

-(void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    if (_currentPage == prePage)
        return;
    
    UIImageView *imgView = (UIImageView *)[self viewWithTag:101+_currentPage];
    imgView.highlighted = YES;
    if (prePage != -1)
    {
        UIImageView *preImgView = (UIImageView *)[self viewWithTag:101+prePage];
        preImgView.highlighted = NO;
    }
    
    prePage = _currentPage;
}

@end
