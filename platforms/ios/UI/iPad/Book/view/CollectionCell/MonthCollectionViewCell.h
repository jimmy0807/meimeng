//
//  MonthCollectionViewCell.h
//  Boss
//
//  Created by lining on 15/12/18.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCell_Width  145
#define kCell_Height 110
@interface MonthCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *bgView;
@property (strong, nonatomic) UILabel *dayLabel;
@property (strong, nonatomic) UIImageView *dayBg;
@property (strong, nonatomic) UIImageView *countBg;
@property (strong, nonatomic) UILabel *countLabel;
@property (strong, nonatomic) UILabel *monthLabel;

@property(nonatomic, strong) NSString *dateString;

@end
