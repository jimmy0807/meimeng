//
//  productTypeNaviSearch.m
//  Boss
//
//  Created by jiangfei on 16/5/27.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "productTypeNaviSearch.h"
@interface productTypeNaviSearch ()<UITextFieldDelegate>
/**
 *  <#Description#>
 */
@property (weak, nonatomic) IBOutlet UITextField *searchView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtnView;

@end
@implementation productTypeNaviSearch

#pragma mark 点击了取消按钮
- (IBAction)cancelBtnClick:(UIButton *)sender {
    
    if (_cancelBlock) {
        [self.searchView resignFirstResponder];
        _cancelBlock();
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithRed:11/255.0 green:169/255.0 blue:250/255.0 alpha:1.0];
    //左边的放大镜
    UIView *lefView = [[UIView alloc]init];
    //左边占位的view
    lefView.frame = CGRectMake(0, 0, 35, 3);
    self.searchView.leftView = lefView;
    self.searchView.leftViewMode = UITextFieldViewModeAlways;
//    //右边清除按钮
    self.searchView.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchView.textColor = [UIColor whiteColor];
    self.searchView.tintColor = [UIColor whiteColor];
    self.searchView.delegate = self;
    self.searchView.returnKeyType = UIReturnKeySearch;
    [self.searchView becomeFirstResponder];
}
-(void)cancelbtnClick
{
    [self cancelBtnClick:self.cancelBtnView];
}
-(void)searchBecomeFirstResponder
{
    [self.searchView becomeFirstResponder];
}
#pragma mark 点击了return按钮
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //点击了return按钮
    NSLog(@"点击了return按钮,textfield.text = %@",textField.text);
    [self.searchView resignFirstResponder];
    if (_searchBlock) {
        _searchBlock(textField.text);
    }
    return YES;
}
-(void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed:@"member_search_blue_bg.png"];
    UIEdgeInsets insets = UIEdgeInsetsMake(30, 30, 10, 10);
    image = [image resizableImageWithCapInsets:insets];
    [image drawInRect:self.searchView.frame];

}
-(void)layoutSubviews
{
   [super layoutSubviews];
}
@end
