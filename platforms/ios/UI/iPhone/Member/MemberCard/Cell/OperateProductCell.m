//
//  OperateProductCell.m
//  Boss
//
//  Created by lining on 16/5/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "OperateProductCell.h"

@implementation OperateProductCell

+ (instancetype)createCell
{
    return [self loadFromNib];
}

- (void)setPosProduct:(CDPosBaseProduct *)posProduct
{
    _posProduct = posProduct;
    self.nameLabel.text = posProduct.product_name;
    
    self.countLabel.text = [NSString stringWithFormat:@"x %d",[posProduct.product_qty integerValue]];
     self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[posProduct.money_total floatValue]];
    
    if ([posProduct isKindOfClass:[CDPosConsumeProduct class]]) {
        NSLog(@"卡扣产品");
        CDPosConsumeProduct *consumeProduct = (CDPosConsumeProduct *)posProduct;
        self.nameLabel.text = [NSString stringWithFormat:@"%@(卡扣）",consumeProduct.product_name];
        
       
    }
//    posProduct.product
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:posProduct.product.imageSmallUrl] placeholderImage:[UIImage imageNamed:@"user_default"]];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
