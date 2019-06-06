//
//  MemberCardActiveViewController.h
//  Boss
//  卡激活
//  Created by lining on 16/4/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface MemberCardActiveViewController : ICCommonViewController
@property (strong, nonatomic) CDMemberCard *card;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *cardNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UITextField *markTextField;
- (IBAction)sureBtnPressed:(id)sender;
@end
