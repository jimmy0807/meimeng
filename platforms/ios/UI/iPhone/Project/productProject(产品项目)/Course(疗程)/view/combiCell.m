//
//  combiCell.m
//  Boss
//
//  Created by jiangfei on 16/6/13.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "combiCell.h"
#import "CDProjectRelated.h"
#import "UIButton+WebCache.h"
#import "CombiModel.h"
@interface combiCell()
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end
@implementation combiCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [super awakeFromNib];
    self.imageBtn.userInteractionEnabled = NO;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.nameLabel.font = projectContentFont;
    self.priceLabel.font = projectSmallFont;
    self.priceLabel.textColor = projectTextFieldColor;
    self.countLabel.font = self.priceLabel.font;
    self.countLabel.textColor = self.priceLabel.textColor;
    
}
-(void)setRelated:(CDProjectRelated *)related
{
    _related = related;

    [self.imageBtn sd_setImageWithURL:[NSURL URLWithString:related.item.imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"BornCategoryPleceHoledImage"]];
    self.nameLabel.text = related.productName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%0.2f",[related.item.totalPrice floatValue]];
    self.countLabel.text = [NSString stringWithFormat:@"%d%@",[related.quantity integerValue],related.item.uomName];
    [self.countLabel sizeToFit];
}
-(void)setTemp:(CDProjectTemplate *)temp
{
    _temp = temp;
    [self.imageBtn sd_setImageWithURL:[NSURL URLWithString:temp.imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"BornCategoryPleceHoledImage"]];
    self.nameLabel.text = temp.templateName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%0.2f",[temp.list_price floatValue]];
    self.countLabel.text = [NSString stringWithFormat:@"%d%@",[temp.qty_available integerValue],temp.uomName];
    
}
-(void)setCombiModel:(CombiModel *)combiModel
{
    _combiModel = combiModel;
   
    [self.imageBtn sd_setImageWithURL:[NSURL URLWithString:combiModel.imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"BornCategoryPleceHoledImage"]];
    self.countLabel.text = [NSString stringWithFormat:@"%d%@",combiModel.num,combiModel.unitOfNum];
    self.nameLabel.text = combiModel.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%0.2f",combiModel.price*combiModel.num];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = projectSmallFont;
    CGSize maxSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    CGSize numSize = [self.countLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    self.nameLabel.preferredMaxLayoutWidth = IC_SCREEN_WIDTH -numSize.width - 90 - 5;
}
@end
