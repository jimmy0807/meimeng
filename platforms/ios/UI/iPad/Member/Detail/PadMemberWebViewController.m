//
//  PadMemberWebViewController.m
//  meim
//
//  Created by 波恩公司 on 2018/7/17.
//

#import "PadMemberWebViewController.h"
#import "PadProjectConstant.h"

@implementation PadMemberWebViewController

- (id)initWithMemberCard:(CDMemberCard *)memberCard
{
    self = [super initWithNibName:@"PadMemberWebViewController" bundle:nil];
    if (self)
    {
        self.memberID = memberCard.member.memberID;
    }
    
    return self;
}

- (id)initWithMemberID:(NSNumber *)memberID
{
    self = [super initWithNibName:@"PadMemberWebViewController" bundle:nil];
    if (self)
    {
        self.memberID = memberID;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIWebView* webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, kPadNaviHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - kPadNaviHeight)];
    //webView.scrollView.bounces = NO;
    NSLog(@"%@,%@,%@,%@",[PersonalProfile currentProfile].baseUrl, [PersonalProfile currentProfile].sql, [PersonalProfile currentProfile].userID, self.memberCard.member.memberID);
    
    NSString *str = [NSString stringWithFormat:@"%@/%@/member/%@/%@",[PersonalProfile currentProfile].baseUrl, [PersonalProfile currentProfile].sql, [PersonalProfile currentProfile].userID, self.memberID];
    NSURL *url = [NSURL URLWithString:str];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建
    [webView loadRequest:request];
    
    
    [self.view addSubview:webView];
    
    UIImageView *naviImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, kPadNaviHeight + 3.0)];
    naviImageView.backgroundColor = [UIColor clearColor];
    naviImageView.image = [UIImage imageNamed:@"pad_navi_background"];
    naviImageView.userInteractionEnabled = YES;
    [self.view addSubview:naviImageView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    backButton.frame = CGRectMake(0.0, 0.0, 2 * 66.0, kPadNaviHeight);
    UIImage *backImage = [UIImage imageNamed:@"pad_navi_back_n"];
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(66.0 - kPadNaviHeight + 20.0, 0.0, kPadNaviHeight, kPadNaviHeight)];
    backImageView.backgroundColor = [UIColor clearColor];
    backImageView.image = backImage;
    [backButton addSubview:backImageView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(66.0, 0.0, 66.0, kPadNaviHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.textColor = COLOR(148.0, 172.0, 172.0, 1.0);
    titleLabel.text = LS(@"PadMemberPersonalInfo");
    [backButton addSubview:titleLabel];
    [backButton addTarget:self action:@selector(didBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [naviImageView addSubview:backButton];
}

- (void)didBackButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
