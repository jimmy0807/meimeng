//
//  AboutViewController.m
//  Boss
//
//  Created by mac on 15/7/2.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()


@end

@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigationBarButtonItem];
    [self initVersion];
}

- (void)initNavigationBarButtonItem
{
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    self.navigationItem.title = @"关于";
    self.view.backgroundColor = COLOR(242, 242, 242, 1.0);
    self.acopyRight.contentMode = UIViewContentModeScaleAspectFit;
    self.logoImageVeiw.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)initVersion
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = currentVersion;
}

@end
