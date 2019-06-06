//
//  PanDianLineCell.h
//  Boss
//
//  Created by lining on 15/9/14.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PanDianLineCellDelegate <NSObject>

- (void) textFieldDidEndEdit:(NSString *)text atIndexPath:(NSIndexPath *)indexPath;

@end


@interface PanDianLineCell : UITableViewCell<UITextFieldDelegate>
@property(nonatomic, strong) UIImageView *picView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *defaultCountLabel;
@property(nonatomic, strong) UITextField *countField;
@property(nonatomic, strong) UIImageView *lineImgView;
@property(nonatomic, strong) NSIndexPath *indexPath;
@property(nonatomic, assign) id<PanDianLineCellDelegate>delegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width hasImgView:(BOOL)hasImgView;
@end
