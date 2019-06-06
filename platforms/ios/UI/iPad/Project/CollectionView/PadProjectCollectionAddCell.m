//
//  PadProjectCollectionAddCell.m
//  Boss
//
//  Created by XiaXianBing on 15/10/16.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadProjectCollectionAddCell.h"

#define kPadProjectCollectionCellWidth          223.0
#define kPadProjectCollectionCellHeight         236.0
#define kPadProjectCollectionImageWidth         100.0
#define kPadProjectCollectionImageHeight        75.0

@implementation PadProjectCollectionAddCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pad_project_add_backgrund"]];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pad_project_add_backgrund"]];
        
        CGFloat originY = (kPadProjectCollectionCellHeight - 3.0 - 45.0 - 24.0 - 48.0)/2.0;
        UIImageView *addImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kPadProjectCollectionCellWidth - 45.0)/2.0, originY, 45.0, 45.0)];
        addImageView.backgroundColor = [UIColor clearColor];
        addImageView.image = [UIImage imageNamed:@"pad_project_item_add"];
        [self.contentView addSubview:addImageView];
        originY += 45.0 + 24.0;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0, originY, kPadProjectCollectionCellWidth - 24.0, 48.0)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.numberOfLines = 2;
        titleLabel.font = [UIFont systemFontOfSize:16.0];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = COLOR(135.0, 153.0, 153.0, 1.0);
        titleLabel.text = LS(@"PadCreateFreeCombinationProject");
        [self.contentView addSubview:titleLabel];
    }
    
    return self;
}

@end
