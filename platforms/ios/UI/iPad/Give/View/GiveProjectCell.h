//
//  GiveProjectCell.h
//  Boss
//
//  Created by lining on 15/10/30.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiveProjectCell : UITableViewCell
@property (assign, nonatomic) BOOL isSelected;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;

+ (instancetype)createCell;

@end
