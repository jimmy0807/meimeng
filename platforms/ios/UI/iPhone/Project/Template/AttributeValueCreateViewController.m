//
//  AttributeValueCreateViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/6/12.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "AttributeValueCreateViewController.h"
#import "NSObject+MainThreadNotification.h"
#import "CBLoadingView.h"
#import "BSEditCell.h"
#import "BSAttributeValueCreateRequest.h"

typedef enum kAttributeValueSectionType
{
    kAttributeValueSectionName,
    kAttributeValueSectionCount
}kAttributeValueSectionType;

typedef enum kAttributeValueNameType
{
    kAttributeValueName,
    kAttributeValueNameRowCount
}kAttributeValueNameType;

#define kAttributeValueCellHeight    50.0

@interface AttributeValueCreateViewController ()

@property (nonatomic, strong) CDProjectAttribute *attribute;
@property (nonatomic, strong) CDProjectAttributeValue *attributeValue;

@property (nonatomic, assign) kAttributeValueType type;
@property (nonatomic, strong) NSString *attributeValueName;

@property (nonatomic, strong) UITableView *attributeValueTableView;

@end

@implementation AttributeValueCreateViewController

- (id)initWithAttribute:(CDProjectAttribute *)attribute attributeValue:(CDProjectAttributeValue *)attributeValue
{
    self = [super initWithNibName:NIBCT(@"AttributeValueCreateViewController") bundle:nil];
    if (self != nil)
    {
        self.attribute = attribute;
        self.attributeValue = attributeValue;
        if (self.attributeValue == nil)
        {
            self.type = kAttributeValueCreate;
            self.title = LS(@"AttributeValueCreateTitle");
        }
        else
        {
            self.type = kAttributeValueEdit;
            self.attributeValueName = self.attributeValue.attributeValueName;
            self.title = self.attributeValue.attributeValueName;
        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self forbidSwipGesture];
    self.view.backgroundColor = COLOR(245.0, 245.0, 245.0, 1.0);
    self.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
    
    BNBackButtonItem *backButtonItem = [[BNBackButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_back_n"] highlightedImage:[UIImage imageNamed:@"navi_back_h"]];
    backButtonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc] initWithTitle:LS(@"Finish")];
    rightButtonItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    [self registerNofitificationForMainThread:kBSAttributeValueCreateResponse];
    
    self.attributeValueTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.attributeValueTableView.backgroundColor = [UIColor clearColor];
    self.attributeValueTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.attributeValueTableView.delegate = self;
    self.attributeValueTableView.dataSource = self;
    self.attributeValueTableView.showsVerticalScrollIndicator = NO;
    self.attributeValueTableView.showsHorizontalScrollIndicator = NO;
    self.attributeValueTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.attributeValueTableView];
    
    UIView *headerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 19.5, IC_SCREEN_WIDTH, 0.5)];
    lineImageView.backgroundColor = [UIColor clearColor];
    lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
    [headerView addSubview:lineImageView];
    self.attributeValueTableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    footerView.backgroundColor = [UIColor clearColor];
    self.attributeValueTableView.tableFooterView = footerView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -
#pragma mark Required Methods

- (void)didRightBarButtonItemClick:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (self.attributeValueName.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:LS(@"AttributeOrValueCanNotBeNULL")
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }
    
    [[CBLoadingView shareLoadingView] show];
    if (self.type == kAttributeValueCreate)
    {
        BSAttributeValueCreateRequest *request = [[BSAttributeValueCreateRequest alloc] initWithAttribute:self.attribute attributeValueName:self.attributeValueName];
        [request execute];
    }
    else if (self.type == kAttributeValueEdit)
    {
        BSAttributeValueCreateRequest *request = [[BSAttributeValueCreateRequest alloc] initWithAttribute:self.attribute attributeValue:self.attributeValue attributeValueName:self.attributeValueName];
        [request execute];
    }
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSAttributeValueCreateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
//            UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:(self.navigationController.viewControllers.count - 3)];
//            [self.navigationController popToViewController:viewController animated:YES];
        }
        else
        {
            NSString *message = [notification.userInfo stringValueForKey:@"rm"];
            if(message.length != 0)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:message
                                                                   delegate:nil
                                                          cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    }
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kAttributeValueNameRowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kAttributeValueCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == kAttributeValueName)
    {
        static NSString *CellIdentifier = @"AttributeValueCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextField *contentField = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, kAttributeValueCellHeight)];
            contentField.backgroundColor = [UIColor clearColor];
            contentField.textColor = COLOR(72.0, 72.0, 72.0, 1.0);
            contentField.placeholder = LS(@"PleaseEnter");
            [contentField setValue:COLOR(136.0, 136.0, 136.0, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
            contentField.font = [UIFont boldSystemFontOfSize:16.0];
            contentField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            contentField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            contentField.returnKeyType = UIReturnKeyDone;
            contentField.delegate = self;
            contentField.tag = 101;
            UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, contentField.frame.size.height)];
            leftView.backgroundColor = [UIColor clearColor];
            contentField.leftView = leftView;
            contentField.leftViewMode = UITextFieldViewModeAlways;
            UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, contentField.frame.size.height)];
            rightView.backgroundColor = [UIColor clearColor];
            contentField.rightView = rightView;
            contentField.rightViewMode = UITextFieldViewModeUnlessEditing;
            contentField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell.contentView addSubview:contentField];
            
            UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kAttributeValueCellHeight - 0.5, IC_SCREEN_WIDTH, 0.5)];
            lineImageView.backgroundColor = [UIColor clearColor];
            lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
            [cell.contentView addSubview:lineImageView];
        }
        
        UITextField *contentField = (UITextField *)[cell.contentView viewWithTag:101];
        contentField.text = self.attributeValueName;
        
        return cell;
    }
    
    return nil;
}


#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.attributeValueName = textField.text;
}

@end
