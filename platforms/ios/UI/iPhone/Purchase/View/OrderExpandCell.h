//
//  OrderExpandCell.h
//  Boss
//
//  Created by lining on 15/6/18.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderExpandCellDelegate <NSObject>
@optional
-(void)didExpandBtnPressedAtIndexPath:(NSIndexPath *)indexPath;

-(void)didEditBtnPressedAtIndexPath:(NSIndexPath *)indexPath;
-(void)didDelBtnPressedAtIndexPath:(NSIndexPath *)indexPath;
-(void)didCommitBtnPressedAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface OrderExpandCell : UITableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width canExpand:(BOOL)canExpand;

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) UILabel *amountLabel;
@property(nonatomic, strong) NSIndexPath *indexPath;
@property(nonatomic, assign) BOOL isExpand;
@property(nonatomic, strong) UILabel *providerLabel;

@property(nonatomic, assign) id<OrderExpandCellDelegate> delegate;


@end
