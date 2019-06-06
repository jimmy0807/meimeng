//
//  PadWebViewController.m
//  CardBag
//
//  Created by jimmy on 13-9-25.
//  Copyright (c) 2013年 Everydaysale. All rights reserved.
//

#import "PadWebViewController.h"
#import "UIViewController+MMDrawerController.h"

#define kCompleteWebviewURL @"kCompleteWebviewURL:///complete"

typedef enum WebViewProgress
{
    WebViewProgress_None,
    WebViewProgress_Loading,
    WebViewProgress_Finished
}WebViewProgress;

@interface PadWebViewController ()
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
@property(nonatomic, weak)IBOutlet UILabel* titleLabel;
@property(nonatomic, weak)IBOutlet UIButton* backButton;
@property (nonatomic, weak)IBOutlet UIButton* closeButton;
@property (nonatomic, weak)IBOutlet UIView* naviView;
@end

@implementation PadWebViewController

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
    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    if ( self.hideNavigation )
    {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    }
    else
    {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 75, 1024, 693)];
    }
    
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
    
    if ( self.isCloseButton )
    {
        [self.closeButton setImage:[UIImage imageNamed:@"pad_navi_close_n"] forState:UIControlStateNormal];
    }
    
    if ( self.hideNavigation )
    {
        self.naviView.hidden = YES;
    }
    
//    [self registerNofitificationForMainThread:kICAlipayManagerPayResponse];
}

- (void)clearCache
{
    
}

- (void)initNaviBarButton
{
    if (self.customTitle.length != 0)
    {
        self.titleLabel.text = self.customTitle;
    }
    
    self.backButton.hidden = YES;
}

- (void)refreshNaviLeftBarButton
{
    self.backButton.hidden = !self.webView.canGoBack;
    
    if ([self.webView stringByEvaluatingJavaScriptFromString:@"document.title"] != 0)
    {
        self.titleLabel.text = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}

- (BOOL)shouldNotPushBack
{
    return NO;
}

- (IBAction)didBackButtonPressed:(id)sender
{
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
    
    if ( self.hideNavigation )
    {
        self.progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 3)];
    }
    else
    {
        self.progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 72, 0, 3)];
    }
    
    self.progressView.backgroundColor = [UIColor whiteColor];
    self.progressView.clipsToBounds = YES;
    [self.view addSubview:self.progressView];
    
    CAGradientLayer *loadingBarGradientLayer = [CAGradientLayer layer];
    loadingBarGradientLayer.colors = @[(id)[[UIColor colorWithRed:90/255.0 green:211/255.0 blue:213/255.0 alpha:1] CGColor],(id)[[UIColor colorWithRed:90/255.0 green:211/255.0 blue:213/255.0 alpha:1]CGColor]];
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
        if ( [request.URL.host isEqualToString:@"pop"] )
        {
            if ( self.isCloseButton )
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
            }
            
            return NO;
        }
        
        NSString *query = request.URL.query;
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSMutableDictionary *encodingDict = [NSMutableDictionary dictionary];
        NSArray *queryItems = [query componentsSeparatedByString:@"&"];
        for (NSString *queryItem in queryItems)
        {
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
            
//            [self.webView scr]
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
            self.titleLabel.text = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
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
//    else
//    {
//        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"checkPayState('%@','%@')", tradNO,@"fail"]];
//    }
    
}

#pragma mark -
#pragma mark UIActionSheetDelegate Methods
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

- (IBAction)didMenuButtonPressed:(id)sender
{
    if ( self.isCloseButton )
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
}

@end

