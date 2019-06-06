//
//  ProductTypeColletionCell.m
//  Boss
//
//  Created by jiangfei on 16/5/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ProductTypeColletionCell.h"
#import "CDProjectTemplate+CoreDataClass.h"
#import "CDProjectItem+CoreDataClass.h"
#import "GoodsModel.h"
#import "PadProjectCart.h"

@interface ProductTypeColletionCell ()
/** 剩余数量  */
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (strong, nonatomic) IBOutlet UILabel *buyTagLabel;

/** 产品图片  */
@property (weak, nonatomic) IBOutlet UIImageView *imageName;
@property (weak, nonatomic) IBOutlet UILabel *titleNameView;
@property (weak, nonatomic) IBOutlet UIButton *priceBtnView;

@end
@implementation ProductTypeColletionCell

- (void)awakeFromNib
{
    [super awakeFromNib];
//    self.countLabel.hidden = YES;
   
    self.titleNameView.userInteractionEnabled = NO;
    self.titleNameView.font = projectSmallFont;
    self.priceBtnView.titleLabel.font = projectMainPicturePriceFont;
    
    self.selectedLabel.hidden = true;
    
}

- (void)setObject:(NSManagedObject *)object
{
    self.countLabel.hidden = false;
    self.buyTagLabel.hidden = true;
    if ([object isKindOfClass:[CDProjectTemplate class]])
    {
        self.countLabel.hidden = true;
        CDProjectTemplate *item = (CDProjectTemplate *)object;
        
        //图片
        [self.imageName sd_setImageWithURL:[NSURL URLWithString:item.imageUrl] placeholderImage:[UIImage imageNamed:@"BornCategoryPleceHoledImage.png"]];//BornCategoryPleceHoledImage.png
        //价格
//        self.priceBtnView.titleLabel.text = [NSString stringWithFormat:@"￥%0.2f",[item.listPrice floatValue]];
        //名称
//        self.titleNameBtn.titleLabel.text = item.templateName;
        
        [self.priceBtnView setTitle:[NSString stringWithFormat:@"￥%0.2f",[item.listPrice floatValue]] forState:UIControlStateNormal];
        self.titleNameView.text = item.templateName;
        
    }
    else if ([object isKindOfClass:[CDProjectItem class]]) {
        CDProjectItem *item = (CDProjectItem *)object;
        //名称
         self.titleNameView.text = item.templateName;
        //价格
        [self.priceBtnView setTitle:[NSString stringWithFormat:@"￥%0.2f",[item.totalPrice floatValue]] forState:UIControlStateNormal];
        
        //图片
        [self.imageName sd_setImageWithURL:[NSURL URLWithString:item.imageUrl] placeholderImage:[UIImage imageNamed:@"BornCategoryPleceHoledImage.png"]];
        
        //剩余数量
        if (item.bornCategory.integerValue == kPadBornCategoryProduct)
        {
            self.countLabel.hidden = false;
            if (item.inHandAmount.integerValue <= 0)
            {
                self.countLabel.text = @"无库存";
            }
            else if (item.inHandAmount.integerValue > 0)
            {
                self.countLabel.text = [NSString stringWithFormat:LS(@"剩余%d"), item.inHandAmount.integerValue];
            }
        }
        else
        {
            self.countLabel.hidden = true;
        }
        
    }
    else if ([object isKindOfClass:[PadProjectCart class]])
    {
        PadProjectCart *cart = (PadProjectCart *)object;
        
        //名称
         self.titleNameView.text = cart.item.itemName;
        //价格
        [self.priceBtnView setTitle:[NSString stringWithFormat:@"￥%0.2f",[cart.item.totalPrice floatValue]] forState:UIControlStateNormal];
        
        //图片
        [self.imageName sd_setImageWithURL:[NSURL URLWithString:cart.item.imageUrl] placeholderImage:[UIImage imageNamed:@"BornCategoryPleceHoledImage.png"]];
        
        //剩余数量
        if (cart.localCount != 0)
        {
            self.countLabel.hidden = false;
            self.countLabel.text = [NSString stringWithFormat:LS(@"PadQuantityInfo"), cart.localCount, cart.item.uomName];
            self.buyTagLabel.hidden = false;
            [self.priceBtnView setTitle:@"卡内" forState:UIControlStateNormal];
        }
        else
        {
            self.countLabel.hidden = true;
            self.buyTagLabel.hidden = true;
        }
    }
    else if ([object isKindOfClass:[CDMemberCardProject class]])
    {
        CDMemberCardProject *cardProject = (CDMemberCardProject *)object;
        
        //名称
        self.titleNameView.text = cardProject.item.itemName;
        //价格
        [self.priceBtnView setTitle:[NSString stringWithFormat:@"￥%0.2f",[cardProject.item.totalPrice floatValue]] forState:UIControlStateNormal];
        
        //图片
        [self.imageName sd_setImageWithURL:[NSURL URLWithString:cardProject.item.imageUrl] placeholderImage:[UIImage imageNamed:@"BornCategoryPleceHoledImage.png"]];
        
        //剩余数量
        if (cardProject.localCount.integerValue != 0)
        {
            self.countLabel.hidden = false;
            self.countLabel.text = [NSString stringWithFormat:LS(@"PadQuantityInfo"), cardProject.localCount.integerValue, cardProject.item.uomName];
            [self.priceBtnView setTitle:@"卡内" forState:UIControlStateNormal];
        }
        else
        {
            self.countLabel.hidden = true;
        }
        
    }
    else if ([object isKindOfClass:[CDCouponCardProduct class]])
    {
        CDCouponCardProduct *coupon = (CDCouponCardProduct *)object;
        //名称
        self.titleNameView.text = coupon.item.itemName;
        //价格
        [self.priceBtnView setTitle:[NSString stringWithFormat:@"￥%0.2f",[coupon.item.totalPrice floatValue]] forState:UIControlStateNormal];

        //图片
        [self.imageName sd_setImageWithURL:[NSURL URLWithString:coupon.item.imageUrl] placeholderImage:[UIImage imageNamed:@"BornCategoryPleceHoledImage.png"]];
        
        //剩余数量
        if (coupon.localCount.integerValue != 0)
        {
            self.countLabel.hidden = false;
            self.countLabel.text = [NSString stringWithFormat:LS(@"PadQuantityInfo"), coupon.localCount.integerValue, coupon.item.uomName];
            [self.priceBtnView setTitle:@"卡内" forState:UIControlStateNormal];
        }
        else
        {
            self.countLabel.hidden = true;
        }
    }
}

@end
