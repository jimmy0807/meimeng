//
//  MemberCardInfoViewController.h
//  Boss
//
//  Created by lining on 16/3/28.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface MemberCardInfoViewController : ICCommonViewController
@property (strong, nonatomic) IBOutlet UIView *topBgView;
@property (strong, nonatomic) IBOutlet UIImageView *picImg;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UILabel *cardProjectCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *pointLabel;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UIButton *operateBtn;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)topBtnPressed:(UIButton *)sender;
- (IBAction)chageBtnPressed:(UIButton *)sender;

@property (strong, nonatomic) CDMemberCard *memberCard;
@end
