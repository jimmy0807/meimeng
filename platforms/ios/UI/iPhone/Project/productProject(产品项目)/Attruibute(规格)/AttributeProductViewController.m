//
//  AttributeItemProductViewController.m
//  ds
//
//  Created by lining on 2016/11/8.
//
//

#import "AttributeProductViewController.h"
#import "BSProjectItem.h"
#import "BSProjectItemCreateRequest.h"
#import "ScanInputCell.h"
#import "ItemCell.h"
#import "ItemArrowCell.h"
#import "TextFieldCell.h"
#import "BNScanCodeViewController.h"
#import "CBLoadingView.h"
#import "OnHandViewController.h"

typedef enum kItemRow
{
    kItemRowInfo,
    kItemRowStandardPrice,
    kItemRowSalePrice,
    kItemRowBarCode,
    kItemRowInnerCode,
    kItemRowOnHand,
    kItemRowNum
}kTemplateListItemRow;

@interface AttributeProductViewController ()<ScanInputCellDelegate,BNScanCodeDelegate>
@property (nonatomic, strong) NSMutableArray *bsProjectItems;
@property (nonatomic, strong) NSMutableDictionary *expandDict;
@property (nonatomic, strong) NSIndexPath *scanIndexPath;
@property (nonatomic, assign) NSInteger requestCount;
@property (nonatomic, assign) BOOL isRequestSuccess;
@property (nonatomic, strong) NSString *errorMessage;
@end

@implementation AttributeProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CBBackButtonItem *backItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    backItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backItem;
    
    
    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc] initWithTitle:@"保存"];
    rightButtonItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    self.navigationItem.title = @"规格详情";
    
    self.bsProjectItems = [NSMutableArray array];
    
    for (int i = 0; i < self.projectTemplate.projectItems.count; i++)
    {
        CDProjectItem *projectItem = [self.projectTemplate.projectItems objectAtIndex:i];
        BSProjectItem *bsProjectItem = [[BSProjectItem alloc] init];
        bsProjectItem.projectID = projectItem.itemID;
        bsProjectItem.projectName = projectItem.itemName;
        bsProjectItem.projectPrice = projectItem.totalPrice.floatValue;
        bsProjectItem.projectType = projectItem.type;
        bsProjectItem.posCategory = projectItem.category;
        bsProjectItem.barcode = projectItem.barcode;
        bsProjectItem.defaultCode = projectItem.defaultCode;
        bsProjectItem.standardPrice = projectItem.stanardPrice.floatValue;
        bsProjectItem.onHandCount = projectItem.inHandAmount.integerValue;
        
        NSMutableString *attributName = [NSMutableString string];
        for (CDProjectAttributeValue *attributeValue in projectItem.attributeValues) {
            [attributName appendString:[NSString stringWithFormat:@"%@ ",attributeValue.attributeValueName]];
        }
        bsProjectItem.attributeName = attributName;
        
        [self.bsProjectItems addObject:bsProjectItem];
    }
    
    [self registerNofitificationForMainThread:kBSProjectItemCreateResponse];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemCell" bundle:nil] forCellReuseIdentifier:@"ItemCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemArrowCell" bundle:nil] forCellReuseIdentifier:@"ItemArrowCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ScanInputCell" bundle:nil] forCellReuseIdentifier:@"ScanInputCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextFieldCell" bundle:nil] forCellReuseIdentifier:@"TextFieldCell"];
    
    UIView *view = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    view.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = view;
    self.tableView.tableFooterView = view;
    
    self.expandDict = [NSMutableDictionary dictionary];
    
}

#pragma mark - NavigationAction
- (void)didRightBarButtonItemClick:(id)sender
{
    self.requestCount = 0;
    self.isRequestSuccess = YES;
    NSMutableArray *requests = [NSMutableArray array];
    for (int i = 0; i < self.projectTemplate.projectItems.count; i++)
    {
        CDProjectItem *projectItem = [self.projectTemplate.projectItems objectAtIndex:i];
        BSProjectItem *bsProjectItem = [self.bsProjectItems objectAtIndex:i];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if (bsProjectItem.barcode.length != 0 && ![bsProjectItem.barcode isEqualToString:@"0"] && ![bsProjectItem.barcode isEqualToString:projectItem.barcode])
        {
            [params setObject:bsProjectItem.barcode forKey:@"barcode"];
        }
        if (bsProjectItem.defaultCode.length != 0 && ![bsProjectItem.defaultCode isEqualToString:@"0"] && ![bsProjectItem.defaultCode isEqualToString:projectItem.defaultCode])
        {
            [params setObject:bsProjectItem.defaultCode forKey:@"default_code"];
        }
        
        if (bsProjectItem.standardPrice - projectItem.stanardPrice.floatValue > 0.001) {
            [params setObject:@(bsProjectItem.standardPrice) forKey:@"standard_price"];
        }
        
        if (bsProjectItem.projectPrice - projectItem.totalPrice.floatValue > 0.001) {
            [params setObject:@(bsProjectItem.projectPrice) forKey:@"lst_price"];
        }
        
        if (params.allKeys.count != 0)
        {
            [params setObject:self.projectTemplate.bornCategory forKey:@"born_category"];
            BSProjectItemCreateRequest *request = [[BSProjectItemCreateRequest alloc] initWithProjectItemID:bsProjectItem.projectID params:params];
            [requests addObject:request];
        }
    }
    
    self.requestCount = requests.count;
    if (self.requestCount != 0)
    {
        [[CBLoadingView shareLoadingView] show];
        for (BSProjectItemCreateRequest *request in requests)
        {
            [request execute];
        }
    }
}

#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSProjectItemCreateResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            self.requestCount --;
        }
        else
        {
            self.requestCount --;
            self.isRequestSuccess = NO;
            [[CBLoadingView shareLoadingView] hide];
            if([[notification.userInfo stringValueForKey:@"rm"] length] != 0)
            {
                self.errorMessage = [notification.userInfo stringValueForKey:@"rm"];
            }
        }
        
        if (self.requestCount == 0)
        {
            [[CBLoadingView shareLoadingView] hide];
            if (self.isRequestSuccess)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                if (self.errorMessage.length != 0)
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                        message:self.errorMessage
                                                                       delegate:nil
                                                              cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                              otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
        }
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.bsProjectItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSNumber *expand = [self.expandDict objectForKey:@(section)];
    if (expand.boolValue) {
        return kItemRowNum;
    }
    else
    {
        return 1;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    BSProjectItem *item = [self.bsProjectItems objectAtIndex:indexPath.section];
    if (row == kItemRowInfo) {
        
        ItemArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemArrowCell"];
        cell.nameLabel.text = item.attributeName;
        cell.arrowImgView.transform = CGAffineTransformIdentity;
        cell.backgroundColor = [UIColor whiteColor];
        cell.valueLabel.text = @"";
        cell.nameLabel.font = [UIFont systemFontOfSize:16];
        cell.nameLabel.textColor = [UIColor blackColor];
        NSNumber *expand = [self.expandDict objectForKey:@(section)];
        if (expand.boolValue) {
            cell.arrowImgView.transform = CGAffineTransformRotate(cell.arrowImgView.transform, -M_PI_2);
        }
        else
        {
            cell.arrowImgView.transform = CGAffineTransformRotate(cell.arrowImgView.transform, M_PI_2);
        }
        cell.lineLeadingConstant = 0.0f;
        cell.lineTailingConstant = 0.0f;
        return cell;
    }
    else if (row == kItemRowOnHand)
    {
        ItemArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemArrowCell"];
        cell.nameLabel.text = @"在手数量";
        cell.valueLabel.text = [NSString stringWithFormat:@"%d",item.onHandCount];
        cell.arrowImgView.transform = CGAffineTransformIdentity;
        cell.backgroundColor = COLOR(251, 251, 251, 1);
        cell.lineLeadingConstant = 0.0f;
        cell.lineTailingConstant = 0.0f;
        
        cell.nameLabel.font = [UIFont systemFontOfSize:15];
        cell.nameLabel.textColor = COLOR(72, 72, 72, 72);
        return cell;
    }
    else if (row == kItemRowSalePrice)
    {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
        cell.titleLabel.text = @"销售价格";
        cell.valueTextFiled.delegate = self;
        cell.valueTextFiled.tag = 1000 *section + row;
        cell.valueTextFiled.text = [NSString stringWithFormat:@"¥%.2f",item.projectPrice];
        cell.backgroundColor = COLOR(251, 251, 251, 1);
        
        cell.titleLabel.font = [UIFont systemFontOfSize:15];
        cell.titleLabel.textColor = COLOR(72, 72, 72, 1);
        cell.valueTextFiled.textColor = [UIColor grayColor];
        return cell;
        
    }
    else if (row == kItemRowStandardPrice)
    {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
        cell.titleLabel.text = @"成本价格";
        cell.valueTextFiled.delegate = self;
        cell.valueTextFiled.tag = 1000 *section + row;
        
        cell.valueTextFiled.text = [NSString stringWithFormat:@"¥%.2f",item.standardPrice];
        
        cell.backgroundColor = COLOR(251, 251, 251, 1);
        
        cell.titleLabel.font = [UIFont systemFontOfSize:15];
        cell.titleLabel.textColor = COLOR(72, 72, 72, 1);
        cell.valueTextFiled.textColor = [UIColor grayColor];
        
        return cell;
    }
    else if (row == kItemRowBarCode)
    {
        ScanInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScanInputCell"];
        cell.delegate = self;
        cell.titleLabel.text = @"条形码";
        cell.titleLabel.font = [UIFont systemFontOfSize:15];
        cell.valueTextField.delegate = self;
        cell.valueTextField.tag = 1000 *section + row;
        cell.valueTextField.text = item.barcode;
        cell.backgroundColor = COLOR(251, 251, 251, 1);
        cell.lineTailingConstant = 15;
        cell.titleLabel.font = [UIFont systemFontOfSize:15];
        cell.titleLabel.textColor = COLOR(72, 72, 72, 1);
        cell.valueTextField.textColor = [UIColor grayColor];
        return cell;
    }
    else if (row == kItemRowInnerCode)
    {
        ScanInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScanInputCell"];
        cell.delegate = self;
        cell.titleLabel.text = @"内部编号";
        cell.titleLabel.font = [UIFont systemFontOfSize:15];
        cell.valueTextField.delegate =self;
        cell.valueTextField.tag = 1000 *section + row;
        cell.valueTextField.text = item.defaultCode;
        cell.backgroundColor = COLOR(251, 251, 251, 1);
        cell.lineTailingConstant = 15;
        cell.titleLabel.font = [UIFont systemFontOfSize:15];
        cell.titleLabel.textColor = COLOR(72, 72, 72, 1);
        cell.valueTextField.textColor = [UIColor grayColor];
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.backgroundColor = [UIColor clearColor];
    return imgView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (row == kItemRowInfo) {
        NSNumber *expand = [self.expandDict objectForKey:@(section)];
        [self.expandDict setObject:@(!expand.boolValue) forKey:@(section)];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (row == kItemRowOnHand)
    {
        OnHandViewController *onHandVC = [[OnHandViewController alloc] init];
        onHandVC.projectItem = [self.projectTemplate.projectItems objectAtIndex:section];
        [self.navigationController pushViewController:onHandVC animated:YES];
    }

}

#pragma mark - ScanInputCellDelegate
- (void)didScanBtnPressedAtIndexPath:(NSIndexPath *)indexPath
{
    self.scanIndexPath = indexPath;
    BNScanCodeViewController *viewController = [[BNScanCodeViewController alloc] initWithDelegate:self];
    [self.navigationController pushViewController:viewController animated:NO];
}

#pragma mark - BNScanCodeDelegate
- (void)scanCodeViewController:(BNScanCodeViewController *)viewController didScanSuccess:(NSString *)result
{
    NSInteger section = self.scanIndexPath.section;
    NSInteger row = self.scanIndexPath.row;
    
    BSProjectItem *item = [self.bsProjectItems objectAtIndex:section];
    
    if (row == kItemRowBarCode) {
        item.barcode = result;
    }
    else if (row == kItemRowInnerCode)
    {
        item.defaultCode =  result;
    }
     [self.tableView reloadRowsAtIndexPaths:@[self.scanIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger section = textField.tag / 1000;
    NSInteger row = textField.tag % 1000;
    BSProjectItem *item = [self.bsProjectItems objectAtIndex:section];
    
    if (row == kItemRowStandardPrice) {
        CGFloat standardPrice = [textField.text floatValue];
        item.standardPrice = standardPrice;
        textField.text = [NSString stringWithFormat:@"¥%.2f",item.standardPrice];
    }
    else if (row == kItemRowSalePrice)
    {
        CGFloat salePrice = [textField.text floatValue];
        item.projectPrice = salePrice;
        textField.text = [NSString stringWithFormat:@"¥%.2f",item.projectPrice];
    }
    else if (row == kItemRowInnerCode)
    {
        item.defaultCode = textField.text;
    }
    else if (row == kItemRowBarCode)
    {
        item.barcode = textField.text;
    }
}



#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
