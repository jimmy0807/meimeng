//
//  PadArrearsCell.h
//  Boss
//
//  Created by XiaXianBing on 2016-4-20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPadArrearsCellWidth        424.0
#define kPadArrearsCellHeight       72.0

@class PadArrearsCell;
@protocol PadArrearsCellDelegate <NSObject>
- (void)didPadArrearsSelected:(PadArrearsCell *)cell;
@end

@interface PadArrearsCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *operateLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, assign) id<PadArrearsCellDelegate> delegate;

- (void)isArrearsSelected:(BOOL)isSelect;

@end
