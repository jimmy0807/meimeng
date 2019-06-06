//
//  LoginScrollViewController.m
//  Boss
//
//  Created by lining on 15/3/30.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "LoginScrollViewController.h"
#import "LoginViewController.h"
#import "CBPageCotrol.h"
#import "UIImage+Resizable.h"

#define WELCOME_PIC_COUNT       3
#define kMarginSize             10
#define kTitleLabelHeight       45
#define kDetialLabelHeight      26

@interface LoginScrollViewController ()
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIButton *registerBtn;
@property(nonatomic, strong) CBPageCotrol *pageControl;
@end

@implementation LoginScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBottomBtn];
    [self initScrollView];
    [self initPageControl];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)initBottomBtn
{
    CGFloat height = IC_SCREEN_HEIGHT;
    if (!IS_SDK7) {
        height = IC_SCREEN_HEIGHT -20;
    }
    self.registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img_n = [UIImage imageNamed:@"login_btn_n.png"];
    UIImage *img_h = [UIImage imageNamed:@"login_btn_h.png"];
    self.registerBtn.frame = CGRectMake(0, height - img_n.size.height, IC_SCREEN_WIDTH, img_n.size.height);
    [self.registerBtn addTarget:self action:@selector(registerBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.registerBtn setBackgroundImage:img_n forState:UIControlStateNormal];
    [self.registerBtn setBackgroundImage:img_h forState:UIControlStateHighlighted];
    [self.registerBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:self.registerBtn];
}

- (void)initScrollView
{
    CGFloat height = IC_SCREEN_HEIGHT;
    if (!IS_SDK7) {
        height = IC_SCREEN_HEIGHT -20;
    }
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, IC_SCREEN_WIDTH, height - self.registerBtn.frame.size.height)];
    self.scrollView.showsHorizontalScrollIndicator = false;
    self.scrollView.pagingEnabled = true;
    for (int i = 0; i < WELCOME_PIC_COUNT; i++) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(IC_SCREEN_WIDTH*i, 0, IC_SCREEN_WIDTH, self.scrollView.frame.size.height)];
        [self.scrollView addSubview:view];
        
        float yRadio = height/480;
        
        NSString *name = [NSString stringWithFormat:@"login_page_pic_%d.png",i+1];
        UIImage *img =[[UIImage imageNamed:name] imageResizableWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
//        imgView.frame = CGRectMake((IC_SCREEN_WIDTH - img.size.width)/2.0, yCoord, img.size.width, img.size.height);
        
        float xRadio = IC_SCREEN_WIDTH/img.size.width;
        imgView.frame = CGRectMake(0, 0, IC_SCREEN_WIDTH, img.size.height*xRadio);
        imgView.backgroundColor = [UIColor clearColor];
        CGFloat center_y ;
        if (yRadio > 1) {
            center_y = height/2.0 + 30*yRadio;
        }
        else
        {
            center_y = height/2.0 + 15*yRadio;
        }
        
        imgView.center = CGPointMake(IC_SCREEN_WIDTH/2.0, center_y);
        if (i == 0) {
//            imgView.frame = CGRectMake((IC_SCREEN_WIDTH - img.size.width)/2.0, IC_SCREEN_HEIGHT - self.registerBtn.frame.size.height - img.size.height, img.size.width, img.size.height);
            imgView.frame = CGRectMake(0, height - self.registerBtn.frame.size.height - img.size.height, IC_SCREEN_WIDTH, img.size.height*xRadio);
        }
        
        [view addSubview:imgView];
        
        CGFloat yCoord = 0;
        
        yCoord = center_y - imgView.frame.size.height/2 - kDetialLabelHeight;
        if (yRadio > 1) {
            yCoord = yCoord - 20;
        }
        
        UILabel *detailText = [[UILabel alloc] initWithFrame:CGRectMake(0, yCoord, IC_SCREEN_WIDTH, kDetialLabelHeight)];
        detailText.backgroundColor = [UIColor clearColor];
        detailText.textAlignment = NSTextAlignmentCenter;
        detailText.font = [UIFont boldSystemFontOfSize:17];
        detailText.textColor  = COLOR(53, 171, 245, 255);
        NSString *detailTitle = [NSString stringWithFormat:@"login_detail_title_%d",i+1];
        detailText.text = LS(detailTitle);
        [view addSubview:detailText];
        
        yCoord -= kTitleLabelHeight;
        
        UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, yCoord, IC_SCREEN_WIDTH, kTitleLabelHeight)];
        titleText.backgroundColor = [UIColor clearColor];
        NSString *title = [NSString stringWithFormat:@"login_title_%d",i+1];
        titleText.textAlignment = NSTextAlignmentCenter;
        titleText.textColor = COLOR(61, 64, 66, 1);
        titleText.font = [UIFont systemFontOfSize:34];
        titleText.text = LS(title);
        [view addSubview:titleText];
    }
    self.scrollView.contentSize = CGSizeMake(IC_SCREEN_WIDTH *WELCOME_PIC_COUNT,self.scrollView.frame.size.height);
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
}

- (void)initPageControl
{
    CGFloat height = IC_SCREEN_HEIGHT;
    if (!IS_SDK7) {
        height = IC_SCREEN_HEIGHT -20;
    }
    self.pageControl = [[CBPageCotrol alloc] initWithFrame:CGRectMake(0, height - self.registerBtn.frame.size.height - 2.5*kMarginSize, IC_SCREEN_WIDTH, 30) withImg:[UIImage imageNamed:@"login_page_dot_n.png"] highlightImg:[UIImage imageNamed:@"login_page_dot_h.png"] numberOfPages:WELCOME_PIC_COUNT];
    [self.view addSubview:self.pageControl];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int current = scrollView.contentOffset.x/IC_SCREEN_WIDTH;
 
    self.pageControl.currentPage = current;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    int current = ceil((scrollView.contentOffset.x- IC_SCREEN_WIDTH/2.0)/IC_SCREEN_WIDTH);
    
    self.pageControl.currentPage = current;
}

#pragma mark - btnPressedAction
- (void)registerBtnPressed:(UIButton *)btn
{
    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:NIBCT(@"LoginViewController") bundle:nil];
//    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}


@end
