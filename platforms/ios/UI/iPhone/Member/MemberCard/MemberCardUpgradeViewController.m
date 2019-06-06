//
//  MemberCardUpgradeViewController.m
//  Boss
//  卡升级
//  Created by lining on 16/4/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCardUpgradeViewController.h"
#import "BSEditCell.h"
#import "BSDatePickerView.h"
#import "NSDate+Formatter.h"
#import "BSCommonSelectedItemViewController.h"
#import "MemberCardPayViewController.h"
#import "MemberCardPayModeViewController.h"

typedef enum kSectionRow
{
    kSectionRow_cardNO,
    kSectionRow_type,
    kSectionRow_date,
    kSectionRow_num
}kSectionRow;

@interface MemberCardUpgradeViewController ()<BSDatePickerViewDelegate,BSCommonSelectedItemViewControllerDelegate>
@property (nonatomic, strong) BSDatePickerView *pickerView;
@property (nonatomic, strong) NSString *invalidDate;
@property (nonatomic, strong) CDMemberPriceList *priceList;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@end

@implementation MemberCardUpgradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;

    self.navigationItem.title = @"卡升级";
    
    self.pickerView = [BSDatePickerView createView];
    self.pickerView.datePicker.datePickerMode = UIDatePickerModeDate;
    self.pickerView.delegate = self;
    
    if (self.card.invalidDate.length != 0 && ![self.card.invalidDate isEqualToString:@"0"]) {
       self.invalidDate = self.card.invalidDate;
    }
    self.priceList = self.card.priceList;

}


- (void)setPriceList:(CDMemberPriceList *)priceList
{
    _priceList = priceList;
    if ([_priceList.priceID integerValue] == [self.card.priceList.priceID integerValue]) {
        self.nextBtn.enabled = false;
    }
    else
    {
        self.nextBtn.enabled = true;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kSectionRow_num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[BSEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentField.enabled = false;
        
    }
    cell.arrowImageView.hidden = true;
    NSInteger row = indexPath.row;
    if (row == kSectionRow_cardNO) {
        cell.titleLabel.text = @"会员卡号";
        cell.contentField.text = self.card.cardNo;
    }
    else if (row == kSectionRow_type)
    {
        cell.titleLabel.text = @"折扣方案";
        cell.contentField.placeholder = @"请选择";
        cell.contentField.text = self.priceList.name;
        cell.arrowImageView.hidden = false;
    }
    else if (row == kSectionRow_date)
    {
        cell.contentField.placeholder = @"请选择";
        cell.titleLabel.text = @"失效日期";
        cell.contentField.text = self.invalidDate;
//        if (self.card.invalidDate.length != 0 && ![self.card.invalidDate isEqualToString:@"0"]) {
//            
//            
//        }
        
    }
    
    
    return cell;
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIImageView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.selectedIndexPath = indexPath;
    if (indexPath.row == kSectionRow_type) {
        NSInteger index = -1;
//        NSMutableArray *priceListArray = [NSMutableArray array];
        NSMutableArray *priceListNames = [NSMutableArray array];
        NSArray *priceListArray = [[BSCoreDataManager currentManager] fetchCanUsePriceList];
        for (int i = 0; i < priceListArray.count; i++)
        {
            CDMemberPriceList *priceList = [priceListArray objectAtIndex:i];
            NSString *name = [NSString stringWithFormat:@"%@(%d元起充)",priceList.name, priceList.start_money.integerValue];
            [priceListNames addObject:name];
            if ([priceList.priceID integerValue] == [self.priceList.priceID integerValue])
            {
                index = i;
            }
        }
    
        BSCommonSelectedItemViewController *selectedVC = [[BSCommonSelectedItemViewController alloc] initWithNibName:NIBCT(@"BSCommonSelectedItemViewController") bundle:nil];
        selectedVC.dataArray = priceListNames;
        selectedVC.userData = priceListArray;
        selectedVC.currentSelectIndex = index;
        selectedVC.delegate = self;
        [self.navigationController pushViewController:selectedVC animated:YES];
    }
    else if (indexPath.row == kSectionRow_date)
    {
        self.pickerView.date = [NSDate dateFromString:self.invalidDate formatter:@"yyyy-MM-dd"];
        [self.pickerView show];
    }
    
    
}

#pragma mark - BSCommonSelectedItemViewControllerDelegate
-(void)didSelectItemAtIndex:(NSInteger)index userData:(id)userData
{
    NSArray *priceListArray = (NSArray *)userData;
    self.priceList = [priceListArray objectAtIndex:index];
    [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark - BSDatePickerViewDelegate
- (void)didDatePicker:(BSDatePickerView *)pickerView sureSelectedDate:(NSDate *)date
{
    self.invalidDate = [date dateStringWithFormatter:@"yyyy-MM-dd"];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kSectionRow_date inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didDatePicker:(BSDatePickerView *)pickerView cancelSelectedDate:(NSDate *)orginDate
{
//    self.invalidDate = [orginDate dateStringWithFormatter:@"yyyy-MM-dd"];
//    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kSectionRow_date inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (IBAction)nextBtnPressed:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.card.cardID forKey:@"card_id"];
    [params setObject:self.priceList.priceID forKey:@"pricelist_id"];
    
    if (self.invalidDate.length > 0)
    {
        [params setObject:self.invalidDate forKey:@"invalid_date"];
    }
    
    MemberCardPayModeViewController *payVC = [[MemberCardPayModeViewController alloc] init];
    payVC.card = self.card;
    payVC.updateParams = params;
    payVC.operateType = self.operateType;
    [self.navigationController pushViewController:payVC animated:YES];
}

#pragma mark - memory warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}




@end
