//
//  PadRestaurantFloorCell.h
//  Boss
//
//  Created by XiaXianBing on 2016-2-24.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPadRestaurantFloorCellWidth    89.0
#define kPadRestaurantFloorCellHeight   75.0

@protocol PadRestaurantFloorCellDelegate <NSObject>
- (void)didFloorNameChanged:(NSString*)name;
@end

@interface PadRestaurantFloorCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *leftLine;
@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) UITextField *titleLabel;

@property(nonatomic, weak)id<PadRestaurantFloorCellDelegate> delegate;

@end
