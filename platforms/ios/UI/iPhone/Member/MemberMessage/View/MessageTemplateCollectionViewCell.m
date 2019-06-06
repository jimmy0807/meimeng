//
//  MessgeTemplateCollectionViewCell.m
//  Boss
//
//  Created by lining on 16/5/27.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MessageTemplateCollectionViewCell.h"

@implementation TemplateItem

@end

@implementation MessageTemplateCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [super awakeFromNib];
    
}

- (void)setItem:(TemplateItem *)item
{
    self.bgImgView.hidden = true;
    self.imgView.hidden = false;
    if (item) {
        self.imgView.image = [UIImage imageNamed:item.imgName];
        self.nameLabel.text = item.name;
//        if ([item.name isEqualToString:@"自定义"]) {
//            self.nameLabel.text = nil;
//            self.bgImgView.hidden = false;
//            self.imgView.hidden = true;
//        }
    }
    else
    {
        self.imgView.image = nil;
        self.nameLabel.text = nil;
    }
    
}

@end


