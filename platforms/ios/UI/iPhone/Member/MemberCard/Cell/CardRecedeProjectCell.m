//
//  CardRecedeProjectCell.m
//  Boss
//
//  Created by lining on 16/4/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "CardRecedeProjectCell.h"

@interface CardRecedeProjectCell ()

@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;
@property (strong, nonatomic) IBOutlet UITextField *moneyTextField;
@property (strong, nonatomic) IBOutlet UIButton *reduceBtn;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;
@end

@implementation CardRecedeProjectCell

+ (instancetype)createCell
{
    CardRecedeProjectCell *cell = [self loadFromNib];
    cell.minCount = 0;
    return cell;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)setMaxCount:(NSInteger)maxCount
{
    _maxCount = maxCount;
    self.countLabel.text = [NSString stringWithFormat:@"%d",maxCount];
    self.tipLabel.text = [NSString stringWithFormat:@"您最多可退数量为%d个",maxCount];
    self.count = maxCount;
}

- (void)setMinCount:(NSInteger)minCount
{
    _minCount = minCount;
}

-(void)setCount:(NSInteger)count
{
    _count = count;
    
    if (count <= self.minCount) {
        self.reduceBtn.enabled = false;
        _count = self.minCount;
    }
    else
    {
        self.reduceBtn.enabled = true;
    }
    
    if (count >= self.maxCount) {
        self.addBtn.enabled = false;
        count = self.maxCount;
    }
    else
    {
        self.addBtn.enabled = true;
    }
    
    self.currentCountLabel.text = [NSString stringWithFormat:@"%d",count];
    //    [self.priceBtn setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
}

- (void)setMoney:(CGFloat)money
{
    _money = money;
    self.moneyTextField.text = [NSString stringWithFormat:@"%.2f",money];
}

- (IBAction)reduceBtnPressed:(id)sender
{
    self.count --;
}

- (IBAction)addBtnPressed:(id)sender
{
    self.count ++;
}
@end
