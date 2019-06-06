//
//  BottomPayView.m
//  Boss
//
//  Created by jiangfei on 16/6/22.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BottomPayView.h"
#import "CDProjectTemplate+CoreDataClass.h"
#import "GoodsModel.h"
@interface BottomPayView ()

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *numBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIButton *shopCatrBtn;


@end
@implementation BottomPayView

+ (instancetype)createView
{
    return [self loadFromNib];
}

- (void)awakeFromNib
{
    [super awakeFromNib];

}

- (void)setOperate:(CDPosOperate *)operate
{
    _operate = operate;
    NSInteger num = 0;
//    num = operate.products.count + operate.useItems.count
    
    for (CDPosBaseProduct *posProduct in operate.products.array) {
        num += posProduct.product_qty.integerValue;
    }
    
    for (CDCurrentUseItem *useItem in operate.useItems.array) {
        num += useItem.useCount.integerValue;
    }
    
    if (num == 0) {
        self.payBtn.enabled = false;
        self.gudanBtn.enabled = false;
        self.numBtn.hidden = true;
    }
    else
    {
        self.numBtn.hidden = false;
        self.payBtn.enabled = true;
        self.gudanBtn.enabled = true;
        [self.numBtn setTitle:[NSString stringWithFormat:@"%d",num] forState:UIControlStateNormal];
    }
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",operate.amount.doubleValue];
}


- (IBAction)payBtnClick:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(didPayOperate:)]) {
        [self.delegate didPayOperate:self.operate];
    }
}

- (IBAction)shopCartBtn:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(didShopCartOperate:)]) {
        [self.delegate didShopCartOperate:self.operate];
    }
}


- (IBAction)guaDanBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didGuaDanOperate:)]) {
        [self.delegate didGuaDanOperate:self.operate];
    }
}

@end
