//
//  MemberCardOrTicketViewController.h
//  Boss
//
//  Created by lining on 16/3/23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface MemberCardOrCouponViewController : ICCommonViewController

@property (nonatomic, strong) CDMember *member;

@property (strong, nonatomic) IBOutlet UIView *topBgView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *SecondLayoutConstraint;
@property (strong, nonatomic) IBOutlet UIScrollView *scollView;


@property (strong, nonatomic) IBOutlet UIView *noCardView;
@property (strong, nonatomic) IBOutlet UIView *noCouponView;

@property (strong, nonatomic) IBOutlet UILabel *noCardTipLabel;


@property (strong, nonatomic) IBOutlet UITableView *cardTableView;
@property (strong, nonatomic) IBOutlet UITableView *couponTableView;

@property (strong, nonatomic) IBOutlet UIButton *cardBtn;
@property (strong, nonatomic) IBOutlet UIButton *couponBtn;

@property (strong, nonatomic) IBOutlet UIView *cardView;
@property (strong, nonatomic) IBOutlet UIView *couponView;


- (IBAction)memberCardPressed:(id)sender;

- (IBAction)memberCouponPressed:(UIButton *)sender;

- (IBAction)openCardPressed:(id)sender;

@end


@interface CMButton : UIButton

@end
