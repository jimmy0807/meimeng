//
//  AttributeCell.h
//  Boss
//
//  Created by XiaXianBing on 15/9/2.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AttributeCell;
@protocol AttributeCellDelegate <NSObject>

- (void)didDeleteAttributeLine:(AttributeCell *)cell;
- (void)didAddAttributeValue:(AttributeCell *)cell;

@end

@interface AttributeCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) id<AttributeCellDelegate> delegate;

@end
