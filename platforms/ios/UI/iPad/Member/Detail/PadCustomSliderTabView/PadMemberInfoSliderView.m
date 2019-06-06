//
//  PadMemberInfoSliderView.m
//  自定义按钮
//
//  Created by 刘伟 on 2017/9/22.
//  Copyright © 2017年 刘伟. All rights reserved.
//

#import "PadMemberInfoSliderView.h"
#import "UIView+Extension.h"

#define BUTTONSLECTEDCOLOR [UIColor colorWithRed:96/255.0 green:211/255.0 blue:212/255.0 alpha:1]
#define BUTTONNOSELECTEDCOLOR [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]
#define TOPMAINVIEWCOLOR [UIColor colorWithRed:242/255.0 green:245/255.0 blue:245/255.0 alpha:1]

@interface PadMemberInfoSliderView()<UIScrollViewDelegate>


@end

@implementation PadMemberInfoSliderView

-(instancetype)initWithFrame:(CGRect)frame WithItems:(NSArray *)items andTopTabBarHeight:(CGFloat)topTabBarHeight{

    self = [super initWithFrame:frame];
    if (self) {
        ///初始化
        _topTabBarHeight = topTabBarHeight;
        _pageContainItems = 4;
        _mViewFrame = frame;//整个view的大小
        _itemsArray = items;//头部item数组
        _topViews = [NSMutableArray array];//头部item计数
        [self initTopTabs];//设置头部tab
        [self initSlideView];//设置滑动指示view
        [self initBottomScrollView];//下面的内容部分
    }
    return self;
}

-(void)initTopTabs{
    CGFloat itemWidth = 100;
    //NSLog(@"%f",_mViewFrame.size.width*_itemsArray.count);
    _topMainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _mViewFrame.size.width*_itemsArray.count, _topTabBarHeight)];
    _topMainView.backgroundColor = TOPMAINVIEWCOLOR;
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _mViewFrame.size.width, _topTabBarHeight)];
    _topScrollView.contentSize = CGSizeMake(itemWidth*_itemsArray.count, _topTabBarHeight);//先计算一个屏幕能放几个
    //_topScrollView.bounces=NO;
    _topScrollView.showsHorizontalScrollIndicator=NO;
    //_topScrollView.alwaysBounceHorizontal=NO;
    _topScrollView.delegate = self;
    [self addSubview:_topMainView];
    [_topMainView addSubview:_topScrollView];
    
    for (int i = 0; i < _itemsArray.count; i ++) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * itemWidth, 0, itemWidth, _topTabBarHeight)];
        //view.backgroundColor = [UIColor lightGrayColor];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemWidth, _topTabBarHeight)];
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitle:_itemsArray[i] forState:UIControlStateNormal];
        ///初始化第一个
        if (i==0) {
            [button setTitleColor:BUTTONSLECTEDCOLOR forState:UIControlStateNormal];
        }else{
            [button setTitleColor:BUTTONNOSELECTEDCOLOR forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(tabButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        [_topViews addObject:view];
        [_topScrollView addSubview:view];
    }
}

#pragma mark -- 初始化滑动的指示View
-(void) initSlideView{
    
    CGFloat width = 100;
    
    _slideView = [[UIView alloc] initWithFrame:CGRectMake(20, _topTabBarHeight - 4, width-40, 4)];
    [_slideView setBackgroundColor:BUTTONSLECTEDCOLOR];
    [_topScrollView addSubview:_slideView];
}

-(void)initBottomScrollView{
    _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _topTabBarHeight, _mViewFrame.size.width, _mViewFrame.size.height - _topTabBarHeight)];
    _bottomScrollView.contentSize = CGSizeMake(_mViewFrame.size.width * _itemsArray.count, _mViewFrame.size.height - _topTabBarHeight);
    //_bottomScrollView.backgroundColor = [UIColor blueColor];
    _bottomScrollView.pagingEnabled = YES;
    _bottomScrollView.bounces=NO;
    _bottomScrollView.showsHorizontalScrollIndicator=NO;
    _bottomScrollView.delegate = self;
    [self addSubview:_bottomScrollView];
    //此处可添加 头部item对应的主要内容
    //...
    for (int i =0 ; i<_itemsArray.count; i++) {
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(_mViewFrame.size.width*i, 0, _mViewFrame.size.width, _mViewFrame.size.height-_topTabBarHeight)];
        //contentView.backgroundColor = [UIColor colorWithRed:(arc4random()%256)/255.0 green:(arc4random()%256)/255.0 blue:(arc4random()%256)/255.0 alpha:1];
        [_bottomScrollView addSubview:contentView];
    }
}

#pragma mark --点击顶部的按钮所触发的方法
-(void) tabButton: (id) sender{
    UIButton *button = sender;
    [_bottomScrollView setContentOffset:CGPointMake(button.tag * _mViewFrame.size.width, 0) animated:YES];
}

#pragma mark - UISCrollView
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:_bottomScrollView]) {
        _currentPage = _bottomScrollView.contentOffset.x/_mViewFrame.size.width;
        //NSLog(@"当前是第%ld页",(long)_currentPage);
        [self changeBackColorWithPage:_currentPage];
        //如果是item超过一页 当混动_bottomScrollView 得想办法重置_topScrollView
        //一页显示几个
        //NSLog(@"一页显示几个%d",(int)_mViewFrame.size.width/100);
        if ((_currentPage/_pageContainItems)!=0) {
            
            [_topScrollView setContentOffset:CGPointMake(_slideView.frame.origin.x-20, 0) animated:YES];
        }
        else
        {
            [_topScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        return;
    }
    [self modifyTopScrollViewPositiong:scrollView];//这个方法是校准当前选择的item
}

///更新按钮文字颜色和指示View的位置
- (void) changeBackColorWithPage: (NSInteger) currentPage {
    //NSLog(@"%lu",(unsigned long)_topViews.count);
    for (int i = 0; i < _topViews.count; i ++) {
        
        UIView *tempView = _topViews[i];
        UIButton *button = [tempView subviews][0];
        
        if (i == currentPage) {
            [button setTitleColor:BUTTONSLECTEDCOLOR forState:UIControlStateNormal];
            ///同时更新_slideView
            CGFloat slideViewX = button.width * i + 20;
            [UIView animateWithDuration:0.1 animations:^{
                _slideView.frame = CGRectMake(slideViewX, _topTabBarHeight - 4, _slideView.frame.size.width, _slideView.frame.size.height);
            }];
        } else {
            [button setTitleColor:BUTTONNOSELECTEDCOLOR forState:UIControlStateNormal];
        }
    }
}

#pragma mark -- scrollView的代理方法
-(void) modifyTopScrollViewPositiong: (UIScrollView *) scrollView{
    
    if ([_topScrollView isEqual:scrollView]) {
        
        CGFloat contentOffsetX = _topScrollView.contentOffset.x;
        
        CGFloat width = 100;
        
        int count = (int)contentOffsetX/(int)width;
        
        CGFloat step = (int)contentOffsetX%(int)width;
        
        CGFloat sumStep = width * count;
        
        if (step > width/2) {
            
            sumStep = width * (count + 1);
            
        }
        
        [_topScrollView setContentOffset:CGPointMake(sumStep, 0) animated:YES];
        
        return;
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
