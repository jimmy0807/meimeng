//
//  CBWebViewController.h
//  CardBag
//
//  Created by jimmy on 13-9-25.
//  Copyright (c) 2013年 Everydaysale. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^rightItemJSBlock)(UIWebView* webview);

@protocol CBWebViewControllerDelegate <NSObject>
- (void)didObserveSchemeFind:(NSURLRequest*)request;
@end

typedef enum kWebViewActionSheetItem
{
    kWebViewActionSheetItem_Copy,
    kWebViewActionSheetItem_Safari
}kWebViewActionSheetItem;

@interface CBWebViewController : ICCommonViewController <UIWebViewDelegate, UIActionSheetDelegate>

- (instancetype)initWithUrl:(NSString*)url;
- (BOOL)isLoadFinished;
- (void)reload;

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *customTitle;
@property (nonatomic)BOOL disableBounces;
@property (nonatomic, weak)UIViewController* tabbar;

@property (nonatomic, strong)UIBarButtonItem* rightItem;

@property(nonatomic, strong)NSString* observeScheme;
@property(nonatomic, weak)id<CBWebViewControllerDelegate> delegate;

- (BOOL)shouldNotPushBack;
- (void)initNaviBarButton;
- (void)refreshNaviLeftBarButton;

- (void)setRightItemJs:(rightItemJSBlock)block;

@end
