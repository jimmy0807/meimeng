//
//  MemberCardMergeViewController.h
//  Boss
//  并卡
//  Created by lining on 16/4/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface MemberCardMergeViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) CDMemberCard *card;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topMarginToTipViewConstraint;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (strong, nonatomic) IBOutlet UIButton *sureBtn;

- (IBAction)hideTipButtonPressed:(id)sender;
@end
