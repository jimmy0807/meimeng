//
//  AddProductCell.m
//  Boss
//
//  Created by lining on 15/6/25.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "AddProductCell.h"


#define kCellHeight         60
#define kExpandHeight       60
#define kMarginSize         12
#define kPicWidth           48
#define kPicHeight          36

@interface AddProductCell ()<ProductCountViewDelegate>
@property(nonatomic, strong) UIView *expandView;
@property(nonatomic, strong) UIImageView *lineImgView;
//@property(nonatomic, strong) UIImageView *arrowImageView;
@end

@implementation AddProductCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width canExpand:(BOOL)canExpand
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"project_item_cell_n"]];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"project_item_cell_h"]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat xCoord = kMarginSize;
    
        self.picView = [[UIImageView alloc] initWithFrame:CGRectMake(xCoord, (kCellHeight - kPicHeight)/2.0, kPicWidth, kPicHeight)];
        self.picView.image = [UIImage imageNamed:@"project_item_default_48_36.png"];
//        self.picView.layer.masksToBounds = YES;
//        self.picView.layer.cornerRadius = kPicSize/2.0;
        [self.contentView addSubview:self.picView];
        
        
        xCoord += kPicWidth + kMarginSize;
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(xCoord, kCellHeight/2.0 - 20.0 + 2.0, 150, 20.0)];
        self.nameLabel.highlighted = NO;
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [UIFont systemFontOfSize:14.0];
        self.nameLabel.textColor = COLOR(36.0, 36.0, 36.0, 1.0);
        [self.contentView addSubview:self.nameLabel];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(xCoord, kCellHeight/2.0 + 2.0, self.nameLabel.frame.size.width, 20.0)];
        self.detailLabel.highlighted = NO;
        self.detailLabel.backgroundColor = [UIColor clearColor];
        self.detailLabel.font = [UIFont systemFontOfSize:12.0];
        self.detailLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
        [self.contentView addSubview:self.detailLabel];
        
        xCoord += self.nameLabel.frame.size.width;
        
        self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(xCoord, (kCellHeight-20)/2.0, 30, 20.0)];
        self.countLabel.highlighted = NO;
        self.countLabel.textAlignment = NSTextAlignmentCenter;
        self.countLabel.backgroundColor = [UIColor clearColor];
        self.countLabel.font = [UIFont systemFontOfSize:13.0];
        self.countLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
//        [self.contentView addSubview:self.countLabel];
        
        
//        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake((width - 20 -52), (kCellHeight-20)/2.0 + 1, 52, 20.0)];
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(xCoord, (kCellHeight-20)/2.0 + 1, (width - xCoord  - 20), 20)];
        self.priceLabel.highlighted = NO;
        self.priceLabel.textAlignment = NSTextAlignmentRight;
        self.priceLabel.backgroundColor = [UIColor clearColor];
        self.priceLabel.font = [UIFont systemFontOfSize:13.0];
        self.priceLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
        [self.contentView addSubview:self.priceLabel];
        
        if (canExpand) {
            
            UIButton *expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            expandBtn.frame = CGRectMake(0, 0, width, kCellHeight);
            [expandBtn addTarget:self action:@selector(expandBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//            [self.contentView addSubview:expandBtn];
            
            self.expandView = [[UIView alloc] initWithFrame:CGRectMake(0, kCellHeight, width, kExpandHeight)];
            self.expandView.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:self.expandView];
            
            self.countView = [[ProductCountView alloc] initWithPoint:CGPointMake(width - 3*36-kMarginSize, (kExpandHeight - 27)/2.0) count:[self.orderLine.count integerValue]];
            self.countView.delegate = self;
            [self.expandView addSubview:self.countView];
        }
        
        self.lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kCellHeight -  0.5, width, 0.5)];
        self.lineImgView.backgroundColor = [UIColor clearColor];
        self.lineImgView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
        [self.contentView addSubview:self.lineImgView];
    }
    return self;
}

-(void)setIsExpand:(BOOL)isExpand
{
    _isExpand = isExpand;
    if (_isExpand) {
        self.expandView.hidden = false;
//        self.arrowImageView.highlighted = true;
        self.lineImgView.frame = CGRectMake(0.0, kCellHeight + kExpandHeight - 0.5, IC_SCREEN_WIDTH, 0.5);
        
    }
    else
    {
//        self.arrowImageView.highlighted = false;
        self.expandView.hidden = true;
        self.lineImgView.frame = CGRectMake(0.0, kCellHeight - 0.5, IC_SCREEN_WIDTH, 0.5);
    }
}

- (void)setOrderLine:(CDPurchaseOrderLine *)orderLine
{
    _orderLine = orderLine;
    self.countView.count = [orderLine.count integerValue];
}

- (void)expandBtnPressed:(UIButton *)btn
{
    NSLog(@"expang btn pressed");
    //    self.isExpand = !self.isExpand;
    if ([self.delegate respondsToSelector:@selector(didExpandBtnPressedAtIndexPath:)]) {
        [self.delegate didExpandBtnPressedAtIndexPath:self.indexPath];
    }
}
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"touches Began");
//}
//
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"touchMoved");
//}

#pragma mark - 
-(void)countChanged:(ProductCountView *)countView
{
    self.orderLine.count = [NSNumber numberWithInt:countView.count];
    self.orderLine.totalMoney = [NSNumber numberWithFloat:countView.count * [self.orderLine.price integerValue]];
    self.countLabel.text = [NSString stringWithFormat:@"x%@",self.orderLine.count];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",self.orderLine.totalMoney];
    
    if ([self.delegate respondsToSelector:@selector(didCountChanged)]) {
        [self.delegate didCountChanged];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (CGFloat)heightWithExpand:(BOOL)isExpand
{
    if (isExpand) {
        return kCellHeight + kExpandHeight;
    }
    else
    {
        return kCellHeight;
    }
}
@end
