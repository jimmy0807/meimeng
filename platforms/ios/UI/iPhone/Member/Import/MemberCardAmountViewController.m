//
//  MemberCardAmountViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/8/21.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "MemberCardAmountViewController.h"
#import "BSEditCell.h"
#import "NSObject+MainThreadNotification.h"

#define kCardInfoAmountCellHeight       50.0

typedef enum kCardInfoAmountRow
{
    kCardInfoCardAmount,
    kCardInfoPresentAmount,
    kCardInfoAmountRowCount
}kCardInfoAmountRow;

@interface MemberCardAmountViewController ()

@property (nonatomic, assign) CGFloat cardAmount;
@property (nonatomic, assign) CGFloat presentAmount;

@property (nonatomic, strong) UITableView *amountTableView;

@end

@implementation MemberCardAmountViewController

- (id)initWithCardAmount:(CGFloat)cardAmount presentAmount:(CGFloat)presentAmount
{
    self = [super initWithNibName:NIBCT(@"MemberCardAmountViewController") bundle:nil];
    if (self)
    {
        self.cardAmount = cardAmount;
        self.presentAmount = presentAmount;
        self.title = LS(@"CardInfoOverage");
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
    
    self.amountTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.amountTableView.backgroundColor = [UIColor clearColor];
    self.amountTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.amountTableView.delegate = self;
    self.amountTableView.dataSource = self;
    self.amountTableView.showsVerticalScrollIndicator = NO;
    self.amountTableView.showsHorizontalScrollIndicator = NO;
    self.amountTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.amountTableView];
    
    UIView *headerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 19.5, IC_SCREEN_WIDTH, 0.5)];
    lineImageView.backgroundColor = [UIColor clearColor];
    lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
    [headerView addSubview:lineImageView];
    self.amountTableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    footerView.backgroundColor = [UIColor clearColor];
    self.amountTableView.tableFooterView = footerView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark Required Methods

- (void)didBackBarButtonItemClick:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NSDictionary *dict = @{@"CardAmount":[NSNumber numberWithFloat:self.cardAmount], @"PresentAmount":[NSNumber numberWithFloat:self.presentAmount]};
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSCardAmountEditFinish object:dict userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didRightBarButtonItemClick:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NSDictionary *dict = @{@"CardAmount":[NSNumber numberWithFloat:self.cardAmount], @"PresentAmount":[NSNumber numberWithFloat:self.presentAmount]};
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSCardAmountEditFinish object:dict userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kCardInfoAmountRowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCardInfoAmountCellHeight;
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
    if (indexPath.row == kCardInfoCardAmount)
    {
        cell.titleLabel.text = LS(@"CardInfoCardAmount");
        cell.contentField.enabled = YES;
        cell.contentField.placeholder = LS(@"PleaseEnter");
        cell.contentField.text = [NSString stringWithFormat:@"%.2f", self.cardAmount];
    }
    else if (indexPath.row == kCardInfoPresentAmount)
    {
        cell.titleLabel.text = LS(@"CardInfoPresentAmount");
        cell.contentField.enabled = YES;
        cell.contentField.placeholder = LS(@"PleaseEnter");
        cell.contentField.text = [NSString stringWithFormat:@"%.2f", self.presentAmount];
    }
    
    return cell;
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
    if (textField.text.floatValue == 0)
    {
        textField.text = @"";
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger section = textField.tag / 100;
    NSInteger row = textField.tag % 100;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    BSEditCell *cell = (BSEditCell *)[self.amountTableView cellForRowAtIndexPath:indexPath];
    if (row == kCardInfoCardAmount)
    {
        self.cardAmount = textField.text.floatValue;
        cell.contentField.text = [NSString stringWithFormat:@"%.2f", self.cardAmount];
    }
    else if (row == kCardInfoPresentAmount)
    {
        self.presentAmount = textField.text.floatValue;
        cell.contentField.text = [NSString stringWithFormat:@"%.2f", self.presentAmount];
    }
}

@end
