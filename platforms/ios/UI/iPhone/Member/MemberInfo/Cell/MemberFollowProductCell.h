//
//  MemberFollowProductCell.h
//  Boss
//
//  Created by lining on 16/5/13.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberBaseCell.h"
@interface MemberFollowProductCell : UITableViewCell

+ (instancetype)createCell;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *otherLabel;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;

@end
