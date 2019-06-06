//
//  GiveLeftViewController.m
//  Boss
//
//  Created by lining on 15/10/29.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "GiveLeftViewController.h"

@interface GiveLeftViewController ()

@end

@implementation GiveLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noKeyboardNotification = YES;
    [self forbidSwipGesture];
    
    self.bgImgView.highlighted = YES;
}

- (IBAction)backBtnPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didBackBtnPressed:)]) {
        [self.delegate didBackBtnPressed:nil];
    }
}

- (IBAction)leftBtnPressed:(UIButton *)sender {
    self.btn.selected = !self.btn.selected;
    //    self.bgImgView.highlighted = !self.bgImgView.highlighted;
    //    if (self.bgImgView.highlighted ) {
    //        self.backBtnView.hidden = true;
    //    }
    //    else
    //    {
    //        self.backBtnView.hidden = false;
    //    }
    if ([self.delegate respondsToSelector:@selector(didLeftBtnPressed:)]) {
        [self.delegate didLeftBtnPressed:self.btn];
    }
}


#define k
#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

