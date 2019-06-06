//
//  ProductTypeNavigationView.m
//  Boss
//
//  Created by jiangfei on 16/5/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ProductTypeNavigationView.h"
@interface ProductTypeNavigationView ()
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;


@end
@implementation ProductTypeNavigationView
+(instancetype)createView
{
    ProductTypeNavigationView *navigationView =[[[NSBundle mainBundle]loadNibNamed:@"ProductTypeNavigationView" owner:nil options:nil]lastObject];
    return navigationView;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backBtn.tag = 0;
    [self.backBtn sizeToFit];
    self.addBtn.tag = 2;
    [self.addBtn sizeToFit];
    self.titleImage.hidden = YES;
    self.titleBtn.tag = 3;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.backgroundColor = [UIColor colorWithRed:11/255.0 green:169/255.0 blue:250/255.0 alpha:1];
}

-(void)setImageHide:(BOOL)imageHide
{
    _imageHide = imageHide;
    self.titleImage.hidden = imageHide;
}

- (IBAction)backBtnClick:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(naviBtnClickWithBtnTage:)]) {
        [_delegate naviBtnClickWithBtnTage:sender.tag];
    }
}

- (IBAction)addBtnClick:(UIButton *)sender {
    [self backBtnClick:sender];
}
- (IBAction)titleBtnClick:(UIButton *)sender {
    if (!self.imageHide) {
//        self.titleImage.transform =  CGAffineTransformRotate(self.titleImage.transform, M_PI);
    }
    [self backBtnClick:sender];
    
}

@end
