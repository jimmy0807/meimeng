//
//  OrderExpandCell.m
//  Boss
//
//  Created by lining on 15/6/18.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "OrderExpandCell.h"

#define kCellHeight         80
#define kExpandHeight       60
#define kMarginSize         20
#define kLabelHeight        20

#define kBtnCount           3

@interface OrderExpandCell ()
@property(nonatomic, strong) UIView *expandView;
@property(nonatomic, strong) UIImageView *arrowImageView;
@property(nonatomic, strong) UIImageView *lineImgView;
@end

@implementation OrderExpandCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width canExpand:(BOOL)canExpand
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        self.backgroundColor = [UIColor clearColor];
        
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"project_item_cell_n"]];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"project_item_cell_h"]];
        
        UIImage *arrowImage = nil;
        if (canExpand) {
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            arrowImage = [UIImage imageNamed:@"purchase_down.png"];
        }
        else
        {
            arrowImage = [UIImage imageNamed:@"project_item_arrow.png"];
        }
        
        CGFloat yCoord = 10;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginSize, yCoord, width - 15 - arrowImage.size.width, 20.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:16.0];
        self.titleLabel.tag = 101;
        self.titleLabel.textColor = COLOR(36.0, 36.0, 36.0, 1.0);
        [self.contentView addSubview:self.titleLabel];
        
        
        yCoord += kLabelHeight + 2;
        self.providerLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginSize, yCoord,self.titleLabel.frame.size.width, 20.0)];
        self.providerLabel.backgroundColor = [UIColor clearColor];
        self.providerLabel.font = [UIFont systemFontOfSize:14.0];
        self.providerLabel.tag = 102;
        self.providerLabel.textColor = COLOR(160.0, 160.0, 160.0, 1.0);
        [self.contentView addSubview:self.providerLabel];
        
         yCoord += kLabelHeight + 2;
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginSize, yCoord, 150, 20.0)];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.font = [UIFont systemFontOfSize:13.0];
        self.dateLabel.tag = 102;
        self.dateLabel.textColor = COLOR(160.0, 160.0, 160.0, 1.0);
        [self.contentView addSubview:self.dateLabel];
        
        
        self.amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.dateLabel.frame.origin.x + self.dateLabel.frame.size.width + kMarginSize, yCoord, 120, 20.0)];
        self.amountLabel.backgroundColor = [UIColor clearColor];
        self.amountLabel.font = [UIFont systemFontOfSize:13.0];
        self.amountLabel.tag = 103;
//        self.amountLabel.textAlignment = NSTextAlignmentRight;
        self.amountLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:self.amountLabel];
        
        
       
        
        self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width - 15 - arrowImage.size.width, (kCellHeight - arrowImage.size.height)/2.0, arrowImage.size.width, arrowImage.size.height)];
        self.arrowImageView.backgroundColor = [UIColor clearColor];
        self.arrowImageView.image = arrowImage;
        self.arrowImageView.tag = 105;
      
        [self.contentView addSubview:self.arrowImageView];
        
        
        
        
        self.lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kCellHeight - 0.5, IC_SCREEN_WIDTH, 0.5)];
        self.lineImgView.backgroundColor = [UIColor clearColor];
        self.lineImgView.tag = 106;
        self.lineImgView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
        
        
        if (canExpand) {
            self.arrowImageView.highlightedImage = [UIImage imageNamed:@"purchase_up.png"];
            
            UIButton *expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            expandBtn.frame = CGRectMake(0, 0, width, kCellHeight);
            [expandBtn addTarget:self action:@selector(expandBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            
//            expandBtn.backgroundColor = [UIColor redColor];
            [self.contentView addSubview:expandBtn];

            
            self.expandView = [self expandView:width];
            [self.contentView addSubview:self.expandView];
            
        }
        
        [self.contentView addSubview:self.lineImgView];
    }
    return self;
}

- (UIView *)expandView:(CGFloat)width
{
    self.expandView = [[UIView alloc] initWithFrame:CGRectMake(0, kCellHeight, width, kExpandHeight)];
    self.expandView.backgroundColor = COLOR(245, 245, 245, 1);
    UIImage *img = [UIImage imageNamed:@"order_btn_01_n.png"];
    CGFloat xCoord = (width - kBtnCount * img.size.width)/4;
    CGFloat yCoord = (kExpandHeight - img.size.height)/2.0;
    for (int i = 0; i < kBtnCount; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *noraml_name = [NSString stringWithFormat:@"order_btn_%02d_n.png",i+1];
        NSString *highlight_name = [NSString stringWithFormat:@"order_btn_%02d_h.png",i+1];
        CGFloat x = xCoord*(i+1) + img.size.width*i;
        button.frame = CGRectMake(x, yCoord, img.size.width, img.size.height);
        [button setBackgroundImage:[UIImage imageNamed:noraml_name] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:highlight_name] forState:UIControlStateHighlighted];
        button.tag = 101+i;
        [button addTarget:self action:@selector(didBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.expandView addSubview:button];
    }
    
    return self.expandView;
}

- (void)expandBtnPressed:(UIButton *)btn
{
//    self.isExpand = !self.isExpand;
    if ([self.delegate respondsToSelector:@selector(didExpandBtnPressedAtIndexPath:)]) {
        [self.delegate didExpandBtnPressedAtIndexPath:self.indexPath];
    }
}

-(void)setIsExpand:(BOOL)isExpand
{
    
    _isExpand = isExpand;
    if (_isExpand) {
        self.expandView.hidden = false;
        self.arrowImageView.highlighted = true;
        self.lineImgView.frame = CGRectMake(0.0, kCellHeight + kExpandHeight - 0.5, IC_SCREEN_WIDTH, 0.5);

    }
    else
    {
        self.arrowImageView.highlighted = false;
        self.expandView.hidden = true;
        self.lineImgView.frame = CGRectMake(0.0, kCellHeight - 0.5, IC_SCREEN_WIDTH, 0.5);
    }
}

-(void)didBtnPressed:(UIButton *)btn
{
    if (btn.tag == 101) {
        NSLog(@"编辑: %d",self.indexPath.row);
        if ([self.delegate respondsToSelector:@selector(didEditBtnPressedAtIndexPath:)]) {
            [self.delegate didEditBtnPressedAtIndexPath:self.indexPath];
        }
    }
    else if (btn.tag == 102)
    {
        NSLog(@"提交: %d",self.indexPath.row);
        if ([self.delegate respondsToSelector:@selector(didCommitBtnPressedAtIndexPath:)]) {
            [self.delegate didCommitBtnPressedAtIndexPath:self.indexPath];
        }
    }
    else if (btn.tag == 103)
    {
        NSLog(@"删除: %d",self.indexPath.row);
        if ([self.delegate respondsToSelector:@selector(didDelBtnPressedAtIndexPath:)]) {
            [self.delegate didDelBtnPressedAtIndexPath:self.indexPath];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
