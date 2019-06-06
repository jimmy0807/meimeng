//
//  OperateProductCell.m
//  Boss
//
//  Created by lining on 16/8/30.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PosOperateProductCell.h"

@implementation PosOperateProductCell

+ (instancetype)createCell
{
    return [self loadFromNib];
}

- (void)setPosProduct:(CDPosBaseProduct *)posProduct
{
    _posProduct = posProduct;
    self.nameLabel.text = posProduct.product_name;
    self.countLabel.text = [NSString stringWithFormat:@"x %d",[posProduct.product_qty integerValue]];
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[posProduct.money_total floatValue]];
    self.priceLabel.text = [NSString stringWithFormat:@"单价：￥%.2f",[posProduct.buy_price floatValue]];
    self.discountLabel.text = [NSString stringWithFormat:@"折扣: %@",posProduct.product_discount];
    
    CDBornCategory *bornCategory = [[BSCoreDataManager currentManager] findEntity:@"CDBornCategory" withValue:posProduct.product.bornCategory forKey:@"code"];
    NSString *type = bornCategory.bornCategoryName;

    self.typeLabel.text = [NSString stringWithFormat:@"类型：%@",type];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
