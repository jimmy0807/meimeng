//
//  CombineDetailViewController.m
//  ds
//
//  Created by lining on 2016/11/14.
//
//

#import "CombineDetailViewController.h"
#import "ItemCell.h"
#import "ItemArrowCell.h"
#import "TextFieldCell.h"
#import "MemberCheckboxCell.h"
#import "CountCell.h"
#import "SameReplaceViewController.h"



typedef enum kInfoSection
{
    kInfoSectionOne,
    kInfoSectionTwo,
    kInfoSectionThree,
    kInfoSectionFour,
    kInfoSectionFive,
    kInfoSectionSix,
    kInfoSectionNum
}kInfoSection;

typedef enum InfoSectionOneRow
{
    InfoSection_name,
    InfoSection_price,
    InfoSection_count,
    InfoSectionOneRow_num
}InfoSectionOneRow;

typedef enum InfoSectionTwoRow
{
    InfoSectionRow_more,
    InfoSectionTwoRow_num
}InfoSectionTwoRow;

typedef enum InfoSectionThreeRow
{
    InfoSectionRow_limitCount,
    InfoSectionRow_validDate,
    InfoSectionThreeRow_num,
}InfoSectionThreeRow;


typedef enum InfoSectionFourRow
{
    InfoSectionRow_replaceProject,
    InfoSectionFourRow_num
   
}InfoSectionFourRow;


typedef enum InfoSectionFiveRow
{
    InfoSectionRow_sameReplace,
    InfoSectionRow_replaceMax,
    InfoSectionRow_replaceMin,
    InfoSectionFiveRow_num
    
}InfoSectionFiveRow;



@interface CombineDetailViewController ()<CheckBoxCellDelegate,CountCellDelegate>

@end

@implementation CombineDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *backItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    backItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backItem;
    
    
    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_add_n.png"] highlightedImage:[UIImage imageNamed:@"navi_add_h.png"]];
    rightButtonItem.delegate = self;
    
//    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    self.navigationItem.title = @"组合套";
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemCell" bundle:nil] forCellReuseIdentifier:@"ItemCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemArrowCell" bundle:nil] forCellReuseIdentifier:@"ItemArrowCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextFieldCell" bundle:nil] forCellReuseIdentifier:@"TextFieldCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MemberCheckboxCell" bundle:nil] forCellReuseIdentifier:@"MemberCheckboxCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CountCell" bundle:nil] forCellReuseIdentifier:@"CountCell"];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.subItem.projectType == kPadBornCategoryProject) {
        if (self.subItem.isShowMore) {
            return kInfoSectionNum;
        }
        else
        {
            return kInfoSectionThree;
        }
    }
    else
    {
        return kInfoSectionTwo;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kInfoSectionOne) {
        return InfoSectionOneRow_num;
    }
    else if (section == kInfoSectionTwo)
    {
        return InfoSectionTwoRow_num;
    }
    else if (section == kInfoSectionThree)
    {
       return InfoSectionThreeRow_num;
    }
    else if (section == kInfoSectionFour)
    {
        return InfoSectionFourRow_num;
    }
    else if (section == kInfoSectionFive)
    {
        if (self.subItem.samePriceReplace) {
            return InfoSectionFiveRow_num;
        }
        else
        {
            return 1;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (section == kInfoSectionOne) {
        if (row == InfoSection_name) {
            ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
            
            cell.valueLabel.font = [UIFont systemFontOfSize:14];
            cell.titleLabel.font = [UIFont systemFontOfSize:16];
            cell.valueLabel.textColor = [UIColor grayColor];
            
            cell.titleLabel.text = @"产品";
            cell.valueLabel.text = self.subItem.itemName;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        else if (row == InfoSection_price)
        {
            ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
            
            cell.valueLabel.font = [UIFont systemFontOfSize:14];
            cell.titleLabel.font = [UIFont systemFontOfSize:16];
            cell.valueLabel.textColor = [UIColor grayColor];

            cell.titleLabel.text = @"价格";
            cell.valueLabel.text = [NSString stringWithFormat:@"¥%.2f",self.subItem.itemPrice];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (row == InfoSection_count)
        {
            CountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CountCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.textColor = [UIColor blackColor];
            cell.countLabel.font = [UIFont systemFontOfSize:14];
            cell.titleLabel.font = [UIFont systemFontOfSize:16];
            cell.count = self.subItem.count;
            cell.lineImgView.hidden = true;
            cell.delegate = self;
            return cell;
            
        }
    }
    else if (section == kInfoSectionTwo)
    {
        if (row == InfoSectionRow_more) {
            
            MemberCheckboxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCheckboxCell"];
            cell.titleLabel.text = @"更多设置";
            cell.titleLabel.font = [UIFont systemFontOfSize:16];
            cell.indexPath = indexPath;
            cell.delegate = self;
            cell.checkBoxImg.highlighted = self.subItem.isShowMore;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.lineImgView.hidden = true;
            return cell;
            
        }
        
    }
    else if (section == kInfoSectionThree)
    {
        if (row == InfoSectionRow_limitCount) {
            
            MemberCheckboxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCheckboxCell"];
            cell.titleLabel.text = @"有效期内不限次数使用";
            cell.titleLabel.font = [UIFont systemFontOfSize:16];
            cell.indexPath = indexPath;
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.checkBoxImg.highlighted = self.subItem.isUnlimited;
            cell.lineImgView.hidden = false;
            return cell;

        }
        else if (row == InfoSectionRow_validDate)
        {
            TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.font = [UIFont systemFontOfSize:16];
            cell.titleLabel.textColor = [UIColor blackColor];
            cell.titleLabel.text = @"有效期限（天）";
            cell.valueTextFiled.tag = 1000*section + row;
            cell.valueTextFiled.delegate = self;
            cell.valueTextFiled.keyboardType = UIKeyboardTypeNumberPad;
            
            cell.valueTextFiled.text = [NSString stringWithFormat:@"%d天",self.subItem.unlimitedDays];
            cell.lineImgView.hidden = true;
            cell.lineLeadingConstant = 15;
            return cell;
        }
    }
    else if (section == kInfoSectionFour)
    {
        if (row == InfoSectionRow_replaceProject) {
            ItemArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemArrowCell"];
            cell.nameLabel.text = @"可替换的项目";
            cell.nameLabel.font = [UIFont systemFontOfSize:16];
            cell.lineImgView.hidden = false;
            cell.lineTailingConstant = 0;
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else if (section == kInfoSectionFive)
    {
        if (row == InfoSectionRow_sameReplace) {
            
            MemberCheckboxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCheckboxCell"];
            cell.indexPath = indexPath;
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.font = [UIFont systemFontOfSize:16];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.lineImgView.hidden = false;
            cell.titleLabel.text = @"可以等价替换消耗";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.checkBoxImg.highlighted = self.subItem.samePriceReplace;
            
            if (self.subItem.samePriceReplace) {
                cell.lineImgView.hidden = false;
            }
            else
            {
                cell.lineImgView.hidden = true;
            }
            return cell;
        }
        else if (row == InfoSectionRow_replaceMax)
        {
            TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
            cell.titleLabel.text = @"项目最高价";
            cell.titleLabel.textColor = [UIColor blackColor];
            cell.titleLabel.font = [UIFont systemFontOfSize:16];
            cell.valueTextFiled.delegate = self;
            cell.valueTextFiled.tag = 1000*section + row;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.valueTextFiled.keyboardType = UIKeyboardTypeDecimalPad;
            cell.valueTextFiled.text = [NSString stringWithFormat:@"¥%.2f",self.subItem.samePriceReplaceMax];
            return cell;
            
        }
        else if (row == InfoSectionRow_replaceMin)
        {
            TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
            cell.titleLabel.textColor = [UIColor blackColor];
            cell.titleLabel.font = [UIFont systemFontOfSize:16];
            cell.valueTextFiled.tag = 1000*section + row;
            cell.titleLabel.text = @"项目最低价";
            cell.valueTextFiled.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.valueTextFiled.keyboardType = UIKeyboardTypeDecimalPad;
            cell.valueTextFiled.text = [NSString stringWithFormat:@"¥%.2f",self.subItem.samePriceReplaceMin];
            return cell;
        }
    }

    return nil;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if (section == kInfoSectionThree) {
//        return 30;
//    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIImageView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == kInfoSectionFour) {
        if (row == InfoSectionRow_sameReplace) {
            SameReplaceViewController *sameReplaceVC = [[SameReplaceViewController alloc] init];
            sameReplaceVC.sameItems = self.subItem.sameItems;
            [self.navigationController pushViewController:sameReplaceVC animated:YES];
        }
    }
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
    if (section == kInfoSectionThree) {
        if (row == InfoSectionRow_validDate) {
            NSInteger day = textField.text.integerValue;
            self.subItem.unlimitedDays = day;
            textField.text = [NSString stringWithFormat:@"%d天",day];
        }
    }
    else if (section == kInfoSectionFive)
    {
        if (row == InfoSectionRow_replaceMax) {
            CGFloat maxPrice = textField.text.floatValue;
            self.subItem.samePriceReplaceMax = maxPrice;
            textField.text = [NSString stringWithFormat:@"¥%.2f",maxPrice];
        }
        else if (row == InfoSectionRow_replaceMin)
        {
            CGFloat minPrice = textField.text.floatValue;
            self.subItem.samePriceReplaceMin = minPrice;
            textField.text = [NSString stringWithFormat:@"¥%.2f",minPrice];
        }
    }
}

#pragma mark - CountCellDelegate
- (void)didCountChanged:(NSInteger)count
{
    self.subItem.count = count;
}

#pragma mark - CheckBoxCellDelegate
- (void)didCheckboxSelected:(bool)selected indexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == kInfoSectionTwo) {
        if (row == InfoSectionRow_more) {
            self.subItem.isShowMore = selected;
            [self.tableView reloadData];
            if (self.subItem.isShowMore) {
                NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSetWithIndex:kInfoSectionThree];
                [indexSet addIndex:kInfoSectionFour];
                [indexSet addIndex:kInfoSectionFive];
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }
    else if (section == kInfoSectionThree)
    {
        self.subItem.isUnlimited = selected;
    }
    else if (section == kInfoSectionFive)
    {
        if (row == InfoSectionRow_sameReplace) {
            self.subItem.samePriceReplace = selected;
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:kInfoSectionFive] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kEditSubItemDone" object:nil];
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
