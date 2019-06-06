//
//  ProductDetailViewController.m
//  Boss
//
//  Created by lining on 15/6/23.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "UIImage+Resizable.h"
#import "AddProductViewController.h"
#import "ProductCountView.h"
#import "BSEditCell.h"
#import "BSItemCell.h"
#import "BSFetchPurchaseTaxRequest.h"
#import "DatePickerView.h"
#import "BSCommonSelectedItemViewController.h"
#import "CreatePurchaseOrderViewController.h"

#define kBottomViewHeight  73
#define kMarginSize 20
#define kPicHeight  240
#define kNameHeight 60
#define kOtherHeight 50



typedef enum cell_senction
{
    cell_section_one,
    cell_section_two,
    cell_section_sum
}cell_section;

typedef enum section_one_row
{
    section_one_row_name,
    section_one_row_count,
    section_one_row_price,
    section_two_row_unit,
    
    section_one_row_num,
    section_one_row_type,
    section_one_row_pic,
}section_one_row;


typedef enum section_two_row
{
    section_one_row_date,
    section_one_row_tax,
    section_one_row_totalmoney,
   
    section_two_row_num,
    section_two_row_onhand,
    section_two_row_forecast,
}section_two_row;

@interface ProductDetailViewController ()<UITableViewDataSource, UITableViewDelegate,ProductCountViewDelegate,DatePickerViewDelegate,BSCommonSelectedItemViewControllerDelegate>
{
    BOOL isFirstLoadView;
}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableDictionary *cacheParams;
@property(nonatomic, strong) DatePickerView *pickerView;
@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR(245, 245, 245, 1);
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    self.navigationItem.title = @"产品详情";
    isFirstLoadView = true;
    
    self.cacheParams = [NSMutableDictionary dictionary];
    
    self.hideKeyBoardWhenClickEmpty = true;
    
    if (self.orderLine) {
        self.type = OrderLine_type_edit;
    }
    else
    {
        self.orderLine = [[BSCoreDataManager currentManager] insertEntity:@"CDPurchaseOrderLine"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        self.orderLine.date = [dateFormatter stringFromDate:[NSDate date]];
        self.orderLine.product = self.item;
        self.orderLine.price = @0.0;
        self.orderLine.count = [NSNumber numberWithInt:1];
        self.type = OrderLine_type_create;
        [[BSCoreDataManager currentManager] save:nil];
    }
    //默认税率
    if (self.orderLine.tax == nil) {
        self.orderLine.tax = [[BSCoreDataManager currentManager] findEntity:@"CDPurchaseOrderTax" withValue:@2 forKey:@"tax_id"];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (isFirstLoadView) {
        
        [self initView];
        isFirstLoadView = false;
    }
}
#pragma mark - init view & data
- (void)initView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kBottomViewHeight) style:UITableViewStylePlain];
    //    self.tableView.bounces = false;
    self.tableView.autoresizingMask = 0xff;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self initBottomView];
}

- (void)initBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - kBottomViewHeight, self.view.frame.size.width, kBottomViewHeight)];
    bottomView.autoresizingMask = 0xff;
    [self.view addSubview:bottomView];
    
    UIImage *normalImg = [[UIImage imageNamed:@"order_btn_add.png"] imageResizableWithCapInsets:UIEdgeInsetsMake(10, 160, 10, 20)];
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.autoresizingMask = 0xff;
    bottomBtn.frame = CGRectMake(kMarginSize, (kBottomViewHeight - normalImg.size.height)/2.0, self.view.frame.size.width - 2*kMarginSize, normalImg.size.height);
    if (self.type == OrderLine_type_create) {
        [bottomBtn setTitle:@"添加商品" forState:UIControlStateNormal];
    }
    else
    {
        [bottomBtn setTitle:@"确定" forState:UIControlStateNormal];
    }
    [bottomBtn addTarget:self action:@selector(bottomBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [bottomBtn setBackgroundImage:normalImg forState:UIControlStateNormal];
    [bottomView addSubview:bottomBtn];
    
}

- (void)showDatePicker
{
    if (self.pickerView) {
        
        [self.pickerView show];
        return;
    }
    NSString *dateString = [self.orderLine.date substringToIndex:10];;
    
    self.pickerView = [[DatePickerView alloc] initWithFrame:self.view.bounds dateString:dateString delegate:self];
    [self.view addSubview:self.pickerView];
    [self.pickerView show];
}

- (void)initData
{
    
}

#pragma mark - CBBackButtonItemDelegate
-(void)didItemBackButtonPressed:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.type == OrderLine_type_create) {
        [[BSCoreDataManager currentManager] deleteObject:self.orderLine];
        [[BSCoreDataManager currentManager] save:nil];
    }
    else
    {
        [[BSCoreDataManager currentManager] rollback];
    }
}

#pragma mark - button action
-(void)bottomBtnPressed:(UIButton *)btn
{
    NSLog(@"bottom button pressed");
//    self.orderLine.totalMoney = [NSNumber numberWithFloat:[self.orderLine.count integerValue] * [self.orderLine.price floatValue]];
    [self calculatePrice];
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[CreatePurchaseOrderViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
            break;
        }
    }
    if (self.type == OrderLine_type_create) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCreateOrderLine object:self.orderLine];
    }
    else if (self.type == OrderLine_type_edit)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kEidtOrderLine object:self.orderLine];
    }
    
}

#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return cell_section_sum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == cell_section_one) {
        return section_one_row_num;
    }
    else if (section == cell_section_two)
    {
        return section_two_row_num;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == cell_section_one && row == section_one_row_name)
    {
        static NSString *cell_name = @"cell_name";
        BSItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_name];
        if (cell == nil) {
            cell = [[BSItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_name];
        }
        cell.arrowImageView.hidden = true;
        cell.titleLabel.text = self.orderLine.product.itemName;
        cell.detailLabel.text = [NSString stringWithFormat:@"内部编号: %@",self.orderLine.product.defaultCode];
        [cell.itemImageView sd_setImageWithURL:[NSURL URLWithString:self.orderLine.product.imageSmallUrl] placeholderImage:[UIImage imageNamed:@"project_item_default_48_36"]];
      
        return cell;
        
    }
    else if (section == cell_section_one && row == section_one_row_count)
    {
        static NSString *cell_pic = @"cell_count";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_pic];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_pic];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginSize, (kOtherHeight - 20)/2.0, 100, 20)];
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.text = @"数量";
            [cell.contentView addSubview:nameLabel];
            
            ProductCountView *countView = [[ProductCountView alloc] initWithPoint:CGPointMake(self.tableView.frame.size.width - 3*36-kMarginSize, (kOtherHeight - 27)/2.0) count:[self.orderLine.count integerValue]];
            countView.delegate = self;
           
            countView.countField.tag = 1001;
            [cell.contentView addSubview:countView];
            
            UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kOtherHeight - 0.5, IC_SCREEN_WIDTH, 0.5)];
            lineImageView.backgroundColor = [UIColor clearColor];
            lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
            [cell.contentView addSubview:lineImageView];
        }
        return cell;
    }
    else
    {
        static NSString *otherIdentifier = @"otherIdentifier";
        BSEditCell *otherCell = [tableView dequeueReusableCellWithIdentifier:otherIdentifier];
        if (otherCell == nil) {
            otherCell = [[BSEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:otherIdentifier];
            otherCell.contentField.delegate = self;
        }
        otherCell.contentField.enabled = false;
        if (section == cell_section_one)
        {
//            otherCell.arrowImageView.hidden = false;
//            otherCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (row == section_one_row_price) {
                otherCell.arrowImageView.hidden = true;
                otherCell.titleLabel.text = @"单价(￥)";
                otherCell.contentField.enabled = true;
                otherCell.contentField.text = [NSString stringWithFormat:@"￥%.2f",[self.orderLine.price floatValue]];
                otherCell.contentField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                otherCell.contentField.clearsOnBeginEditing = true;
                otherCell.contentField.placeholder = @"请输入购买金额...";
                
            
            }
            else if (row == section_two_row_unit)
            {
                otherCell.arrowImageView.hidden = true;
                otherCell.titleLabel.text = @"计量单位";
                otherCell.contentField.text = self.orderLine.product.uomName;
            }
        }
        else if (section == cell_section_two)
        {
//            otherCell.arrowImageView.hidden = true;
            otherCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (row == section_two_row_onhand) {
                otherCell.titleLabel.text = @"在手数量";
                otherCell.contentField.text = [NSString stringWithFormat:@"%@",self.orderLine.product.inHandAmount];
            }
            else if (row == section_two_row_forecast)
            {
                otherCell.titleLabel.text = @"预测数量";
                otherCell.contentField.text = [NSString stringWithFormat:@"%@",self.orderLine.product.forecastAmount];
            }
            
            if (row == section_one_row_date) {
                otherCell.arrowImageView.hidden = true;
                otherCell.titleLabel.text = @"计划日期";
                otherCell.contentField.placeholder = @"选择日期...";
                otherCell.contentField.text = self.orderLine.date;
            }
            else if (row == section_one_row_tax)
            {
                otherCell.arrowImageView.hidden = false;
                otherCell.titleLabel.text = @"税";
                otherCell.contentField.text = self.orderLine.tax.name;
            }
            else if (row == section_one_row_totalmoney)
            {
                otherCell.arrowImageView.hidden = true;
                otherCell.titleLabel.text = @"小计";
                otherCell.contentField.text = [NSString stringWithFormat:@"￥%.2f",[self.orderLine.total_untax floatValue]];
            }

        }
        return otherCell;
    }
    
//    else if (section == cell_section_one && row == section_one_row_pic) {
//        static NSString *cell_pic = @"cell_pic";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_pic];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_pic];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kPicHeight)];
//            imgView.tag = 101;
//            [cell.contentView addSubview:imgView];
//            
//            UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kPicHeight - 0.5, IC_SCREEN_WIDTH, 0.5)];
//            lineImageView.backgroundColor = [UIColor clearColor];
//            lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
//            [cell.contentView addSubview:lineImageView];
//        }
//        return cell;
//        
//    }
//
//    else if (section == cell_section_one && row == section_one_row_type)
//    {
//        static NSString *cell_pic = @"cell_type";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_pic];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_pic];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginSize, (kOtherHeight - 20)/2.0, 100, 20)];
//            nameLabel.backgroundColor = [UIColor clearColor];
//            nameLabel.text = @"类型";
//            [cell.contentView addSubview:nameLabel];
//            
//            UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - kMarginSize-100, (kOtherHeight - 20)/2.0, 100, 20)];
//            typeLabel.backgroundColor = [UIColor clearColor];
//            typeLabel.textAlignment = NSTextAlignmentRight;
//            typeLabel.font = [UIFont systemFontOfSize:14];
//            typeLabel.textColor = [UIColor grayColor];
//            typeLabel.tag = 101;
//            [cell.contentView addSubview:typeLabel];
//            
//            UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kOtherHeight - 0.5, IC_SCREEN_WIDTH, 0.5)];
//            lineImageView.backgroundColor = [UIColor clearColor];
//            lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
//            [cell.contentView addSubview:lineImageView];
//            
//        }
//        
//        UILabel *typeLabel = (UILabel *)[cell.contentView viewWithTag:101];
//        typeLabel.text = LS(self.item.type);
//        return cell;
//    }
    
    return nil;

}

#pragma mark - DatePickerViewDelegate

- (void)didValueChanged:(NSString *)dateString
{
    self.orderLine.date = dateString;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:section_one_row_date inSection:cell_section_two]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.orderLine.price = [NSNumber numberWithFloat:[textField.text floatValue]];
    textField.text = [NSString stringWithFormat:@"￥%.2f",[self.orderLine.price floatValue]];
    [self calculatePrice];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:section_one_row_totalmoney inSection:cell_section_two]] withRowAnimation:UITableViewRowAnimationNone];
    
}

#pragma mark - ProductCountViewDelegate
-(void)countChanged:(ProductCountView *)countView
{
    self.orderLine.count = [NSNumber numberWithInt:countView.count];
//    self.orderLine.price = [NSNumber numberWithFloat:[textField.text floatValue]];
    [self calculatePrice];
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:section_one_row_totalmoney inSection:cell_section_two]] withRowAnimation:UITableViewRowAnimationNone];
   
}

#pragma mark - calculatePrice
 - (void)calculatePrice
{
    CGFloat totalMoney = [self.orderLine.price floatValue] * [self.orderLine.count integerValue];
    CGFloat total_untax = totalMoney/(1+[self.orderLine.tax.amount floatValue]);
    CGFloat total_tax = totalMoney - total_untax;
    
    self.orderLine.totalMoney = [NSNumber numberWithFloat:totalMoney];
    self.orderLine.total_untax = [NSNumber numberWithFloat:total_untax];
    self.orderLine.total_tax = [NSNumber numberWithFloat:total_tax];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
//
//    if (indexPath.row == cell_row_pic) {
//        return kPicHeight;
//    }
//    else if (indexPath.row == cell_row_name)
//    {
//        return kNameHeight;
//    }
//    else
//    {
//        return kOtherHeight;
//    }
    if (section == cell_section_one && row == section_one_row_name) {
        return kNameHeight;
    }
    else
    {
        return kOtherHeight;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //    return kSearchBarHeight;
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIImageView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == cell_section_two) {
        if (indexPath.row == section_one_row_date) {
            [self showDatePicker];
        }
        else if (indexPath.row == section_one_row_tax) {
            NSInteger currentIndex = -1;
            NSArray* taxes = [[BSCoreDataManager currentManager] fetchPurchaseOrderTaxs];
            if ( self.orderLine.tax )
            {
                currentIndex = [taxes indexOfObject:self.orderLine.tax];
            }
            
            NSMutableArray* taxNameList = [NSMutableArray array];
            for (CDPurchaseOrderTax* tax in taxes )
            {
                [taxNameList addObject:tax.name];
            }

            BSCommonSelectedItemViewController* v = [[BSCommonSelectedItemViewController alloc] initWithNibName:NIBCT(@"BSCommonSelectedItemViewController") bundle:nil];
            v.currentSelectIndex = currentIndex;
            v.dataArray = taxNameList;
            v.delegate = self;
            v.userData = taxes;
            [self.navigationController pushViewController:v animated:YES];
        }
    }
}


#pragma mark - BSCommonSelectedItemViewControllerDelegate
-(void)didSelectItemAtIndex:(NSInteger)index userData:(id)userData
{
    NSArray* taxesList = (NSArray*)userData;
    CDPurchaseOrderTax *tax = ((CDPurchaseOrderTax*)taxesList[index]);
    self.orderLine.tax = tax;
//    BSEditCell *cell = (BSEditCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:section_one_row_tax inSection:cell_section_one]];
//    cell.contentField.text = tax.name;
    
    [self calculatePrice];
    [self.tableView reloadData];
//    self.orderLine.totalMoney = ([self.orderLine.totalMoney floatValue] /(1+([tax.amount floatValue] )))
}

#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


-(void)dealloc
{
   
}


@end
