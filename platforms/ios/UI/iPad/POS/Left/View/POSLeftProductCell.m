//
//  LeftDetailCell.m
//  Boss
//
//  Created by lining on 15/10/15.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "POSLeftProductCell.h"

@implementation POSLeftProductCell

+ (instancetype)createCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"POSLeftProductCell" owner:self options:nil] objectAtIndex:0];
}

- (void)setPosProduct:(CDPosBaseProduct *)posProduct
{
    _posProduct = posProduct;
    self.nameLabel.text = posProduct.product_name;
    self.countLabel.text = [NSString stringWithFormat:@"x %d",[posProduct.product_qty integerValue]];
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[posProduct.money_total floatValue]];
    self.priceLabel.text = [NSString stringWithFormat:@"单价：￥%.2f",[posProduct.product_price floatValue]];
    self.discountLabel.text = [NSString stringWithFormat:@"折扣: %@",posProduct.product_discount];
#if 0
    NSInteger category = [posProduct.product.bornCategory integerValue];
    NSString *type;
    if ( category == kPadBornCategoryProduct )
    {
        type = @"产品";
    }
    else if ( category == kPadBornCategoryProject )
    {
        type = @"项目";
    }
    else if ( category == kPadBornCategoryCourses )
    {
        type = @"疗程";
    }
    else if ( category == kPadBornCategoryPackage )
    {
        type = @"套餐";
    }
    else if ( category == kPadBornCategoryPackageKit )
    {
        type = @"套盒";
    }
#else
    CDBornCategory *bornCategory = [[BSCoreDataManager currentManager] findEntity:@"CDBornCategory" withValue:posProduct.product.bornCategory forKey:@"code"];
    NSString *type = bornCategory.bornCategoryName;
#endif
    self.typeLabel.text = [NSString stringWithFormat:@"类型：%@",type];
}

//- (void)setConsumeProduct:(CDPosConsumeProduct *)consumeProduct
//{
//    _consumeProduct = consumeProduct;
//    self.nameLabel.text = consumeProduct.product_name;
//    self.countLabel.text = [NSString stringWithFormat:@"x %d",[consumeProduct.consume_qty integerValue]];
//    self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[consumeProduct.pay_amount floatValue]];
//    self.priceLabel.text = [NSString stringWithFormat:@"单价：￥%.2f",[consumeProduct.price floatValue]];
//    self.discountLabel.text = [NSString stringWithFormat:@"折扣: %@",consumeProduct.discount];
//    self.typeLabel.text = [NSString stringWithFormat:@"类型：%@",@"项目"];
//    
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
