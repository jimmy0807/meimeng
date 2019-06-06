//
//  projectController.m
//  Boss
//
//  Created by jiangfei on 16/6/7.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "projectController.h"
#import "baseInfoController.h"
#import "consumeGoodsController.h"
#import "productTableHeadView.h"
#import "UIView+Frame.h"
@interface projectController ()
@property (weak, nonatomic) IBOutlet UIView *subControllerView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *infoBtn;
@property (weak, nonatomic) IBOutlet UIButton *goodsBtn;
/** 基本信息控制器*/
@property (nonatomic,strong)baseInfoController *infoController;
/** 消耗品控制器*/
@property (nonatomic,strong)consumeGoodsController *goodsController;
/** 上次显示的自控制器*/
@property (nonatomic,strong)UIViewController *lastSubViewController;
@end

@implementation projectController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.infoBtn.tag = 0;
    self.goodsBtn.tag = 1;
    [self.goodsBtn setTitleColor:projectTitleBtnNormalColor forState:UIControlStateNormal];
    [self.infoBtn setTitleColor:projectTitleBtnNormalColor forState:UIControlStateNormal];
    [self.view insertSubview:self.subControllerView atIndex:0];
    [self addSubController];
    //显示
    [self showSubViewControllerWith:self.tage];
    [self receiveNotification];
}
#pragma mark 记录上次显示的View
-(UIViewController *)lastSubViewController
{
    if (!_lastSubViewController) {
        _lastSubViewController = [[UIViewController alloc]init];
    }
    return _lastSubViewController;
}

#pragma mark 显示tage对应的自控制器的view
-(void)showSubViewControllerWith:(NSInteger)tag
{
    [self.lastSubViewController.view removeFromSuperview];
    self.lastSubViewController = self.childViewControllers[tag];
    ProductProjectBaseController *baseController = self.childViewControllers[tag];
    baseController.baseProjectTemp = self.baseProjectTemp;
    baseController.parmasDict = self.parmasDict;
    if (tag == 0) {
        self.infoController.view.frame = self.subControllerView.bounds;
        [self.subControllerView addSubview:self.infoController.view];
        self.infoController.baseTage = 1;
        
    }else{
        self.goodsController.view.frame = self.subControllerView.bounds;
        [self.subControllerView addSubview:self.goodsController.view];
    }
    

    
}
#pragma mark 添加自控制器
-(void)addSubController
{
    //添加基本信息控制器
    self.infoController = [[baseInfoController alloc]init];
    [self addChildViewController:self.infoController];
    //添加消耗品控制器
    self.goodsController = [[consumeGoodsController alloc]init];
    [self addChildViewController:self.goodsController];
}

-(void)receiveNotification
{
    
    [myNotification addObserver:self selector:@selector(requestResult:) name:kBSProjectTemplateCreateResponse object:nil];
    //保存按钮被点击
    [ myNotification addObserver:self selector:@selector(receiveSaveBtnClick:) name:productSaveBtnClick object:nil];
}
#pragma mark 通知事件
#pragma mark 接受到保存按钮点击
-(void)receiveSaveBtnClick:(NSNotification*)info
{
   
    if ([info.userInfo[@"index"] integerValue] == 1) {
         [myNotification postNotificationName:baseVCReceiveParentVCReceive object:nil userInfo:info.userInfo];
    }
}
-(void)dealloc
{
    [myNotification removeObserver:self];
}
-(void)requestResult:(NSNotification*)info
{
    if (info.userInfo) {
        NSLog(@"userInfo-----%@",info.userInfo);
    }
}

- (IBAction)goodsBtnClick:(UIButton *)sender {
    if (self.goodsBtn.selected) {
        return;
    }
    [self showSubViewControllerWith:sender.tag];
    self.goodsBtn.selected = YES;
    self.infoBtn.selected = NO;
    CGFloat centerX = self.goodsBtn.center.x;
    self.lineView.width = sender.titleLabel.width;
    self.lineView.center = CGPointMake(centerX, self.lineView.center.y);
    CATransition *transition = [[CATransition alloc]init];
    transition.type = @"push";
    transition.subtype = kCATransitionFromLeft;
    [self.subControllerView.layer addAnimation:transition forKey:nil];
    
}

- (IBAction)infoBtnClick:(UIButton *)sender {
    if (self.infoBtn.selected) {
        return;
    }
    [self showSubViewControllerWith:sender.tag];
    self.goodsBtn.selected = NO;
    self.infoBtn.selected = YES;
    CGFloat centerX = self.infoBtn.center.x;
    self.lineView.width = sender.titleLabel.width;
    self.lineView.center = CGPointMake(centerX, self.lineView.center.y);
    CATransition *transition = [[CATransition alloc]init];
    transition.type = @"push";
    transition.subtype = kCATransitionFromRight;
    [self.subControllerView.layer addAnimation:transition forKey:nil];
}

@end
