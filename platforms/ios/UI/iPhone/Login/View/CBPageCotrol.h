//
//  CBPageCotrol.h
//  CardBag
//
//  Created by lining on 14-2-27.
//  Copyright (c) 2014年 Everydaysale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBPageCotrol : UIControl

//@property(nonatomic, strong) UIPageControl *control;
@property(nonatomic, assign) NSInteger currentPage;

-(id)initWithFrame:(CGRect)frame withImg:(UIImage *)image highlightImg:(UIImage *)highlightImage numberOfPages:(NSInteger)page;

- (void)reloadViewsWithPageCount:(NSInteger)count;

@end
