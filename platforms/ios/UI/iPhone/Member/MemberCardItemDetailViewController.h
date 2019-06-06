//
//  MemberCardItemDetailViewController.h
//  Boss
//
//  Created by mac on 15/7/31.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@protocol MemberCardItemDetailViewControllerDelegate <NSObject>
@optional
-(void)didSetProjectInfo:(BOOL)isNeedManagerCode;
@end

@interface MemberCardItemDetailViewController : ICCommonViewController
@property(nonatomic,strong)CDMemberCardProject *project;
@property(nonatomic,weak)id<MemberCardItemDetailViewControllerDelegate>delegate;
@property(nonatomic,assign)BOOL isNeedManagerCode;

@end
