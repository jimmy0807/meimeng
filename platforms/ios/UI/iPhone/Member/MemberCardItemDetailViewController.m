//
//  MemberCardItemDetailViewController.m
//  Boss
//
//  Created by mac on 15/7/31.
//  Copyright (c) 2015年 BORN. All rights reserved.
//
#import "CBMessageView.h"
#import "BSEditCell.h"
#import "ProductCountView.h"
#import "BSItemCell.h"
#import "MemberCardItemDetailViewController.h"

NS_ENUM(int, ItemSection)
{
    ItemSection_Info = 0,
    ItemSection_Count,
};

NS_ENUM(int, ItemRow)
{
    ItemRowInfo_Name = 0,
    ItemRowInfo_ItemCount,
    ItemRowInfo_StandardPrice,
    ItemRowInfo_BuyPrice,
    ItemRowInfo_Discount,
    ItemRowInfo_FinalPrice,
    ItemRowInfo_Count
};

#define kBottomViewHeight  73
#define kMarginSize 20
#define kPicHeight  240
#define kNameHeight 60
#define kOtherHeight 50

@interface MemberCardItemDetailViewController ()<UITableViewDataSource,UITableViewDelegate,ProductCountViewDelegate,UITextFieldDelegate,BNRightButtonItemDelegate>
{
    CGFloat scale;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSMutableDictionary *cacheParams;
@end

@implementation MemberCardItemDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cacheParams = [[NSMutableDictionary alloc]init];
    
    scale = [self.project.projectTotalPrice doubleValue] / [self.project.projectPriceUnit doubleValue];
    
    [self initNavigationBar];
    
    [self registerNofitificationForMainThread:kBSFetchTotalPriceRequest];
}

-(void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSFetchTotalPriceRequest])
    {
        if([[notification.userInfo objectForKey:@"rc"] integerValue] ==0 )
        {
            CGFloat priceUnit = [self.project.projectPriceUnit doubleValue];
            if ( priceUnit )
            {
                scale = [self.project.projectTotalPrice floatValue] / priceUnit;
            }
        }
    }
}

#pragma initNavigationBar
- (void)initNavigationBar
{
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    
    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc]initWithTitle:@"确定"];
    rightButtonItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    self.navigationItem.title = @"项目详情";
}

#pragma UITableViewDelegate UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ItemRowInfo_Count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( indexPath.row == ItemRowInfo_Name )
    {
        BSItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemNameCell"];
        if(cell==nil)
        {
            cell = [[BSItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"itemNameCell"];
        }
        
        cell.detailLabel.text = self.project.detailInfo;
        cell.titleLabel.text = self.project.projectName;
        
        [cell.itemImageView sd_setImageWithURL:[NSURL URLWithString:self.project.item.imageSmallUrl] placeholderImage:[UIImage imageNamed:@"project_item_default_48_36"]];
        
        return cell;
    }
    else if (indexPath.row == ItemRowInfo_ItemCount )
    {
        static NSString *cell_pic = @"cell_count";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_pic];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_pic];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginSize, (kOtherHeight - 20)/2.0, 100, 20)];
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.text = @"数量";
            [cell.contentView addSubview:nameLabel];
            
            int i = [self.project.projectCount integerValue];
            ProductCountView *countView = [[ProductCountView alloc] initWithPoint:CGPointMake(self.tableView.frame.size.width - 3*36-kMarginSize, (kOtherHeight - 27)/2.0) count:i>0?i:1];
            countView.delegate = self;
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
        static NSString *cellIdentifier = @"infoCell";
        BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell==nil)
        {
            cell = [[BSEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        if ( indexPath.row == ItemRowInfo_StandardPrice )
        {
            cell.titleLabel.text = @"标准价";
            cell.contentField.text = [NSString stringWithFormat:@"%@",self.project.projectPriceUnit];
            cell.contentField.enabled = NO;
            cell.arrowImageView.hidden = YES;
        }
        else if ( indexPath.row == ItemRowInfo_BuyPrice )
        {
            cell.titleLabel.text = @"购买单价";
            cell.contentField.text = self.project.projectManualPrice;
            cell.contentField.placeholder = [NSString stringWithFormat:@"%@",self.project.projectPriceUnit];
            cell.contentField.enabled = YES;
            cell.contentField.delegate = self;
            cell.contentField.keyboardType = UIKeyboardTypeDecimalPad;
            cell.arrowImageView.hidden = NO;
            cell.contentField.tag = indexPath.section * 1000 + indexPath.row;
        }
        else if ( indexPath.row == ItemRowInfo_Discount )
        {
            cell.titleLabel.text = @"手动折扣";
            if ( [self.project.discount integerValue] > 0 )
            {
                cell.contentField.text = [NSString stringWithFormat:@"%@",self.project.discount];
            }
            else
            {
                cell.contentField.text = @"";
            }
            
            cell.contentField.enabled = YES;
            cell.contentField.placeholder = @"10";
            cell.contentField.delegate = self;
            cell.contentField.keyboardType = UIKeyboardTypeDecimalPad;
            cell.arrowImageView.hidden = NO;
            cell.contentField.tag = indexPath.section * 1000 + indexPath.row;
        }
        else if ( indexPath.row == ItemRowInfo_FinalPrice )
        {
            cell.titleLabel.text = @"小计";
            cell.contentField.text = [[BSCoreDataManager currentManager] calculateMemberCardBuyPrice:self.project];;
            cell.arrowImageView.hidden = YES;
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == ItemRowInfo_Name )
    {
        return kNameHeight;
    }
    else
    {
        return kOtherHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma CountViewDelegate
-(void)countChanged:(ProductCountView *)countView
{
    self.project.projectCount = [NSNumber numberWithInteger:countView.count];
    [self.tableView reloadData];
}

#pragma UITextFieldDelegate 
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger section = textField.tag / 1000;
    NSInteger row = textField.tag % 1000;
    
    if ( section == ItemSection_Info )
    {
        if ( row == ItemRowInfo_BuyPrice )
        {
            if ( string.length == 0 )
            {
                if ( textField.text.length > 0 )
                {
                    self.project.projectManualPrice = [textField.text substringToIndex:textField.text.length - 1];
                }
                else
                {
                    self.project.projectManualPrice = @"";
                }
            }
            else
            {
                self.project.projectManualPrice = [NSString stringWithFormat:@"%@%@",textField.text,string];
            }
        }
        else if ( row == ItemRowInfo_Discount )
        {
            if ( string.length == 0 )
            {
                if ( textField.text.length > 0 )
                {
                    self.project.discount = [NSNumber numberWithDouble:[[textField.text substringToIndex:textField.text.length - 1] floatValue]];
                }
                else
                {
                    self.project.discount = [NSNumber numberWithDouble:10.0];
                }
            }
            else
            {
                self.project.discount = [NSNumber numberWithDouble:[[NSString stringWithFormat:@"%@%@",textField.text,string] floatValue]];
            }
            
            if ( [self.project.discount integerValue] > 10 )
            {
                self.project.discount = [NSNumber numberWithDouble:10.0];;
                return NO;
            }
        }
        
        BSEditCell* cell = (BSEditCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:ItemRowInfo_FinalPrice inSection:ItemSection_Info]];
        cell.contentField.text = [[BSCoreDataManager currentManager] calculateMemberCardBuyPrice:self.project];
    }
    
    return YES;
}

-(void)didItemBackButtonPressed:(UIButton*)sender
{
    [self.delegate didSetProjectInfo:self.isNeedManagerCode];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -Make RightButtonItem Click
-(void)didRightBarButtonItemClick:(id)sender
{
    [self.delegate didSetProjectInfo:self.isNeedManagerCode];
    [self.navigationController popViewControllerAnimated:YES];
}

//- (BOOL)isInfoLegal
//{
//    if( [self.project.discount floatValue] > 10 )
//    {
//        CBMessageView *view = [[CBMessageView alloc]initWithTitle:@"折扣参数异常" afterTimeHide:1.5];
//        [view showInView:self.view];
//        return NO;
//    }
//    else
//    {
//        if(self.delegate!=nil&&[self.delegate respondsToSelector:@selector(didSetProjectInfo:)])
//        {
//            [self.delegate didSetProjectInfo:self.isNeedManagerCode];
//        }
//        return YES;
//    }
//}

@end
