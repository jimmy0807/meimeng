//
//  MemberCardPointReedemViewController.h
//  Boss
//
//  Created by lining on 16/6/21.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface MemberCardPointReedemViewController : ICCommonViewController
@property (nonatomic, strong) CDMemberCard *card;
@property (strong, nonatomic) IBOutlet UILabel *cardNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *cardTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *pointLabel;
@property (strong, nonatomic) IBOutlet UILabel *productNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *pointTextField;
@property (strong, nonatomic) IBOutlet UITextField *markTextField;
@property (strong, nonatomic) IBOutlet UIButton *sureBtn;
- (IBAction)sureBtnPressed:(id)sender;
- (IBAction)selectedProductBtnPressed:(id)sender;
@end
