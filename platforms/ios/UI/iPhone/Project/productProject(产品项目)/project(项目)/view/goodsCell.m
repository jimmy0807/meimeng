//
//  goodsCell.m
//  Boss
//
//  Created by jiangfei on 16/6/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "goodsCell.h"
#import "CDProjectTemplate+CoreDataClass.h"
#import "UIButton+WebCache.h"
#import "CDProjectCategory+CoreDataClass.h"
#import "ConsumeGoodModel.h"
@interface goodsCell()
@property (weak, nonatomic) IBOutlet UILabel *jianshuLabel;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@end
@implementation goodsCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleNameLabel.font = projectContentFont;
    self.numLabel.font = projectSmallFont;
    self.numLabel.textColor = projectTextFieldColor;
    self.jianshuLabel.font = self.numLabel.font;
    self.jianshuLabel.textColor = self.numLabel.textColor;
    
}

-(void)setConsumModel:(ConsumeGoodModel *)consumModel
{
    _consumModel = consumModel;
    self.jianshuLabel.text = [NSString stringWithFormat:@"%d%@",consumModel.num,consumModel.uomName];
    self.titleNameLabel.text = consumModel.name;
    self.numLabel.text = [NSString stringWithFormat:@"在手数量%@",self.jianshuLabel.text];
     [self.imageBtn sd_setImageWithURL:[NSURL URLWithString:consumModel.imageUrl ] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"BornCategoryPleceHoledImage"]];
//    if (consumModel.temp) {
//       CDProjectTemplate *temp = consumModel.temp;
//        self.jianshuLabel.text = [NSString stringWithFormat:@"%@%@",temp.qty_available,temp.uomName];
//        self.titleNameLabel.text = temp.templateName;
//        self.numLabel.text = [NSString stringWithFormat:@"在手数量%d%@",[temp.qty_available integerValue],temp.uomName];
//    }else if (consumModel.consum){
//       CDProjectTemplate *temp = [[consumModel.consum.projectItems allObjects]lastObject];
//        //件数
//        self.jianshuLabel.text = [NSString stringWithFormat:@"%@ %@",consumModel.consum.qty,consumModel.consum.uomName];
//        //标题label
//        self.titleNameLabel.text = consumModel.consum.productName;
//        //在手数量label
//        self.numLabel.text = [NSString stringWithFormat:@"在手数量%d%@",[consumModel.consum.amount integerValue],consumModel.consum.uomName];
//        //图片
//        [self.imageBtn sd_setImageWithURL:[NSURL URLWithString:temp.imageUrl ] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"BornCategoryPleceHoledImage"]];
//    }
    
   
   //pack_line_ids
}

@end
