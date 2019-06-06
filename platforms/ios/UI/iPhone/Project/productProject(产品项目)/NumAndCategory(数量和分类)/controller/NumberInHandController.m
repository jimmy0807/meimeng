//
//  numInHandController.m
//  Boss
//
//  Created by jiangfei on 16/6/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "NumberInHandController.h"
#import "numInHandModel.h"
#import "KeyBordAccessoryView.h"
#import "BSFetchStorageRequest.h"

#define textFieldFontPHoldSize [UIFont boldSystemFontOfSize:13.0]
@interface NumberInHandController ()<UITextFieldDelegate,KeyBordAccessoryViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *productTextField;
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet UILabel *kuweiLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *naviView;
@end

@implementation NumberInHandController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavi];
    self.productTextField.font = textFieldFontPHoldSize;
    self.numTextField.font = textFieldFontPHoldSize;
    self.kuweiLabel.font = textFieldFontPHoldSize;
    self.numTextField.delegate = self;
    KeyBordAccessoryView *accessoryView = [KeyBordAccessoryView keyBordAccessoryView];
    accessoryView.accessoryDelegate = self;
    self.numTextField.inputAccessoryView = accessoryView;
    self.numTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.numTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //初始化数据
    [self setUpData];
    BSFetchStorageRequest *storge = [[BSFetchStorageRequest alloc]init];
   // PersonalProfile currentProfile].bshopId;
    NSString *key = [NSString stringWithFormat:@"%@",[PersonalProfile currentProfile].bshopId];
    CDStore *store = [[BSCoreDataManager currentManager] findEntity:@"CDStore" withValue:key forKey:@"storeID"];
    storge.storeId = store.storeID;
    [storge execute];
    [myNotification addObserver:self selector:@selector(success:) name:kBSFetchStorageRequest object:nil];
    
}
-(void)success:(NSNotification*)info
{
    NSLog(@"%@",info.userInfo);
    NSArray* t = [[BSCoreDataManager currentManager] fetchItems:@"CDStorage"];
    CDStorage *str = [t lastObject];
    NSLog(@"%@",str.shop_name);
    self.kuweiLabel.text = str.displayName;
    NSLog(@"%@",str.shop_id);
    NSLog(@"-----%d",t.count);
    
//    CDStorage *attribute = [[BSCoreDataManager currentManager] findEntity:@"CDStorage" withValue:store.storeID forKey:@"shop_id"];
    
}
-(void)keyBordAccessoryViewCompleteItemClick
{
    [self.numTextField endEditing:YES];
}

#pragma mark 初始化数据
-(void)setUpData
{
    self.productTextField.text = self.productName;
    self.numTextField.text = [NSString stringWithFormat:@"%d",self.num];
    //
    //self.kuweiLabel.text = self.kuwei;
    self.kuweiLabel.text = @"请选择";
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    [self changeNumNotification];
    return YES;
}

-(void)changeNumNotification
{
    if ([self.numTextField.text integerValue] == self.num) {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"tage"] = @(self.tage);
    dict[@"num"] = self.numTextField.text;
    [myNotification postNotificationName:handNumVcChangeNum object:nil userInfo:dict];
    [myNotification postNotificationName:projectSaveBtnHidden object:nil];
}
#pragma mark 设置导航栏
-(void)setUpNavi
{
    self.naviView.backgroundColor = [UIColor colorWithRed:11/255.0 green:169/255.0 blue:250/255.0 alpha:1];
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
}
#pragma mark 点击了确定按钮
- (IBAction)sureBtnClick:(UIButton *)sender {
    NSLog(@"确定");
    [self changeNumNotification];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 点击了返回按钮
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)kuweiBtnClick:(id)sender {
    NSLog(@"请选择库位");
}

@end
