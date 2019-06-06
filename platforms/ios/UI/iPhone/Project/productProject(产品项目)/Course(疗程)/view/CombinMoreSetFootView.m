//
//  CombinMoreSetFootView.m
//  Boss
//
//  Created by jiangfei on 16/7/15.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "CombinMoreSetFootView.h"
@interface CombinMoreSetFootView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageArrow;
@end
@implementation CombinMoreSetFootView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
}
-(void)setIsShow:(BOOL)isShow
{
   
    if (_isShow != isShow) {
        self.imageArrow.transform = CGAffineTransformRotate(self.imageArrow.transform, M_PI);
    }
     _isShow = isShow;
}
- (IBAction)moreSetBtnClick:(UIButton *)sender {
    
    
    if (_footBlock) {
        self.isShow = !self.isShow;
        _footBlock(self.isShow);
    }
}

+(instancetype)combinFootView
{
    CombinMoreSetFootView *footView = [[[NSBundle mainBundle]loadNibNamed:@"CombinMoreSetFootView" owner:nil options:nil]lastObject];
    return footView;
}
@end
