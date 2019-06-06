//
//  LeftTopCell.h
//  Boss
//
//  Created by lining on 15/10/15.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface POSLeftTopCell : UITableViewCell

+ (instancetype)createCell;

@property (strong, nonatomic) CDPosOperate *operate;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *customerLabel;
@property (strong, nonatomic) IBOutlet UILabel *operatorLabel;


@end
