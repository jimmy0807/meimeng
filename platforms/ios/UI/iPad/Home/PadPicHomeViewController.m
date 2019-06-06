//
//  PadPicHomeViewController.m
//  meim
//
//  Created by jimmy on 2017/6/5.
//
//

#import "PadPicHomeViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "EPadMenuViewController.h"

@interface PadPicHomeViewController ()
@property(nonatomic, weak)IBOutlet UIView* bgView;
@property(nonatomic, strong)UIView* loadingView;
@property(nonatomic, strong)UILabel* loadingProgressLabel;
@property(nonatomic, strong)UIView* loadingProgressView;
@property(nonatomic, strong)UIButton* loadingMaskButton;
@property(nonatomic, strong)IBOutlet UILabel* versionLabel;
@property(nonatomic, strong)IBOutlet UIButton* emenuButton;

@end

@implementation PadPicHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setHeaderView];
    
    [self registerNofitificationForMainThread:kBSPadDataRequestSuccess];
    [self registerNofitificationForMainThread:kBSPadDataRequestFailed];
    [self registerNofitificationForMainThread:kBSPadDataRequestFinishCount];
    [self registerNofitificationForMainThread:kBSFetchStartInfoResponse];
    [self registerNofitificationForMainThread:kBSLoginResponse];
    NSString *versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"版本号：%@",versionString];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%@",[PersonalProfile currentProfile].group_pad_order);
    if (![[PersonalProfile currentProfile].group_pad_order boolValue])
    {
        self.emenuButton.hidden = YES;
    }
    else
    {
        self.emenuButton.hidden = NO;
        self.emenuButton.layer.shadowOpacity = 0.06;
        self.emenuButton.layer.shadowColor = COLOR(0, 0, 0, 1).CGColor;
        self.emenuButton.layer.shadowOffset = CGSizeMake(3, 4);
    }
}

- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSPadDataRequestSuccess] || [notification.name isEqualToString:kBSPadDataRequestFailed])
    {
        [self.loadingMaskButton removeFromSuperview];
        self.loadingMaskButton = nil;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.bgView.frame = CGRectMake(0, 0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
            self.loadingView.frame = CGRectMake(0, -75, IC_SCREEN_WIDTH, 75);
        } completion:^(BOOL finished) {
            [self.loadingView removeFromSuperview];
            self.loadingView = nil;
        }];
        if (![[PersonalProfile currentProfile].group_pad_order boolValue])
        {
            self.emenuButton.hidden = YES;
        }
        else
        {
            self.emenuButton.hidden = NO;
            self.emenuButton.layer.shadowOpacity = 0.06;
            self.emenuButton.layer.shadowColor = COLOR(0, 0, 0, 1).CGColor;
            self.emenuButton.layer.shadowOffset = CGSizeMake(3, 4);
        }
        [self.view setNeedsDisplay];
    }
    else if ([notification.name isEqualToString:kBSPadDataRequestFinishCount])
    {
        NSDictionary *params = notification.userInfo;
        [self setTableViewHeadViewProgress:[[params objectForKey:@"finish_count"] floatValue] / [[params objectForKey:@"total_count"] integerValue]];
    }
    else if ([notification.name isEqualToString:kBSFetchStartInfoResponse] || [notification.name isEqualToString:kBSLoginResponse])
    {
        NSInteger result = [[notification.userInfo valueForKey:@"rc"] integerValue];
        if (result == 0)
        {
            [self setHeaderView];
        }
       
        if (![[PersonalProfile currentProfile].group_pad_order boolValue])
        {
            self.emenuButton.hidden = YES;
        }
        else
        {
            self.emenuButton.hidden = NO;
            self.emenuButton.layer.shadowOpacity = 0.06;
            self.emenuButton.layer.shadowColor = COLOR(0, 0, 0, 1).CGColor;
            self.emenuButton.layer.shadowOffset = CGSizeMake(3, 4);
        }
        [self.view setNeedsDisplay];
    }
}

- (void)setTableViewHeadViewProgress:(CGFloat)progress
{
    CALayer* layer = self.loadingProgressView.layer.presentationLayer;
    
    if ( layer == nil )
        return;
    
    self.loadingProgressView.frame = layer.frame;
    [self.loadingProgressView.layer removeAllAnimations];
    
    self.loadingProgressLabel.text = [NSString stringWithFormat:@"正在加载数据  %d%%",(NSInteger)(progress * 100)];
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.loadingProgressView.frame;
        frame.size.width = progress * self.view.frame.size.width;
        self.loadingProgressView.frame = frame;
    }];
}

- (IBAction)didMenuButtonPressed:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)setHeaderView
{
    if ( self.notShowHeader )
        return;
    
    if ( self.loadingView )
        return;
    
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IC_SCREEN_WIDTH, 75)];
    self.loadingView.backgroundColor = [UIColor whiteColor];
    
    self.loadingProgressView = [[UIView alloc] initWithFrame:CGRectMake(0, 72, 0, 3)];
    self.loadingProgressView.backgroundColor = COLOR(250, 197, 24, 1);
    [self.loadingView addSubview:self.loadingProgressView];
    
    self.loadingProgressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 21, IC_SCREEN_WIDTH, 30)];
    self.loadingProgressLabel.textColor = [UIColor blackColor];
    self.loadingProgressLabel.textAlignment = NSTextAlignmentCenter;
    self.loadingProgressLabel.text = [NSString stringWithFormat:@"正在加载数据  %d%%",0];
    [self.loadingView addSubview:self.loadingProgressLabel];
    
    if ( self.loadingMaskButton )
    {
        [self.loadingMaskButton removeFromSuperview];
    }
    self.loadingMaskButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loadingMaskButton.frame = CGRectMake(0, 0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
    [self.view addSubview:self.loadingMaskButton];
    
    [self.view addSubview:self.loadingView];
    self.bgView.frame = CGRectMake(0, 75, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
}

- (IBAction)JumpIntoEMenu:(id)sender
{
    EPadMenuViewController *emenu = [[EPadMenuViewController alloc] init];
    emenu.fromView = @"Home";
    [self.navigationController pushViewController:emenu animated:NO];
}

@end
