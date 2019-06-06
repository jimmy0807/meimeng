//
//  CountCell.m
//  Boss
//
//  Created by lining on 16/7/14.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "CountCell.h"

@implementation CountCell

+ (instancetype)createCell
{
    return [self loadFromNib];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [super awakeFromNib];
    self.minCount = 0;
    self.maxCount = INT_MAX;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setCount:(NSInteger)count
{
    if (_count == count) {
        return;
    }
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
    
    self.countLabel.text = [NSString stringWithFormat:@"%d",count];
    
    if ([self.delegate respondsToSelector:@selector(didCountChanged:)]) {
        [self.delegate didCountChanged:self.count];
    }
}

- (IBAction)reduceBtnPressed:(id)sender {
    self.count --;
}

- (IBAction)addBtnPressed:(id)sender {
    self.count ++;
}


@end
