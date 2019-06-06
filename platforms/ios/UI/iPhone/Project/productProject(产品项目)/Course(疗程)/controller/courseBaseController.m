//
//  courseBaseController.m
//  Boss
//
//  Created by jiangfei on 16/6/13.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "courseBaseController.h"
#import "combinationController.h"
#import "baseInfoController.h"
#import "UIView+Frame.h"
@interface courseBaseController ()
@property (weak, nonatomic) IBOutlet UIView *subControllerView;
@property (weak, nonatomic) IBOutlet UIView *instructLine;
@property (weak, nonatomic) IBOutlet UIButton *combiBtn;
@property (weak, nonatomic) IBOutlet UIButton *baseInfoBtn;
/** 基本信息控制器*/
@property (nonatomic,strong)baseInfoController *baseInfoVc;
/** 组合套控制器*/
@property (nonatomic,strong)combinationController *combinVc;
/** lastViewController*/
@property (nonatomic,strong)UIViewController *lastViewConroller;
@end

@implementation courseBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
   [self.view insertSubview:self.subControllerView atIndex:0];
    self.baseInfoBtn.tag = 0;
    [self.baseInfoBtn setTitleColor:projectTitleBtnNormalColor forState:UIControlStateNormal];
    [self.combiBtn setTitleColor:projectTitleBtnNormalColor forState:UIControlStateNormal];
    self.combiBtn.tag = 1;
    //添加自控制器
    [self addSubController];
    
    [self showSubControllerView:self.courseTage];
    [self receiveNotification];
}
-(void)receiveNotification
{
    
    //保存按钮被点击
    [ myNotification addObserver:self selector:@selector(receiveSaveBtnClick:) name:productSaveBtnClick object:nil];
}
#pragma mark 通知事件
#pragma mark 接受到保存按钮点击
-(void)receiveSaveBtnClick:(NSNotification*)info
{

    if ([info.userInfo[@"index"] integerValue] == 2 ) {
        NSLog(@"courseBaseController--%s",__func__);
        [myNotification postNotificationName:baseVCReceiveParentVCReceive object:@"course"  userInfo:info.userInfo];
    }
}
-(UIViewController *)lastViewConroller
{
    if (!_lastViewConroller) {
        _lastViewConroller = [[UIViewController alloc]init];
    }
    return _lastViewConroller;
}
#pragma mark 显示子控制器对应的View
-(void)showSubControllerView:(NSInteger)tag
{
    [self.lastViewConroller.view removeFromSuperview];
    self.lastViewConroller = self.childViewControllers[tag];
    
    if (tag == 0) {
        self.baseInfoVc.baseProjectTemp = self.baseProjectTemp;
        self.baseInfoVc.parmasDict = self.parmasDict;
        self.baseInfoVc.view.frame = self.subControllerView.bounds;
        self.baseInfoVc.baseTage = 2;
        [self.subControllerView addSubview:self.baseInfoVc.view];
        
    }else{
        
        self.combinVc.baseProjectTemp = self.baseProjectTemp;
        self.combinVc.parmasDict = self.parmasDict;
        self.combinVc.view.frame = self.subControllerView.bounds;
        [self.subControllerView addSubview:self.combinVc.view];
       
    }
   
}

#pragma mark 添加自控制器
-(void)addSubController
{
    //基本信息
    self.baseInfoVc = [[baseInfoController alloc]init];
    [self addChildViewController:self.baseInfoVc];
   
    //组合套
    self.combinVc = [[combinationController alloc]init];
    [self addChildViewController:self.combinVc];
}
#pragma mark 基本信息按钮被点击
- (IBAction)baseInfoBtnClick:(UIButton *)sender {
    
    [self showSubControllerView:sender.tag];
    self.baseInfoBtn.selected = YES;
    self.combiBtn.selected = NO;
    CGFloat x = self.baseInfoBtn.center.x;
    self.instructLine.width = sender.titleLabel.width;
    self.instructLine.center = CGPointMake(x, self.instructLine.center.y);
    CATransition *transition = [[CATransition alloc]init];
    transition.type = @"push";
    transition.subtype =  kCATransitionFromRight;
    [self.subControllerView.layer addAnimation:transition forKey:nil];
}
#pragma mark 组合套按钮被点击
- (IBAction)combinationBtn:(UIButton *)sender {
    
    [self showSubControllerView:sender.tag];
    self.baseInfoBtn.selected = NO;
    self.combiBtn.selected = YES;
    CGFloat x = self.combiBtn.center.x;
    self.instructLine.width = sender.titleLabel.width;
    self.instructLine.center = CGPointMake(x, self.instructLine.center.y);
    CATransition *transition = [[CATransition alloc]init];
    transition.type = @"push";
    transition.subtype = kCATransitionFromLeft;
    [self.subControllerView.layer addAnimation:transition forKey:nil];
}

@end
