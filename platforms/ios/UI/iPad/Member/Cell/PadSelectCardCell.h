//
//  PadSelectCardCell.h
//  Boss
//
//  Created by XiaXianBing on 15/10/21.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPadSelectCardCellWidth       300.0
#define kPadSelectCardCellHeight      66.0

@protocol PadSelectCardCellDelegate <NSObject>
- (void)didCardQrCodePressedAtIndexPath:(NSIndexPath*)path;
@end

@interface PadSelectCardCell : UITableViewCell

@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *stateImageView;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UIButton *qrButton;
@property (nonatomic, weak) NSIndexPath *indexPath;

@property(nonatomic, weak)id<PadSelectCardCellDelegate> delegate;

- (void)isSelectImageViewSelected:(BOOL)isSelect;

@end
