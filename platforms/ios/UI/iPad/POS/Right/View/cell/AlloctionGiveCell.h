//
//  AlloctionGiveCell.h
//  Boss
//
//  Created by lining on 15/10/22.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlloctionGiveCell : UITableViewCell

+ (instancetype)createCell;
@property (assign, nonatomic) BOOL isSelected;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;

@end
