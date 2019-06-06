//
//  CBWebViewController.h
//  CardBag
//
//  Created by jimmy on 13-9-25.
//  Copyright (c) 2013年 Everydaysale. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PadWebViewControllerDelegate <NSObject>
- (void)didObserveSchemeFind:(NSURLRequest*)request;
@end

@interface PadWebViewController : ICCommonViewController <UIWebViewDelegate, UIActionSheetDelegate>

- (instancetype)initWithUrl:(NSString*)url;
- (BOOL)isLoadFinished;
- (void)reload;

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *customTitle;
@property (nonatomic)BOOL disableBounces;
@property (nonatomic, weak)UIViewController* tabbar;

@property (nonatomic, strong)UIBarButtonItem* rightItem;

@property(nonatomic)BOOL isCloseButton;
@property(nonatomic)BOOL hideNavigation;

@property(nonatomic, strong)NSString* observeScheme;
@property(nonatomic, weak)id<PadWebViewControllerDelegate> delegate;

- (BOOL)shouldNotPushBack;
- (void)initNaviBarButton;
- (void)refreshNaviLeftBarButton;

@end
