//
//  StoreCollectionViewCell.m
//  meim
//
//  Created by 波恩公司 on 2017/9/26.
//
//

#import "StoreCollectionViewCell.h"
#import "UIView+Frame.h"
#define kMarginSize 10

@implementation StoreCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSLog(@"%s",__FUNCTION__);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.width = kCell_Width;
        self.height = kCell_Height;
        
        self.storeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 60)];
        self.storeNameLabel.backgroundColor = [UIColor clearColor];
        self.storeNameLabel.font = [UIFont systemFontOfSize:15];
        self.storeNameLabel.textColor = [UIColor grayColor];
        self.storeNameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.storeNameLabel];
    }
    return self;
}

@end
