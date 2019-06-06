//
//  TechnicianCell.m
//  Boss
//
//  Created by lining on 16/7/14.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "TechnicianCell.h"

@interface TechnicianCell ()
{
    BOOL nameArrowSelected,dateArrowSelected;
}
@end

@implementation TechnicianCell

+ (instancetype)createCell
{
    return [self loadFromNib];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [super awakeFromNib];
    
    self.dateArrow.hidden = true;
    self.nameArrow.hidden = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (IBAction)technicanBtnPressed:(id)sender {
    
    nameArrowSelected = !nameArrowSelected;
    if (nameArrowSelected) {
        self.nameArrow.transform = CGAffineTransformRotate(self.nameArrow.transform, M_PI);
    }
    else
    {
        self.nameArrow.transform = CGAffineTransformIdentity;
    }
    
    if ([self.delegate respondsToSelector:@selector(didTechnicianArrowBtnSelected:)]) {
        [self.delegate didTechnicianArrowBtnSelected:YES];
    }
    
}

- (IBAction)dateBtnPressed:(id)sender {
    dateArrowSelected = !dateArrowSelected;
    if (dateArrowSelected) {
        self.dateArrow.transform = CGAffineTransformRotate(self.nameArrow.transform, M_PI);
    }
    else
    {
        self.dateArrow.transform = CGAffineTransformIdentity;
    }
    
    if ([self.delegate respondsToSelector:@selector(didDateBtnSelected:)]) {
        [self.delegate didDateBtnSelected:YES];
    }
}

@end
