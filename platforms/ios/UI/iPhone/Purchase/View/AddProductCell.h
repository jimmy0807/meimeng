//
//  AddProductCell.h
//  Boss
//
//  Created by lining on 15/6/25.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCountView.h"

@protocol AddProductCellDelegate <NSObject>
@optional
-(void)didExpandBtnPressedAtIndexPath:(NSIndexPath *)indexPath;
-(void)didCountChanged;
@end

@interface AddProductCell : UITableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width canExpand:(BOOL)canExpand;

@property(nonatomic, strong) UIImageView *picView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *detailLabel;
@property(nonatomic, strong) UILabel *countLabel;
@property(nonatomic, strong) UILabel *priceLabel;
@property(nonatomic, strong) NSIndexPath *indexPath;
@property(nonatomic, strong) ProductCountView *countView;
@property(nonatomic, assign) id<AddProductCellDelegate>delegate;

@property(nonatomic, assign) BOOL isExpand;
@property(nonatomic, strong) CDPurchaseOrderLine *orderLine;


+(CGFloat)heightWithExpand:(BOOL)isExpand;
@end
