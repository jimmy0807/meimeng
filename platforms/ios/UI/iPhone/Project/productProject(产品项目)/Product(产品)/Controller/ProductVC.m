//
//  ProductVC.m
//  Boss
//
//  Created by jiangfei on 16/7/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ProductVC.h"
#import "baseInfoController.h"
@interface ProductVC ()
/** baseinfo*/
@property (nonatomic,strong)baseInfoController *baseInfo;
@end

@implementation ProductVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VCBackgrodColor;
    self.baseInfo = [[baseInfoController alloc]init];
    self.baseInfo.baseProjectTemp = self.baseProjectTemp;
    self.parmasDict = self.parmasDict;
    [self addChildViewController:self.baseInfo];
    self.baseInfo.view.frame = self.view.bounds;
    self.baseInfo.baseTage = 0;
    [self.view addSubview:self.baseInfo.view];
    [myNotification addObserver:self selector:@selector(receiveSaveBtnClick:) name:productSaveBtnClick object:nil];
}

-(void)receiveSaveBtnClick:(NSNotification*)infoe
{
    
    if ([infoe.userInfo[@"index"] integerValue] == 0) {
       
        [myNotification postNotificationName:baseVCReceiveParentVCReceive object:nil userInfo:infoe.userInfo];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
