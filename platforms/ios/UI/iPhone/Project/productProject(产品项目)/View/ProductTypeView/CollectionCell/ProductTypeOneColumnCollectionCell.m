//
//  ProductTypeOneColumnCollectionCell.m
//  Boss
//
//  Created by jiangfei on 16/5/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ProductTypeOneColumnCollectionCell.h"
#import "PadProjectCart.h"

@interface ProductTypeOneColumnCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (strong, nonatomic) IBOutlet UILabel *buyTagLabel;

@property (weak, nonatomic) IBOutlet UILabel *leftCount;
@property (weak, nonatomic) IBOutlet UILabel *priceView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;

@end
@implementation ProductTypeOneColumnCollectionCell

- (void)awakeFromNib
{
    
    [super awakeFromNib];
    // Initialization code
    self.titleName.font = projectContentFont;
    self.priceView.font = projectSmallFont;
    self.priceView.textColor = projectTextFieldColor;
    self.leftCount.font = projectSmallFont;
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.selectedLabel.hidden = true;
}

- (void)setObject:(NSManagedObject *)object
{
    self.arrowImage.hidden = true;
    self.leftCount.hidden = false;
    self.buyTagLabel.hidden = true;
    
    if ([object isKindOfClass:[CDProjectTemplate class]])
    {
        self.arrowImage.hidden = false;
        self.leftCount.hidden = true;
        CDProjectTemplate *item = (CDProjectTemplate *)object;
        
        //图片
        [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:item.imageUrl] placeholderImage:[UIImage imageNamed:@"BornCategoryPleceHoledSmallImage"]];
        //价格
        self.priceView.text = [NSString stringWithFormat:@"￥%0.2f",[item.listPrice floatValue]];
        //名称
        self.titleName.text = item.templateName;
//        //数量
//        if ([item.type isEqualToString :@"product"]) {
//            self.leftCount.hidden = NO;
//            if ([item.qty_available integerValue]>0) {
//                self.leftCount.text = [NSString stringWithFormat:@"库存量:%d%@",[item.qty_available integerValue],item.uomName];
//                self.leftCount.textColor = projectTextFieldColor;
//                if ([item.qty_available integerValue] == 0) {
//                    self.leftCount.textColor = [UIColor orangeColor];
//                }
//            }else{
//                self.leftCount.text =@"缺货";
//                self.leftCount.textColor = [UIColor orangeColor];
//            }
//            
//            
//        }else{
//            self.leftCount.hidden = YES;
//        }
        
        
    }
    else if ([object isKindOfClass:[CDProjectItem class]]) {
        CDProjectItem *item = (CDProjectItem *)object;
        //名称
        self.titleName.text = item.itemName;
        
        //价格
        self.priceView.text = [NSString stringWithFormat:@"￥%0.2f",[item.totalPrice floatValue]];
        
        //图片
        [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:item.imageUrl] placeholderImage:[UIImage imageNamed:@"BornCategoryPleceHoledSmallImage"]];
        
        //剩余数量
        if (item.bornCategory.integerValue == kPadBornCategoryProduct)
        {
            self.leftCount.hidden = false;
            if (item.inHandAmount.integerValue <= 0)
            {
                self.leftCount.text = @"无库存";
            }
            else if (item.inHandAmount.integerValue > 0)
            {
                 self.leftCount.text = [NSString stringWithFormat:LS(@"剩余%d"), item.inHandAmount.integerValue];
            }
        }
        else
        {
//            self.leftCount.text = @"";
            self.leftCount.hidden = true;
        }
        
    }
    else if ([object isKindOfClass:[PadProjectCart class]])
    {
        PadProjectCart *cart = (PadProjectCart *)object;
        
        //名称
        self.titleName.text = cart.item.itemName;
        
        //价格
        self.priceView.text = [NSString stringWithFormat:LS(@"PadPriceInfo"), cart.item.totalPrice.floatValue];
        
        //图片
        [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:cart.item.imageUrl] placeholderImage:[UIImage imageNamed:@"BornCategoryPleceHoledSmallImage"]];
        
        //剩余数量
        if (cart.localCount != 0)
        {
            self.leftCount.hidden = false;
            self.leftCount.text = [NSString stringWithFormat:LS(@"PadQuantityInfo"), cart.localCount, cart.item.uomName];
            self.buyTagLabel.hidden = false;
            self.priceView.text = @"卡内";
        }
        else
        {
            self.leftCount.hidden = true;
            self.buyTagLabel.hidden = true;
        }

       
    }
    else if ([object isKindOfClass:[CDMemberCardProject class]])
    {
        CDMemberCardProject *cardProject = (CDMemberCardProject *)object;
        
        //名称
        self.titleName.text = cardProject.item.itemName;
        
        //价格
        self.priceView.text = [NSString stringWithFormat:LS(@"PadPriceInfo"), cardProject.item.totalPrice.floatValue];
        
        //图片
        [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:cardProject.item.imageUrl] placeholderImage:[UIImage imageNamed:@"BornCategoryPleceHoledSmallImage"]];
        
        //剩余数量
        if (cardProject.localCount.integerValue != 0)
        {
            self.leftCount.hidden = false;
            self.leftCount.text = [NSString stringWithFormat:LS(@"PadQuantityInfo"), cardProject.localCount.integerValue, cardProject.item.uomName];
            self.priceView.text = @"卡内";
        }
        else
        {
            self.leftCount.hidden = true;
        }
       
    }
    else if ([object isKindOfClass:[CDCouponCardProduct class]])
    {
        CDCouponCardProduct *coupon = (CDCouponCardProduct *)object;
        //名称
        self.titleName.text = coupon.item.itemName;
        
        //价格
        self.priceView.text = [NSString stringWithFormat:LS(@"PadPriceInfo"), coupon.item.totalPrice.floatValue];
        
        //图片
        [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:coupon.item.imageUrl] placeholderImage:[UIImage imageNamed:@"BornCategoryPleceHoledSmallImage"]];
        
        //剩余数量
        if (coupon.localCount.integerValue != 0)
        {
            self.leftCount.hidden = false;
            self.leftCount.text = [NSString stringWithFormat:LS(@"PadQuantityInfo"), coupon.localCount.integerValue, coupon.item.uomName];
            self.priceView.text = @"卡内";
        }
        else
        {
            self.leftCount.hidden = true;
        }

    }
}
@end
