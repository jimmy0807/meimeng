//
//  MemberPayViewController.h
//  Boss
//
//  Created by mac on 15/8/5.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@protocol MemberPayViewControllerDelegate <NSObject>
@optional
-(void)didChoosedPayModeWithAmount:(NSNumber *)amount payModes:(NSArray *)payModes;

@end

@interface MemberPayViewController : ICCommonViewController
@property(nonatomic,weak)id<MemberPayViewControllerDelegate>delegate;
@property(nonatomic,strong)NSArray *MemberPays;
@property(nonatomic,assign)double totalMoney;
@end
