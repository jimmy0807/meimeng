//
//  SettingUpdatePwdViewController.m
//  Boss
//
//  Created by mac on 15/7/3.
//  Copyright (c) 2015年 BORN. All rights reserved.
//
#import "CBMessageView.h"
#import "BSEditCell.h"
#import "SettingUpdatePwdViewController.h"

typedef NS_ENUM(int, tableViewRow)
{
    FirstRow,
    SecondRow,
    ThirdRow,
};
@interface SettingUpdatePwdViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableVeiw;

@end

@implementation SettingUpdatePwdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigationBarbutton];
}


- (void)initNavigationBarbutton
{
    self.tableVeiw.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = COLOR(242, 242, 242, 1.0);
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    
    self.navigationItem.title = @"更改密码";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.frame= CGRectMake(0, 0, 40, 44);
    [btn addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = btn_right;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        BSEditCell *cell = [[BSEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.titleLabel.text = @"旧密码";
        cell.arrowImageView.hidden = YES;
        cell.contentField.enabled = YES;
        cell.contentField.placeholder = @"";
        cell.contentField.delegate = self;
        cell.contentField.secureTextEntry = YES;
        return cell;
    }
    else if(indexPath.row==1)
    {
        BSEditCell *cell = [[BSEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.titleLabel.text = @"新密码";
        cell.arrowImageView.hidden = YES;
        cell.contentField.enabled = YES;
        cell.contentField.placeholder = @"";
        cell.contentField.delegate = self;
        cell.contentField.secureTextEntry = YES;
        return cell;
    }
    else if(indexPath.row==2)
    {
        BSEditCell *cell = [[BSEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.titleLabel.text = @"确认新密码";
        cell.arrowImageView.hidden = YES;
        cell.contentField.enabled = YES;
        cell.contentField.placeholder = @"";
        cell.contentField.delegate = self;
        cell.contentField.secureTextEntry = YES;
        return cell;
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49.0;
}

#pragma 本地验证密码
- (BOOL)checkPassword
{
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:SecondRow inSection:0];
    BSEditCell *cell1  = (BSEditCell *)[self.tableVeiw cellForRowAtIndexPath:indexPath1];
    
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:ThirdRow inSection:0];
    BSEditCell *cell2  = (BSEditCell *)[self.tableVeiw cellForRowAtIndexPath:indexPath2];
    if([cell1.contentField.text isEqualToString:cell2.contentField.text])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)buttonClicked
{
    if([self checkPassword])
    {
        
    }
    else
    {
        CBMessageView *message = [[CBMessageView alloc]initWithTitle:@"新密码与确认密码不同" afterTimeHide:1.25];
        [message show];
    }
}

#pragma UITextFieldDelegate 

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
