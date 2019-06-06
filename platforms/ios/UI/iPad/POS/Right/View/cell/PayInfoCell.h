//
//  PayInfoCell.h
//  Boss
//
//  Created by lining on 15/10/28.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayInfoCell : UITableViewCell

+ (instancetype)createCell;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;

@end
