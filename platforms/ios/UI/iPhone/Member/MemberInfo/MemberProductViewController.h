//
//  MemberProductViewController.h
//  Boss
//
//  Created by lining on 16/5/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"


@interface MemberProductViewController : ICCommonViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *productBtn;
@property (strong, nonatomic) IBOutlet UIButton *dateBtn;
@property (strong, nonatomic) IBOutlet UIButton *priceBtn;
@property (strong, nonatomic) IBOutlet UIImageView *priceImgView;

@property (strong, nonatomic) CDMember *member;

- (IBAction)topBtnPressed:(id)sender;

@end
