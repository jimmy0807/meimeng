//
//  MemberCardRecedeViewController.h
//  Boss
//  退卡
//  Created by lining on 16/4/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface MemberCardRecedeViewController : ICCommonViewController
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *noLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UIImageView *checkBoxImg;
@property (strong, nonatomic) IBOutlet UITextField *amountField;
@property (strong, nonatomic) IBOutlet UIButton *sureBtn;

- (IBAction)checkBoxBtnPressed:(id)sender;
- (IBAction)sureBtnPressed:(id)sender;


@property (nonatomic, strong) CDMemberCard *card;
@end
