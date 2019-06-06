//
//  AttributeValueCell.h
//  Boss
//
//  Created by XiaXianBing on 15/9/2.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AttributeValueCell;
@protocol AttributeValueCellDelegate <NSObject>

- (void)didContentFieldEndEdit:(AttributeValueCell *)cell;

@end

@interface AttributeValueCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *frameImageView;
@property (nonatomic, strong) UITextField *contentField;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) id<AttributeValueCellDelegate> delegate;

- (void)setTitleLabelText:(NSString *)title;

@end
