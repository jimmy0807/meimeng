//
//  GiveRightViewController.m
//  Boss
//
//  Created by lining on 15/10/29.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "GiveRightViewController.h"

@interface GiveRightViewController ()

@end

@implementation GiveRightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noKeyboardNotification = YES;
    [self forbidSwipGesture];
    
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)rightBtnPressed:(UIButton *)sender {
    self.btn.selected = !self.btn.selected;
    self.bgImgView.highlighted = !self.bgImgView.highlighted;
    if ([self.delegate respondsToSelector:@selector(didRightBtnPressed:)]) {
        [self.delegate didRightBtnPressed:self.btn];
    }
}

@end
