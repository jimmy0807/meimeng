//
//  MemberInfoViewController.h
//  Boss
//
//  Created by lining on 16/3/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "MemberInfoDetailViewController.h"

@interface MemberInfoViewController : ICCommonViewController<UIScrollViewDelegate>

@property (strong, nonatomic) CDMember *member;
@property (assign, nonatomic) MemberInfoType type;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *infoTableView;
@property (strong, nonatomic) IBOutlet UITableView *teZhengTableView;
@property (strong, nonatomic) IBOutlet UITableView *qinyouTableView;
@property (strong, nonatomic) IBOutlet UIImageView *lineImgView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineLayoutConstraint;

@property (strong, nonatomic) IBOutlet UIButton *saveBtn;

- (IBAction)didTopBtnPressed:(UIButton *)sender;
- (IBAction)didBottomBtnPressed:(UIButton *)sender;


@end
