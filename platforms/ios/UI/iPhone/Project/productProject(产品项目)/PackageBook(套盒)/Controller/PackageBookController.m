//
//  PackageBookController.m
//  Boss
//
//  Created by jiangfei on 16/7/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PackageBookController.h"
#import "UIView+Frame.h"
#import "baseInfoController.h"
#import "CombiPackBookController.h"
@interface PackageBookController ()
@property (weak, nonatomic) IBOutlet UIButton *baseInfoBtn;
@property (weak, nonatomic) IBOutlet UIButton *combinBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *subControllerView;
/** lastController*/
@property (nonatomic,strong)UIViewController *lastViewController;
/** baseVc*/
@property (nonatomic,strong)baseInfoController *baseInfoVC;
/** combin*/
@property (nonatomic,strong)CombiPackBookController *combiVC;
@end

@implementation PackageBookController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view insertSubview:self.subControllerView atIndex:0];
    [self.baseInfoBtn setTitleColor:projectTitleBtnNormalColor forState:UIControlStateNormal];
    [self.combinBtn setTitleColor:projectTitleBtnNormalColor forState:UIControlStateNormal];
    [self addSubController];
    [self showSubControllerView:0];
    [self receiveNotification];
    self.baseInfoBtn.selected = YES;
}
-(void)receiveNotification
{
    
    //保存按钮被点击
    [ myNotification addObserver:self selector:@selector(receiveSaveBtnClick:) name:productSaveBtnClick object:nil];
}
#pragma mark 接受到保存按钮点击
-(void)receiveSaveBtnClick:(NSNotification*)info
{
    
    if ([info.userInfo[@"index"] integerValue] == 4) {
        [myNotification postNotificationName:baseVCReceiveParentVCReceive object:@"course"  userInfo:info.userInfo];
    }
}

#pragma mark 显示子控制器对应的View
-(void)showSubControllerView:(NSInteger)tag
{
    [self.lastViewController.view removeFromSuperview];
    self.lastViewController = self.childViewControllers[tag];
    if (tag == 0) {
        self.baseInfoVC.baseProjectTemp = self.baseProjectTemp;
        self.baseInfoVC.parmasDict = self.parmasDict;
        self.baseInfoVC.view.frame = self.subControllerView.bounds;
        self.baseInfoVC.baseTage = 4;
        [self.subControllerView addSubview:self.baseInfoVC.view];
        
    }else{
        
        self.combiVC.baseProjectTemp = self.baseProjectTemp;
        self.combiVC.parmasDict = self.parmasDict;
        self.combiVC.view.frame = self.subControllerView.bounds;
        [self.subControllerView addSubview:self.combiVC.view];
        
    }
    
}

#pragma mark 添加子控制器
-(void)addSubController
{
    //消息控制器
    self.baseInfoVC = [[baseInfoController alloc]init];
    [self addChildViewController:self.baseInfoVC];
    //组合套控制器
    self.combiVC = [[CombiPackBookController alloc]init];
    [self addChildViewController:self.combiVC];
}
- (IBAction)baseInfoBtnClick:(UIButton *)sender {
    self.baseInfoBtn.selected = !self.baseInfoBtn.selected;
    self.combinBtn.selected = NO;
    self.lineView.x = self.baseInfoBtn.centerX;
    self.lineView.size = CGSizeMake(self.baseInfoBtn.titleLabel.width, self.lineView.size.height);
    self.lineView.center = CGPointMake(self.lineView.x, self.lineView.centerY);
    [self showSubControllerView:0];
    CATransition *transition = [[CATransition alloc]init];
    transition.type = @"push";
    transition.subtype =  kCATransitionFromRight;
    [self.subControllerView.layer addAnimation:transition forKey:nil];
}

- (IBAction)combinBtnClick:(UIButton *)sender {
    self.baseInfoBtn.selected = NO;
    self.combinBtn.selected = !self.combinBtn.selected;
    self.lineView.x = self.combinBtn.centerX;
    self.lineView.size = CGSizeMake(self.combinBtn.titleLabel.width, self.lineView.size.height);
    self.lineView.center = CGPointMake(self.lineView.x, self.lineView.centerY);
    [self showSubControllerView:1];
    CATransition *transition = [[CATransition alloc]init];
    transition.type = @"push";
    transition.subtype = kCATransitionFromLeft;
    [self.subControllerView.layer addAnimation:transition forKey:nil];
}


@end
