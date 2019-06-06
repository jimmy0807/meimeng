//
//  BSPageControl.m
//  Boss
//
//  Created by lining on 16/5/30.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSPageControl.h"
#define kPageDotMarginSize  4

@interface BSPageControl ()
{
    NSInteger prePage;
}
@end

@implementation BSPageControl

- (id)initWithImgName:(NSString *)imgName highlightImgName:(NSString *)highlightImgName numberOfPages:(NSInteger)page
{
    self = [super init];
    if (self) {
        UIView *lastView;
        for (int i = 0; i < page; i ++) {
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName] highlightedImage:[UIImage imageNamed:highlightImgName]];
            
            imgView.tag = 101+i;
            [self addSubview:imgView];
            if (lastView == nil) {
                [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.offset(0);
                    make.top.offset(0);
                    make.bottom.offset(0);
                    
                }];
            }
            else
            {
                [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(lastView.mas_trailing).offset(kPageDotMarginSize);
                    make.top.offset(0);
                    make.bottom.offset(0);
                    
                }];
            }
            lastView = imgView;
        }
        [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.offset(0);
        }];
        
        prePage = -1;
        self.currentPage = 0;
    }
    return self;
}

-(void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    if (_currentPage == prePage) {
        return;
    }
    UIImageView *imgView = (UIImageView *)[self viewWithTag:101+_currentPage];
    imgView.highlighted = YES;
    if (prePage != -1) {
        UIImageView *preImgView = (UIImageView *)[self viewWithTag:101+prePage];
        preImgView.highlighted = NO;
    }
    
    prePage = _currentPage;
}

@end
