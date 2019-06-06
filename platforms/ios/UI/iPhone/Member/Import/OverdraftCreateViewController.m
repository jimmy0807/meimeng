//
//  OverdraftCreateViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/8/20.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "OverdraftCreateViewController.h"
#import "BSEditCell.h"
#import "BSOverdraft.h"
#import "BSOptionViewController.h"
#import "NSObject+MainThreadNotification.h"

#define kOverdraftCellHeight       50.0

typedef enum kOverdraftEditType
{
    kOverdraftEdit,
    kOverdraftCreate
}kOverdraftEditType;

typedef enum kOverdraftInfoRow
{
    kOverdraftInfoName,
    kOverdraftInfoType,
    kOverdraftInfoAmount,
    kOverdraftInfoRemark,
    kOverdraftInfoRowCount
}kOverdraftInfoRow;

@interface OverdraftCreateViewController ()

@property (nonatomic, assign) NSInteger editIndex;
@property (nonatomic, strong) NSMutableArray *overdrafts;
@property (nonatomic, assign) kOverdraftEditType editType;

@property (nonatomic, strong) BSOverdraft *bsOverdraft;
@property (nonatomic, strong) UITableView *overdraftTableView;

@end

@implementation OverdraftCreateViewController

- (id)initWithOverdrafts:(NSMutableArray *)overdrafts editIndex:(NSInteger)editIndex
{
    self = [super initWithNibName:NIBCT(@"CardItemViewController") bundle:nil];
    if (self)
    {
        self.editIndex = editIndex;
        self.overdrafts = overdrafts;
        self.bsOverdraft = [[BSOverdraft alloc] init];
        if (self.editIndex >= 0 && self.editIndex < self.overdrafts.count)
        {
            self.editType = kOverdraftEdit;
            
            BSOverdraft *overdraft = [self.overdrafts objectAtIndex:self.editIndex];
            self.bsOverdraft.name = overdraft.name;
            self.bsOverdraft.type = overdraft.type;
            self.bsOverdraft.amount = overdraft.amount;
            self.bsOverdraft.remark = overdraft.remark;
            self.title = self.bsOverdraft.name;
        }
        else
        {
            self.editType = kOverdraftCreate;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = LS(@"OverdraftInfoNameFormatter");
            self.bsOverdraft.name = [dateFormatter stringFromDate:[NSDate date]];
            self.bsOverdraft.type = @"arrears";
            self.bsOverdraft.amount = 0.0f;
            self.bsOverdraft.remark = @"";
            self.title = LS(@"CreateOverdraft");
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
    
    [self registerNofitificationForMainThread:kBSCardOverdraftTypeSelected];
    
    self.overdraftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.overdraftTableView.backgroundColor = [UIColor clearColor];
    self.overdraftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.overdraftTableView.delegate = self;
    self.overdraftTableView.dataSource = self;
    self.overdraftTableView.showsVerticalScrollIndicator = NO;
    self.overdraftTableView.showsHorizontalScrollIndicator = NO;
    self.overdraftTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.overdraftTableView];
    
    UIView *headerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 19.5, IC_SCREEN_WIDTH, 0.5)];
    lineImageView.backgroundColor = [UIColor clearColor];
    lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
    [headerView addSubview:lineImageView];
    self.overdraftTableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    footerView.backgroundColor = [UIColor clearColor];
    self.overdraftTableView.tableFooterView = footerView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    if (self.bsOverdraft.name.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:LS(@"OverdraftInfoNameCanNotBeNULL")
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        
        return ;
    }
    
    if (self.editType == kOverdraftEdit)
    {
        [self.overdrafts replaceObjectAtIndex:self.editIndex withObject:self.bsOverdraft];
    }
    else if (self.editType == kOverdraftCreate)
    {
        [self.overdrafts insertObject:self.bsOverdraft atIndex:self.overdrafts.count];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSOverdraftCreateResult object:self.overdrafts userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSCardOverdraftTypeSelected])
    {
        self.bsOverdraft.type = (NSString *)notification.object;
        BSEditCell *cell = (BSEditCell *)[self.overdraftTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kOverdraftInfoType inSection:0]];
        cell.contentField.text = LS(self.bsOverdraft.type);
    }
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kOverdraftInfoRowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kOverdraftCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BSEditCellIdentifier";
    BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BSEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.contentField.delegate = self;
    }
    
    cell.contentField.tag = 100 * indexPath.section + indexPath.row;
    cell.arrowImageView.hidden = NO;
    if (indexPath.row == kOverdraftInfoName)
    {
        cell.titleLabel.text = LS(@"OverdraftInfoName");
        cell.contentField.enabled = YES;
        cell.contentField.placeholder = LS(@"PleaseEnter");
        cell.contentField.text = self.bsOverdraft.name;
    }
    else if (indexPath.row == kOverdraftInfoType)
    {
        cell.titleLabel.text = LS(@"OverdraftInfoType");
        cell.contentField.enabled = NO;
        cell.contentField.placeholder = @"PleaseSelect";
        cell.contentField.text = LS(self.bsOverdraft.type);
    }
    else if (indexPath.row == kOverdraftInfoAmount)
    {
        cell.titleLabel.text = LS(@"OverdraftInfoAmount");
        cell.contentField.enabled = YES;
        cell.contentField.placeholder = LS(@"PleaseEnter");
        cell.contentField.text = [NSString stringWithFormat:@"%.2f", self.bsOverdraft.amount];
    }
    else if (indexPath.row == kOverdraftInfoRemark)
    {
        cell.titleLabel.text = LS(@"OverdraftInfoRemark");
        cell.contentField.enabled = YES;
        cell.contentField.placeholder = LS(@"PleaseEnter");
        cell.contentField.text = self.bsOverdraft.remark;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == kOverdraftInfoType)
    {
        NSArray *options = [NSArray arrayWithObjects:@"arrears", @"course_arrears", nil];
        BSOptionViewController *viewController = [[BSOptionViewController alloc] initWithTitle:LS(@"OverdraftInfoType") options:options selectedstr:self.bsOverdraft.type notification:kBSCardOverdraftTypeSelected];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSInteger row = textField.tag % 100;
    if (row == kOverdraftInfoAmount)
    {
        if (textField.text.floatValue == 0)
        {
            textField.text = @"";
        }
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger section = textField.tag / 100;
    NSInteger row = textField.tag % 100;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    BSEditCell *cell = (BSEditCell *)[self.overdraftTableView cellForRowAtIndexPath:indexPath];
    if (row == kOverdraftInfoName)
    {
        self.bsOverdraft.name = textField.text;
        cell.contentField.text = self.bsOverdraft.name;
    }
    else if (row == kOverdraftInfoAmount)
    {
        self.bsOverdraft.amount = textField.text.floatValue;
        cell.contentField.text = [NSString stringWithFormat:@"%.2f", self.bsOverdraft.amount];
    }
    else if (row == kOverdraftInfoRemark)
    {
        self.bsOverdraft.remark = textField.text;
        cell.contentField.text = self.bsOverdraft.remark;
    }
}

@end
