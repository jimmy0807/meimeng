//
//  PadMemberInfoViewController.h
//  Boss
//
//  Created by XiaXianBing on 2016-4-7.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadMemberInfoView.h"
@interface PadMemberInfoViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) CDMember *member;
@property (nonatomic, strong) CDMemberCard *memberCard;
@property (nonatomic, strong) CDCouponCard *couponCard;
@property (nonatomic, weak) UIViewController *parentVC;
@property (nonatomic, strong)PadMemberInfoView *padMemberInfoView;
- (void)reloadData;
- (void)clearMember;


@end

