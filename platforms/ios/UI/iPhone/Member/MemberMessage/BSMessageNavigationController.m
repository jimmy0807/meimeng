//
//  BSMessageNavigationController.m
//  Boss
//
//  Created by lining on 16/6/24.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSMessageNavigationController.h"

@implementation BSMessageNavigationController

- (void)viewDidLoad
{
//    self.navigationBar.barTintColor = [UIColor colorWithRed:56/255.0 green:126/255.0 blue:245/255.0 alpha:1];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
