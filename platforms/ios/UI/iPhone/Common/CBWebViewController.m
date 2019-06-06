//
//  CBWebViewController.m
//  CardBag
//
//  Created by jimmy on 13-9-25.
//  Copyright (c) 2013年 Everydaysale. All rights reserved.
//

#import "CBWebViewController.h"
#import "WXApi.h"
#import "WXApiObject.h"

#define kCompleteWebviewURL @"kCompleteWebviewURL:///complete"

typedef enum WebViewProgress
{
    WebViewProgress_None,
    WebViewProgress_Loading,
    WebViewProgress_Finished
}WebViewProgress;

@interface CBWebViewController ()
{
    WebViewProgress mCurrentProgress;
    BOOL mDisableProgress;
    NSTimer* mInteractiveTimer;
    NSInteger mLoadingCount;
    NSURLRequest *originRequest;
}

@property(nonatomic, strong)UIWebView *webView;
@property(nonatomic, strong)UIView* progressView;
@property(nonatomic, strong)NSURL* loadingUrl;
@property(nonatomic, strong)UIBarButtonItem *backButtonItem;
@property(nonatomic, strong)UIBarButtonItem *closeButtonItem;
@property(nonatomic, assign)BOOL isAuthed;
@property(nonatomic, copy)rightItemJSBlock jsBlock;
@end

@implementation CBWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (instancetype)initWithUrl:(NSString*)url
{
    self = [super init];
    if ( self )
    {
        self.url = url;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNaviBarButton];
    [self forbidSwipGesture];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40 , 44)];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton setTitle:@"分享" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(didShareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];

    //self.navigationItem.rightBarButtonItem = self.rightItem;
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.autoresizingMask = 0xff;
    self.webView.backgroundColor = [UIColor clearColor];
    [self.webView setOpaque:YES];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    if ( self.url.length > 4 && ![[self.url substringToIndex:4] isEqualToString:@"http"] )
    {
        self.url = [NSString stringWithFormat:@"http://%@",self.url];
    }
    
    [self clearCache];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0]];
    [self.view addSubview:self.webView];
    
    [self initProgressView];
    
    self.webView.scrollView.bounces = !self.disableBounces;
    
//    [self registerNofitificationForMainThread:kICAlipayManagerPayResponse];
}

- (void)didShareButtonPressed:(id)sender
{
    UIActionSheet* v = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"好友",@"朋友圈",nil];
    [v showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex > 1 )
        return;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    
    if ( buttonIndex == 0 )
    {
        req.scene = WXSceneSession;
    }
    else if ( buttonIndex == 1 )
    {
        req.scene = WXSceneTimeline;
    }
    
    WXMediaMessage *wxMediaMessage = [WXMediaMessage message];
    req.message = wxMediaMessage;
    
    wxMediaMessage.title = @"分享";
    wxMediaMessage.description = @"";
    
    id mediaObject = [WXWebpageObject object];
    ((WXWebpageObject *)mediaObject).webpageUrl = self.url;
    wxMediaMessage.mediaObject = mediaObject;
    
    [WXApi sendReq:req];
}

- (void)initNaviBarButton
{
    if (self.customTitle.length != 0)
    {
        self.title = self.customTitle;
    }
    
    UIImage *buttonImage = [UIImage imageNamed:LS(@"webview_navi_back_n")];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (44 - buttonImage.size.height)/2, buttonImage.size.width, buttonImage.size.height)];
    if (IS_SDK7)
    {
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -21, 0, 0);
    }
    else
    {
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    }
    [backButton setImage:buttonImage forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:LS(@"webview_navi_back_h")] forState: UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(didBackButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 0, 32, 44);
    if (IS_SDK7)
    {
        closeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    }
    else
    {
        closeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -19, 0, 0);
    }
    closeButton.backgroundColor = [UIColor clearColor];
    closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton setTitleColor:COLOR(243.0, 237.0, 225.0, 1.0) forState:UIControlStateHighlighted];
    [closeButton setTitle:LS(@"WebViewNaviClose") forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(didCloseButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.closeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    
    if (self.tabbar.tabBarController)
    {
        [self.tabbar.tabBarController.navigationItem setLeftBarButtonItem:(self.webView.canGoBack) ? self.backButtonItem : nil];
    }
    else
    {
        if (!self.webView.canGoBack)
        {
            self.navigationItem.leftBarButtonItems = nil;
            self.navigationItem.leftBarButtonItem = self.backButtonItem;
        }
        else
        {
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:self.backButtonItem, self.closeButtonItem, nil];
        }
    }
}

- (void)refreshNaviLeftBarButton
{
    if ( self.tabbar.tabBarController )
    {
        if ( self.tabbar.tabBarController.selectedViewController != self.tabbar )
            return;
    }
    
    if ([self.webView stringByEvaluatingJavaScriptFromString:@"document.title"] != 0)
    {
        self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
    if (self.tabbar.tabBarController)
    {
        [self.tabbar.tabBarController.navigationItem setLeftBarButtonItem:(self.webView.canGoBack) ? self.backButtonItem : nil];
    }
    else
    {
        if (!self.webView.canGoBack)
        {
            self.navigationItem.leftBarButtonItems = nil;
            self.navigationItem.leftBarButtonItem = self.backButtonItem;
        }
        else
        {
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:self.backButtonItem, self.closeButtonItem, nil];
        }
    }
}

- (void)didRightBarButtonItemClick:(id)sender
{
    self.jsBlock(self.webView);
}

- (void)clearCache
{
//    NSHTTPCookie *cookie;
//    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (cookie in [storage cookies])
//    {
//        [storage deleteCookie:cookie];
//    }
//    
//    NSURLCache * cache = [NSURLCache sharedURLCache];
//    [cache removeAllCachedResponses];
//    [cache setDiskCapacity:0];
//    [cache setMemoryCapacity:0];
}

- (BOOL)shouldNotPushBack
{
    return NO;
}

- (void)didBackButtonPressed:(id)sender
{
    if ([self shouldNotPushBack])
    {
        return ;
    }
    
    if (self.webView.canGoBack)
    {
        mLoadingCount = 0;
        mDisableProgress = FALSE;
        [self.webView goBack];
        [self performSelector:@selector(workAroundForGoBack) withObject:nil afterDelay:0.3];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)workAroundForGoBack
{
    [self refreshNaviLeftBarButton];
}

- (void)didCloseButtonPressed:(id)sender
{
    if ([self shouldNotPushBack])
    {
        return ;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initProgressView
{
    mCurrentProgress = WebViewProgress_None;
    mLoadingCount = 0;
    
    self.progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 3)];
    self.progressView.backgroundColor = [UIColor whiteColor];
    self.progressView.clipsToBounds = YES;
    [self.view addSubview:self.progressView];
    
    CAGradientLayer *loadingBarGradientLayer = [CAGradientLayer layer];
    loadingBarGradientLayer.colors = @[(id)[[UIColor colorWithRed:72/255.0 green:190/255.0 blue:251/255.0 alpha:1] CGColor],(id)[[UIColor colorWithRed:11/255.0 green:169/255.0 blue:250/255.0 alpha:1]CGColor]];
    loadingBarGradientLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 3);
    [self.progressView.layer addSublayer:loadingBarGradientLayer];
}

- (void)setProgress:(WebViewProgress)progress
{
    if ( mDisableProgress )
        return;
    
    if ( progress <= mCurrentProgress && mCurrentProgress != WebViewProgress_Finished )
    {
        return;
    }
    
    mCurrentProgress = progress;
    
    CGFloat ratio = 0;
    if ( mCurrentProgress == WebViewProgress_Loading )
    {
        ratio = 0.6;
    }
    else if ( mCurrentProgress == WebViewProgress_Finished )
    {
        ratio = 1;
    }
    
    CGFloat animationDuration = 3;
    
    if ( mCurrentProgress == WebViewProgress_Finished )
    {
        mDisableProgress = TRUE;
        animationDuration = 0.3;
    }
    
    CALayer* layer = self.progressView.layer.presentationLayer;
    self.progressView.frame = layer.frame;
    [self.progressView.layer removeAllAnimations];
    
    //NSLog(@"self.progressView.frame = %@",NSStringFromCGRect(self.progressView.frame));
    
    if ( mCurrentProgress == WebViewProgress_Loading )
    {
        [UIView animateWithDuration:animationDuration animations:^{
            CGRect frame = self.progressView.frame;
            frame.size.width = ratio * self.view.frame.size.width;
            self.progressView.frame = frame;
            
            //NSLog(@"animation1 = %@",NSStringFromCGRect(self.progressView.frame));
        } completion:^(BOOL finished) {
            if ( mCurrentProgress == WebViewProgress_Loading )
            {
                [UIView animateWithDuration:10 animations:^{
                    CGRect frame = self.progressView.frame;
                    frame.size.width = 0.9 * self.view.frame.size.width;
                    self.progressView.frame = frame;
                    //NSLog(@"animation2 = %@",NSStringFromCGRect(self.progressView.frame));
                } completion:^(BOOL finished) {
                    
                }];
            }
        }];
    }
    else
    {
        [UIView animateWithDuration:animationDuration animations:^{
            CGRect frame = self.progressView.frame;
            frame.size.width = ratio * self.view.frame.size.width;
            self.progressView.frame = frame;
        } completion:^(BOOL finished) {
            if ( progress == WebViewProgress_Finished )
            {
                CGRect frame = self.progressView.frame;
                frame.size.width = 0;
                self.progressView.frame = frame;
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    if (self.webView)
    {
        if (self.webView.isLoading)
        {
            [self.webView stopLoading];
        }
        self.webView.delegate = nil;
        self.webView = nil;
    }
}

#pragma mark -
#pragma mark UIWebViewDelegate Methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ( self.delegate)
    {
        if ([request.URL.scheme isEqualToString:self.observeScheme])
        {
            [self.delegate didObserveSchemeFind:request];
        }
    }
    
    if ([request.URL.scheme isEqualToString:@"bornhr"])
    {
        NSString *query = request.URL.query;                                                                                                                                           
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSMutableDictionary *encodingDict = [NSMutableDictionary dictionary];
        NSArray *queryItems = [query componentsSeparatedByString:@"&"];
        for (NSString *queryItem in queryItems) {
            NSArray *subItems = [queryItem componentsSeparatedByString:@"="];
            NSString *value = [[subItems lastObject] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *key = [[subItems firstObject] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [dict setObject:[subItems lastObject]  forKey:[subItems firstObject]];
            [encodingDict setObject:value forKey:key];
        }

        if ([request.URL.host isEqualToString:@"alipay"])
        {
            NSString *notifyURL = [NSString stringWithUTF8String:[[encodingDict objectForKey:@"notify_url"] UTF8String]];
            NSString *tradNo = [encodingDict objectForKey:@"out_trade_no"];
            NSString *price = [encodingDict objectForKey:@"total_fee"];
            NSString *title = [encodingDict objectForKey:@"subject"];
            NSString *description = [encodingDict objectForKey:@"body"];
            
//            [[ICAlipayManager sharedManager] payWithTradeNumber:tradNo title:title description:description price:price notifyURL:notifyURL];
            
            NSLog(@"dict: %@",dict);
            NSLog(@"encodeDict: %@",dict);
        }
        else if ([request.URL.host isEqualToString:@"weixin"])
        {
            NSString *tradeNo             = [encodingDict objectForKey:@"out_trade_no"];
            NSString *partnerId           = [encodingDict objectForKey:@"partnerid"];
            NSString *prepayId            = [encodingDict objectForKey:@"prepayid"];
            NSString *nonceStr            = [encodingDict objectForKey:@"noncestr"];
            NSString *timeTamp            = [encodingDict objectForKey:@"timestamp"];
            NSString *package             = [encodingDict objectForKey:@"package"];
            NSString *sign                = [encodingDict objectForKey:@"sign"];
            
//            [[WeixinManager shareManager] payWithTradeNo:tradeNo prepayId:prepayId partnerId:partnerId nonceStr:nonceStr timeStamp:timeTamp package:package sign:sign completed:^(int ret, NSString *tradeNo) {
//                if (ret == WXSuccess) {
//                    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"checkPayState('%@','%@')", tradeNo,@"success"]];
//                }
//                else
//                {
//                    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"checkPayState('%@','%@')", tradeNo,@"fail"]];
//                }
//                
//            }];
        }
    }
    
    if ([request.URL.scheme.lowercaseString isEqualToString:@"https"])
    {
        if (!self.isAuthed)
        {
            originRequest = request;
            NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [conn start];
            [webView stopLoading];
            return NO;
        }
    }
    
    if ([request.URL.absoluteString isEqualToString:kCompleteWebviewURL])
    {
        [self setProgress:WebViewProgress_Finished];
        return NO;
    }
    
    BOOL isFragmentJump = NO;
    if (request.URL.fragment)
    {
        NSString *nonFragmentURL = [request.URL.absoluteString stringByReplacingOccurrencesOfString:[@"#" stringByAppendingString:request.URL.fragment] withString:@""];
        isFragmentJump = [nonFragmentURL isEqualToString:webView.request.URL.absoluteString];
    }
    
    BOOL isTopLevelNavigation = [request.mainDocumentURL isEqual:request.URL];
    BOOL isHTTP = [request.URL.scheme.lowercaseString isEqualToString:@"http"] || [request.URL.scheme.lowercaseString isEqualToString:@"https"];
    
    if ( !isFragmentJump && isHTTP && isTopLevelNavigation )
    {
        self.loadingUrl = [request URL];
        if ( navigationType == UIWebViewNavigationTypeLinkClicked )
        {
            mLoadingCount = 0;
            mDisableProgress = FALSE;
        }
    }
    
    [self performSelector:@selector(workAroundForGoBack) withObject:nil afterDelay:0.3];
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self stopInteractiveTimer];
    mLoadingCount++;
    [self handleLoadingRequest];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    mLoadingCount--;
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self handleLoadingRequest];
    [self refreshNaviLeftBarButton];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    mLoadingCount--;
    [self handleLoadingRequest];
}

- (void)handleLoadingRequest
{
    if ( self.loadingUrl )
    {
        [self setProgress:WebViewProgress_Loading];
    }
    
    NSString *readyState = [self.webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    
    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive)
    {
        NSString *waitForCompleteJS = [NSString stringWithFormat:@"window.addEventListener('load',function() { "
                                       @"var iframe = document.createElement('iframe');"
                                       @"iframe.style.display = 'none';"
                                       @"iframe.src = '%@';"
                                       @"document.body.appendChild(iframe);"
                                       @"}, false);", kCompleteWebviewURL];
        
        [self.webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
        
        if ([self.webView stringByEvaluatingJavaScriptFromString:@"document.title"].length != 0)
        {
            self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        }
    }
    
    BOOL isNotRedirect = TRUE; //self.loadingUrl && [self.loadingUrl isEqual:self.webView.request.URL];
    
    BOOL complete = [readyState isEqualToString:@"complete"];
    if ( complete && isNotRedirect && mLoadingCount <= 0 )
    {
        [self setProgress:WebViewProgress_Finished];
    }
    else if ( interactive && isNotRedirect && mLoadingCount <= 0 )
    {
        [self startInteractiveTimer];
    }
}

- (void)startInteractiveTimer
{
    [self stopInteractiveTimer];
    mInteractiveTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(didInteractiveTimer) userInfo:nil repeats:NO];
}

- (void)stopInteractiveTimer
{
    if ( mInteractiveTimer )
    {
        [mInteractiveTimer invalidate];
        mInteractiveTimer = nil;
    }
}

- (void)didInteractiveTimer
{
    [self setProgress:WebViewProgress_Finished];
}

- (void)setDisableBounces:(BOOL)disableBounces
{
    _disableBounces = disableBounces;
    self.webView.scrollView.bounces = !disableBounces;
}

-(BOOL)isLoadFinished
{
    if ( !self.webView.canGoBack && self.webView.loading )
        return FALSE;
    
    return TRUE;
}

- (void)reload
{
    [self clearCache];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0]];
}


#pragma mark - Received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    NSDictionary *dict = notification.userInfo;
    NSLog(@"Ali dict:%@",dict);
//    NSNumber *result = [dict objectForKey:kICAlipayManagerResultKey];
//
//    NSString *tradNO = [dict objectForKey:kICAlipayManagerTradeNoKey];
//
//    if ([result integerValue] == kICAlipayManagerResult_OK) {
//        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"checkPayState('%@','%@')", tradNO,@"success"]];
//    }
////    else if ([result integerValue] == kICAlipayManagerResult_Cancel)
////    {
////        NSLog(@"支付宝取消支付");
////    }
//    else
//    {
//        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"checkPayState('%@','%@')", tradNO,@"fail"]];
//    }
    
}

#pragma mark -
#pragma mark UIActionSheetDelegate Methods

//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == kWebViewActionSheetItem_Copy && self.url)
//    {
//        [[UIPasteboard generalPasteboard] setPersistent:YES];
//        [[UIPasteboard generalPasteboard] setValue:self.url forPasteboardType:[UIPasteboardTypeListString objectAtIndex:0]];
//    }
//    else if (buttonIndex == kWebViewActionSheetItem_Safari)
//    {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.url]];
//    }
//}


- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog(@"didReceiveAuthenticationChallenge %@ %zd", [[challenge protectionSpace] authenticationMethod], (ssize_t) [challenge previousFailureCount]);
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        [[challenge sender]  useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        
        [[challenge sender]  continueWithoutCredentialForAuthenticationChallenge: challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.isAuthed = YES;
    [self.webView loadRequest:originRequest];
    [connection cancel];
}

- (void)setRightItemJs:(void (^)(UIWebView* webview))block
{
    self.jsBlock = block;
}

@end

