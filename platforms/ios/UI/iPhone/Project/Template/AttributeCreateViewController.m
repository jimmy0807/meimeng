//
//  AttributeCreateViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/6/12.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "AttributeCreateViewController.h"
#import "NSObject+MainThreadNotification.h"
#import "CBLoadingView.h"
#import "BSEditCell.h"
#import "BSAttributeCreateRequest.h"

typedef enum kAttributeSectionType
{
    kAttributeSectionName,
    kAttributeSectionCount
}kAttributeSectionType;

typedef enum kAttributeNameType
{
    kAttributeName,
    kAttributeNameRowCount
}kAttributeNameType;

#define kAttributeCellHeight    50.0

@interface AttributeCreateViewController ()

@property (nonatomic, strong) CDProjectAttribute *attribute;

@property (nonatomic, assign) kAttributeType type;
@property (nonatomic, strong) NSString *attributeName;

@property (nonatomic, strong) UITableView *attributeTableView;

@end

@implementation AttributeCreateViewController

- (id)initWithAttribute:(CDProjectAttribute *)attribute
{
    self = [super initWithNibName:NIBCT(@"AttributeCreateViewController") bundle:nil];
    if (self != nil)
    {
        self.attribute = attribute;
        if (self.attribute == nil)
        {
            self.type = kAttributeCreate;
            self.title = LS(@"AttributeCreateTitle");
        }
        else
        {
            self.type = kAttributeEdit;
            self.attributeName = self.attribute.attributeName;
            self.title = self.attribute.attributeName;
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
    
    [self registerNofitificationForMainThread:kBSAttributeCreateResponse];
    
    self.attributeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.attributeTableView.backgroundColor = [UIColor clearColor];
    self.attributeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.attributeTableView.delegate = self;
    self.attributeTableView.dataSource = self;
    self.attributeTableView.showsVerticalScrollIndicator = NO;
    self.attributeTableView.showsHorizontalScrollIndicator = NO;
    self.attributeTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.attributeTableView];
    
    UIView *headerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 19.5, IC_SCREEN_WIDTH, 0.5)];
    lineImageView.backgroundColor = [UIColor clearColor];
    lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
    [headerView addSubview:lineImageView];
    self.attributeTableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    footerView.backgroundColor = [UIColor clearColor];
    self.attributeTableView.tableFooterView = footerView;
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
    if (self.attributeName.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:LS(@"AttributeNameCanNotBeNULL")
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    else
    {
        CDProjectAttribute *attribute = [[BSCoreDataManager currentManager] findEntity:@"CDProjectAttribute" withValue:self.attributeName forKey:@"attributeName"];
        if (attribute)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kBSAttributeEditFinish object:attribute userInfo:nil];
            UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:(self.navigationController.viewControllers.count - 3)];
            [self.navigationController popToViewController:viewController animated:YES];
            
            return;
        }
    }
    
    [[CBLoadingView shareLoadingView] show];
    if (self.type == kAttributeCreate)
    {
        BSAttributeCreateRequest *request = [[BSAttributeCreateRequest alloc] initWithAttributeName:self.attributeName];
        [request execute];
    }
    else if (self.type == kAttributeEdit)
    {
        BSAttributeCreateRequest *request = [[BSAttributeCreateRequest alloc] initWithAttribute:self.attribute attributeName:self.attributeName];
        [request execute];
    }
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSAttributeCreateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            ;
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
    return kAttributeNameRowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kAttributeCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == kAttributeName)
    {
        static NSString *CellIdentifier = @"AttributeCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextField *contentField = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, kAttributeCellHeight)];
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
            
            UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kAttributeCellHeight - 0.5, IC_SCREEN_WIDTH, 0.5)];
            lineImageView.backgroundColor = [UIColor clearColor];
            lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
            [cell.contentView addSubview:lineImageView];
        }
        
        UITextField *contentField = (UITextField *)[cell.contentView viewWithTag:101];
        contentField.text = self.attributeName;
        
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
    self.attributeName = textField.text;
}


@end
