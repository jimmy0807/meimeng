//
//  productTableHeadView.m
//  Boss
//
//  Created by jiangfei on 16/6/3.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "productTableHeadView.h"
#import "UIButton+WebCache.h"
#import "KeyBordAccessoryView.h"
#import "BaseInfoTempModel.h"
@interface productTableHeadView ()<UITextFieldDelegate,KeyBordAccessoryViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *salePriceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numInTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *pictureBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *costTextField;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet UILabel *nameTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *projectServiceTime;
@property (weak, nonatomic) IBOutlet UILabel *timeTitleLabel;
/** text*/
@property (nonatomic,strong)NSString *keyText;
@end
@implementation productTableHeadView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.emptyView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    
    self.nameTextField.delegate = self;
    self.nameTextField.tag = 0;
    self.nameTextField.font = projectContentFont;
    self.nameTextField.textColor = projectTextFieldColor;
    self.nameTitleLabel.font = projectTitleFont;
    [self.nameTextField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.priceTextField.delegate = self;
    self.priceTextField.tag = 1;
    self.priceTextField.font = projectContentFont;
    self.priceTextField.textColor = projectTextFieldColor;
    self.salePriceTitleLabel.font = projectTitleFont;
    self.priceTextField.keyboardType = UIKeyboardTypeNumberPad;
    KeyBordAccessoryView *keyBordView = [KeyBordAccessoryView keyBordAccessoryView];
    keyBordView.accessoryDelegate = self;
    self.priceTextField.inputAccessoryView = keyBordView;
    [self.priceTextField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.costTextField.delegate = self;
    self.costTextField.tag = 2;
    self.costTextField.font = projectContentFont;
    self.costTextField.textColor = projectTextFieldColor;
    self.priceTitleLabel.font = projectTitleFont;
    self.costTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.costTextField.inputAccessoryView = keyBordView;
    [self.costTextField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.projectServiceTime.tag = 3;
    self.projectServiceTime.delegate = self;
    self.projectServiceTime.font = projectContentFont;
    self.projectServiceTime.textColor = projectTextFieldColor;
    self.timeTitleLabel.font =projectTitleFont;
    self.projectServiceTime.keyboardType = UIKeyboardTypeNumberPad;
    self.projectServiceTime.inputAccessoryView = keyBordView;
    
    self.numInTitleLabel.font = projectTitleFont;
    self.numTextField.textColor = projectTextFieldColor;
    self.numTextField.font = projectContentFont;
    [self.numTextField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
}
-(void)textFieldValueChange:(UITextField*)textField
{
    if (textField.tag ==0) {//名称
        self.tempModel.name = textField.text;
    }else if (textField.tag == 1){//售价
        self.tempModel.list_price = [textField.text floatValue];
    }else if (textField.tag == 2){//成本
        self.tempModel.standard_price = [textField.text floatValue];
    }else if (textField.tag == 3){//项目服务时间
        self.tempModel.time = [textField.text integerValue];
    }
    self.keyText = textField.text;
}
#pragma mark <KeyBordAccessoryViewDelegate>
-(void)keyBordAccessoryViewCompleteItemClick
{
    if ([_delegate respondsToSelector:@selector(productTableHeadViewChangeTextField:andText:)]) {
        [_delegate productTableHeadViewChangeTextField:self.tempModel andText:self.keyText];
    }
    [self endEditing:YES];
}

-(void)setImage:(UIImage *)image
{
    _image = image;
    [self.pictureBtn setImage:image forState:UIControlStateNormal];
}
- (IBAction)pictureBtnClick:(UIButton *)sender {
    NSLog(@"上传图片");
    if ([_delegate respondsToSelector:@selector(productTableHeadViewImageBtnClick)]) {
        [_delegate productTableHeadViewImageBtnClick];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag ==0) {//名称
        self.tempModel.name = textField.text;
    }else if (textField.tag == 1){//售价
        self.tempModel.list_price = [textField.text floatValue];
    }else if (textField.tag == 2){//成本
        self.tempModel.standard_price = [textField.text floatValue];
    }else if (textField.tag == 3){//项目服务时间
        self.tempModel.time = [textField.text integerValue];
    }
    if ([_delegate respondsToSelector:@selector(productTableHeadViewChangeTextField:andText:)]) {
        [_delegate productTableHeadViewChangeTextField:self.tempModel andText:textField.text];
    }
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[@"tage"] = @(textField.tag);
//    dict[@"text"] = textField.text;
//    [myNotification postNotificationName:baseInfoEdit object:nil userInfo:dict];
}

-(void)setTempModel:(BaseInfoTempModel *)tempModel
{
    _tempModel = tempModel;
    //名称
    self.nameTextField.text = tempModel.name;
    //售价
    self.priceTextField.text = [NSString stringWithFormat:@"%0.2f",tempModel.list_price];
    //成本
    self.costTextField.text = [NSString stringWithFormat:@"%0.2f",tempModel.standard_price];
    //图片
    [self.pictureBtn sd_setImageWithURL:[NSURL URLWithString:tempModel.imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"BornCategoryPleceHoledSmallImage.png"]];
    //在手数量
    self.numTextField.text = [NSString stringWithFormat:@"%d",tempModel.qty_available];
    //项目服务时间
    self.projectServiceTime.text = [NSString stringWithFormat:@"%d",tempModel.time];
}
- (IBAction)numInhand:(UIButton *)sender {
    if (_numBlock) {
        _numBlock();
    }
}

@end
