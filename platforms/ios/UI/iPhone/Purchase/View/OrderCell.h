//
//  OrderCell.h
//  Boss
//
//  Created by lining on 15/7/15.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum OrderCellType
{
    CellType_approved,
    CellType_confirmed
}OrderCellType;

@interface OrderCell : UITableViewCell
@property(nonatomic, assign) OrderCellType type;

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *detailLabel;
@property(nonatomic, strong) UILabel *amountLabel;
@property(nonatomic, strong) UILabel *rateLabel;
@property(nonatomic, strong) UIImageView *arrowImageView;

- (id)initWithWidth:(CGFloat)width type:(OrderCellType)type reuseIdentifier:(NSString *)reuseIdentifier;

+ (CGFloat)cellHeight:(OrderCellType)type;

@end
