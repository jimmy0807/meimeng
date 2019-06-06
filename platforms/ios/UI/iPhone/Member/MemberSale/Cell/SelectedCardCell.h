//
//  SelectedCardCell.h
//  Boss
//
//  Created by lining on 16/6/23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedCardCell : UITableViewCell

+ (instancetype)createCell;
@property (strong, nonatomic) IBOutlet UIImageView *circleImgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UIView *stateView;
@property (strong, nonatomic) IBOutlet UILabel *stateLabel;
@property (strong, nonatomic) IBOutlet UILabel *arrearLabel;


@end
