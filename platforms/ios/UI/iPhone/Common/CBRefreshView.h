//
//  CBRefreshView.h
//  CardBag
//
//  Created by chen yan on 13-11-4.
//  Copyright (c) 2013年 Everydaysale. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum CBRefreshState
{
    CBRefreshStateRefresh,     //上拉加载状态
    CBRefreshStateLoadMore      //下拉加载状态
} CBRefreshState;

typedef enum CBPullingState
{
    CBPullingStateNormal,           //正常状态
    CBPullingStatePullingDown,      //下拉状态
    CBPullingStateDownHitTheEnd,    //下拉越界状态
    CBPullingStatePullingUp,        //上拉状态
    CBPullingStateUpHitTheEnd,      //上拉越界状态
    CBPullingStateLoading,          //加载状态
} CBPullingState;

/**
 @protocol CBRefreshDelegate
 */
@protocol CBRefreshDelegate <NSObject>
@optional
- (void)scrollView:(UIScrollView *)scrollView withRefreshState:(CBRefreshState)state;
@end


/**
 @interface UIScrollView (CBRefresh)
 */
@interface UIScrollView (CBRefresh)

@property (nonatomic, assign) BOOL canRefresh;              //是否可以下拉
@property (nonatomic, assign) BOOL canLoadMore;             //是否可以上拉
@property (nonatomic, assign) id<CBRefreshDelegate> refreshDelegate;//代理,拖拽完成需要更新时会调用回调函数

- (void)stopWithRefreshState:(CBRefreshState)state;

@end


/**
 @interface CBRefreshView
 */
@interface CBRefreshView : UIView
{
    UILabel *stateLabel;
    CALayer *arrowLayer;
    UIActivityIndicatorView *activityView;
}
@property (nonatomic, assign) CBPullingState state;
@property (nonatomic, assign) CBRefreshState status;
@property (nonatomic, strong) UITableView *obTableView;

@end


/**
 @interface Interceptor(函数拦截器)
 */
@interface Interceptor : NSObject
{
//    id receiver;
    CBRefreshView *refreshView;
    CBRefreshView *loadmoreView;
}

@property (nonatomic, assign) id receiver;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, retain) CBRefreshView *refreshView;
@property (nonatomic, retain) CBRefreshView *loadmoreView;

@end

/**
 @interface UIScrollView (Private)
 */
@interface UIScrollView (Private)

@property (nonatomic, retain) Interceptor *interceptor;

- (void)refreshWithState:(CBRefreshState)state;         //根据加载状态回调外部函数
- (void)cleanCBrefreshView;

@end

