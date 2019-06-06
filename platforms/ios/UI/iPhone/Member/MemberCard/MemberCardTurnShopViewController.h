//
//  MemberCardTurnShopViewController.h
//  Boss
//  转店
//  Created by lining on 16/4/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface MemberCardTurnShopViewController : ICCommonViewController
@property (strong, nonatomic) CDMemberCard *card;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *noLabel;
@property (strong, nonatomic) IBOutlet UILabel *oldStoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *memberStoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *storeLabel;
@property (strong, nonatomic) IBOutlet UITextField *markTextField;
@property (strong, nonatomic) IBOutlet UIButton *sureBtn;

- (IBAction)changeShopBtnPressed:(UIButton *)sender;
- (IBAction)sureBtnPressed:(id)sender;

@end
