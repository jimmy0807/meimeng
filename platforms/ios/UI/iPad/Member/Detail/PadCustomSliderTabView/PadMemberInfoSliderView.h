//
//  PadMemberInfoSliderView.h
//  自定义按钮
//
//  Created by 刘伟 on 2017/9/22.
//  Copyright © 2017年 刘伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PadMemberInfoSliderView : UIView
///@brife 整个视图的大小
@property (assign) CGRect mViewFrame;
///@brife items数组
@property (nonatomic,strong)NSArray *itemsArray;

///@brife 上方的ScrollView
@property (strong, nonatomic) UIScrollView *topScrollView;

///@brife 下方的ScrollView
@property (strong, nonatomic) UIScrollView *bottomScrollView;

///@brife 上方的view
@property (strong, nonatomic) UIView *topMainView;

///@brife 上方的按钮数组
@property (strong, nonatomic) NSMutableArray *topViews;

///@brife 下面滑动的指示View
@property (strong, nonatomic) UIView *slideView;

///@brife 当前选中页数
@property (assign) int currentPage;

/// topScrollView一页显示几个item
@property (assign) int pageContainItems;

///tabBar的高度
@property(assign) CGFloat topTabBarHeight;

//提供一个方法 传进来多少个items 创建可滚动的scrollView
-(instancetype)initWithFrame:(CGRect)frame WithItems:(NSArray *)items andTopTabBarHeight:(CGFloat)topTabBarHeight;
@end
