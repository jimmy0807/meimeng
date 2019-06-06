//
//  PackageServiceController.m
//  Boss
//
//  Created by jiangfei on 16/7/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PackageServiceController.h"
#import "baseInfoController.h"
#import "CombiPackageController.h"
#import "UIView+Frame.h"
@interface PackageServiceController ()
@property (weak, nonatomic) IBOutlet UIView *subControllerView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
/** 上一次显示的ViewController*/
@property (weak, nonatomic) IBOutlet UIButton *baseInfoBtn;
@property (weak, nonatomic) IBOutlet UIButton *combiBtn;
@property (nonatomic,strong)UIViewController *lastViewController;
/** baseVc*/
@property (nonatomic,strong)baseInfoController *baseVc;
/** combi*/
@property (nonatomic,strong)CombiPackageController *combiPackgeVc;
@end

@implementation PackageServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VCBackgrodColor;
    [self.baseInfoBtn setTitleColor:projectTitleBtnNormalColor forState:UIControlStateNormal];
    [self.baseInfoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.combiBtn setTitleColor:projectTitleBtnNormalColor forState:UIControlStateNormal];
    [self.combiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.view insertSubview:self.subControllerView atIndex:0];
    //添加子控制器
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
    
    if ([info.userInfo[@"index"] integerValue] == 3 ) {
        [myNotification postNotificationName:baseVCReceiveParentVCReceive object:@"course"  userInfo:info.userInfo];
    }
}
#pragma mark 显示子控制器对应的View
-(void)showSubControllerView:(NSInteger)tag
{
    [self.lastViewController.view removeFromSuperview];
    self.lastViewController = self.childViewControllers[tag];
    if (tag == 0) {
        self.baseVc.baseProjectTemp = self.baseProjectTemp;
        self.baseVc.parmasDict = self.parmasDict;
        self.baseVc.view.frame = self.subControllerView.bounds;
        self.baseVc.baseTage = 3;
        [self.subControllerView addSubview:self.baseVc.view];
        
    }else{
        
        self.combiPackgeVc.baseProjectTemp = self.baseProjectTemp;
        self.combiPackgeVc.parmasDict = self.parmasDict;
        self.combiPackgeVc.view.frame = self.subControllerView.bounds;
        [self.subControllerView addSubview:self.combiPackgeVc.view];
        
    }
   
}

#pragma mark 添加子控制器
-(void)addSubController
{
    //消息控制器
    self.baseVc = [[baseInfoController alloc]init];
    [self addChildViewController:self.baseVc];
    //组合套控制器
    self.combiPackgeVc = [[CombiPackageController alloc]init];
    [self addChildViewController:self.combiPackgeVc];
}

- (IBAction)baseinfoBtnClick:(UIButton *)sender {
    self.baseInfoBtn.selected = !self.baseInfoBtn.selected;
    self.combiBtn.selected = NO;
    self.lineView.x = self.baseInfoBtn.centerX;
    self.lineView.size = CGSizeMake(self.baseInfoBtn.titleLabel.width, self.lineView.height);
    self.lineView.center = CGPointMake(self.lineView.x, self.lineView.centerY);
    [self showSubControllerView:0];
    CATransition *transition = [[CATransition alloc]init];
    transition.type = @"push";
    transition.subtype = kCATransitionFromRight;
    [self.subControllerView.layer addAnimation:transition forKey:nil];
}
- (IBAction)combinBtnClick:(UIButton *)sender {
    self.combiBtn.selected = !self.combiBtn.selected;
    self.baseInfoBtn.selected = NO;
    self.lineView.x = self.combiBtn.centerX;
    self.lineView.size = CGSizeMake(self.combiBtn.titleLabel.width, self.lineView.height);
    self.lineView.center = CGPointMake(self.lineView.x, self.lineView.centerY);
    [self showSubControllerView:1];
    CATransition *transition = [[CATransition alloc]init];
    transition.type = @"push";
    transition.subtype = kCATransitionFromLeft;
    [self.subControllerView.layer addAnimation:transition forKey:nil];
}

@end
