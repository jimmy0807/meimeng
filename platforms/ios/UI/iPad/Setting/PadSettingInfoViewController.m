//
//  PadSettingInfoViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/12/2.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadSettingInfoViewController.h"
#import "PadSettingConstant.h"

@interface PadSettingInfoViewController ()

@property (nonatomic, assign) kPadSettingDetailType type;
@end

@implementation PadSettingInfoViewController

- (id)initWithType:(kPadSettingDetailType)type
{
    self = [super initWithNibName:@"PadSettingInfoViewController" bundle:nil];
    if (self != nil)
    {
        self.type = type;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.noKeyboardNotification = YES;
    self.view.backgroundColor = [UIColor clearColor];
    self.view.frame = CGRectMake(kPadMaskViewLeftWidth, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
    
    UIImageView *infoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, self.view.frame.size.width, self.view.frame.size.height - kPadNaviHeight)];
    infoImage.backgroundColor = [UIColor clearColor];
    if (self.type == kPadSettingDetailPrinter)
    {
        infoImage.image = [UIImage imageNamed:@"pad_setting_printer"];
    }
    else if (self.type == kPadSettingDetailCodeScanner)
    {
        infoImage.image = [UIImage imageNamed:@"pad_setting_code_scanner"];
    }
    else if (self.type == kPadSettingDetailPosMachine)
    {
        infoImage.image = [UIImage imageNamed:@"pad_setting_pos_machine"];
    }
    else if (self.type == kPadSettingDetailCamera)
    {
        infoImage.image = [UIImage imageNamed:@"pad_setting_camera"];
    }
    [self.view addSubview:infoImage];
    
    UIImage *naviImage = [UIImage imageNamed:@"pad_navi_background"];
    UIImageView *navi = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, kPadSettingRightSideViewWidth, naviImage.size.height)];
    navi.backgroundColor = [UIColor clearColor];
    navi.image = naviImage;
    navi.userInteractionEnabled = YES;
    [self.view addSubview:navi];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.backgroundColor = [UIColor clearColor];
    closeButton.frame = CGRectMake(0.0, 0.0, kPadNaviHeight, kPadNaviHeight);
    [closeButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_close_n"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_close_h"] forState:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(didCloseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navi addSubview:closeButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadNaviHeight, (kPadNaviHeight - 20.0)/2.0, navi.frame.size.width - 2 * kPadNaviHeight, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    if (self.type == kPadSettingDetailPrinter)
    {
        titleLabel.text = LS(@"kPadSettingPrinter");
    }
    else if (self.type == kPadSettingDetailCodeScanner)
    {
        titleLabel.text = LS(@"kPadSettingCodeScanner");
    }
    else if (self.type == kPadSettingDetailPosMachine)
    {
        titleLabel.text = LS(@"kPadSettingPosMachine");
    }
    else if (self.type == kPadSettingDetailHandWriteBook)
    {
        titleLabel.text = LS(@"kPadSettingHandWriteBook");
    }
    else if (self.type == kPadSettingDetailCamera)
    {
        titleLabel.text = LS(@"kPadSettingCamera");
    }
    [navi addSubview:titleLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark  Methods

- (void)didCloseButtonClick:(id)sender
{
    [self.maskView hidden];
}

@end
