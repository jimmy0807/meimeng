//
//  ICTableViewController.m
//  meim
//
//  Created by jimmy on 2017/4/26.
//
//

#import "ICTableViewController.h"

@interface ICTableViewController ()

@end

@implementation ICTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector: @selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    if ([self respondsToSelector: @selector(setExtendedLayoutIncludesOpaqueBars:)])
    {
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    
    if ([self respondsToSelector: @selector(setModalPresentationCapturesStatusBarAppearance:)])
    {
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)prefersStatusBarHidden
{
    if (DEVICE_IS_IPAD)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
#ifdef Staff
    return UIStatusBarStyleDefault;
#else
    return UIStatusBarStyleLightContent;
#endif
}

@end
