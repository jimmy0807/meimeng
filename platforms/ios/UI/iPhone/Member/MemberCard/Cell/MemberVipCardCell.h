//
//  MemberVipCardCell.h
//  Boss
//
//  Created by lining on 16/5/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberVipCardCell : UITableViewCell

+ (instancetype) createCell;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *cardNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *shopLabel;


@end
