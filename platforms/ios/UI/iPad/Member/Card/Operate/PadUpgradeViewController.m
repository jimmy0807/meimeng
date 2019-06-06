//
//  PadUpgradeViewController.m
//  Boss
//
//  Created by XiaXianBing on 2016-3-15.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadUpgradeViewController.h"
#import "UIImage+Resizable.h"
#import "PadProjectConstant.h"
#import "PadCardOperateCell.h"
#import "CBLoadingView.h"
#import "BSMemberCardOperateRequest.h"
#import "PadCardOperateViewController.h"

typedef enum kPadUpgradeSectionType
{
    kPadUpgradeSectionCardNum,
    kPadUpgradeSectionCardType,
    kPadUpgradeSectionInvalidDate,
    kPadUpgradeSectionRemark,
    kPadUpgradeSectionCount
}kPadUpgradeSectionType;


@interface PadUpgradeViewController ()

@property (nonatomic, strong) CDMemberCard *memberCard;
@property (nonatomic, strong) UITableView *upgradeTableView;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) NSArray *priceLists;
@property (nonatomic, strong) NSString *remarkstr;
@property (nonatomic, assign) BOOL isSelectPriceList;
@property (nonatomic, assign) BOOL isSelectInvalidDate;
@property (nonatomic, strong) NSDate *invalidDate;
@property (nonatomic, strong) CDMemberPriceList *priceList;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end


@implementation PadUpgradeViewController

- (id)initWithMemberCard:(CDMemberCard *)memberCard
{
    self = [super initWithNibName:@"PadUpgradeViewController" bundle:nil];
    if (self)
    {
        self.memberCard = memberCard;
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"yyyy年 MM月 dd日";
        if (self.memberCard.invalidDate.length != 0)
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd";
            self.invalidDate = [formatter dateFromString:self.memberCard.invalidDate];
        }
        self.priceList = self.memberCard.priceList;
        self.priceLists = [[BSCoreDataManager currentManager] fetchCanUsePriceList];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.noKeyboardNotification = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0.0, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
    
    [self registerNofitificationForMainThread:kBSMemberCardOperateResponse];
    
    self.upgradeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, self.view.frame.size.width, IC_SCREEN_HEIGHT - kPadNaviHeight - 32.0 - 60.0 - 32.0) style:UITableViewStylePlain];
    self.upgradeTableView.backgroundColor = [UIColor clearColor];
    self.upgradeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.upgradeTableView.delegate = self;
    self.upgradeTableView.dataSource = self;
    self.upgradeTableView.showsVerticalScrollIndicator = NO;
    self.upgradeTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.upgradeTableView];
    
    CGFloat originY = self.view.frame.size.height - 32.0 - 60.0 - 32.0;
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, originY - 0.5, self.view.frame.size.width, 0.5)];
    lineImageView.backgroundColor = COLOR(220.0, 230.0, 230.0, 1.0);
    [self.view addSubview:lineImageView];
    originY += 32.0;
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmButton.backgroundColor = [UIColor clearColor];
    self.confirmButton.frame = CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 60.0);
    self.confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [self.confirmButton setTitle:LS(@"PadCardUpgradeNextStep") forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_h"] forState:UIControlStateHighlighted];
    [self.confirmButton addTarget:self action:@selector(didConfirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.confirmButton];
    
    UIImage *naviImage = [UIImage imageNamed:@"pad_navi_background"];
    UIImageView *navi = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, naviImage.size.height)];
    navi.backgroundColor = [UIColor clearColor];
    navi.image = naviImage;
    navi.userInteractionEnabled = YES;
    [self.view addSubview:navi];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, kPadNaviHeight, kPadNaviHeight);
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_close_n"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_close_h"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(didBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    backButton.alpha = 1.0;
    [navi addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadNaviHeight, 0.0, self.view.frame.size.width - 2 * kPadNaviHeight, kPadNaviHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    titleLabel.text = LS(@"PadMemberCardUpgrade");
    [navi addSubview:titleLabel];
    
    [self refreshConfirmButton];
}

- (void)refreshConfirmButton
{
    if (self.memberCard.priceList.priceID.integerValue != self.priceList.priceID.integerValue)
    {
        self.confirmButton.enabled = YES;
    }
    else
    {
        self.confirmButton.enabled = NO;
    }
}

- (void)didBackButtonClick:(id)sender
{
    [self.maskView hidden];
}

- (void)didConfirmButtonClick:(id)sender
{
    if (self.memberCard.priceList.priceID.integerValue == self.priceList.priceID.integerValue)
    {
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.memberCard.cardID forKey:@"card_id"];
    [params setObject:self.priceList.priceID forKey:@"pricelist_id"];
    if (self.invalidDate)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        [params setObject:[dateFormatter stringFromDate:self.invalidDate] forKey:@"invalid_date"];
    }
    if (self.remarkstr.length != 0)
    {
        [params setObject:self.remarkstr forKey:@"remark"];
    }
    
    PadCardOperateViewController *operateViewController = [[PadCardOperateViewController alloc] initWithMemberCard:self.memberCard params:params];
    [self.navigationController pushViewController:operateViewController animated:YES];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSMemberCardOperateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            [self.maskView hidden];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kPadUpgradeSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kPadUpgradeSectionCardType)
    {
        if (self.isSelectPriceList)
        {
            return 2;
        }
    }
    else if (section == kPadUpgradeSectionInvalidDate)
    {
        if (self.isSelectInvalidDate)
        {
            return 2;
        }
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return kPadCardOperateCellHeight;
    }
    else if (indexPath.row == 1)
    {
        return kPadPickerViewCellHeight;
    }
    
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        static NSString *CellIdentifier = @"PadCardOperateCellIdentifier";
        PadCardOperateCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PadCardOperateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.contentTextField.tag = 1000 + indexPath.section;
            cell.contentTextField.delegate = self;
        }
        
        cell.delegate = nil;
        cell.indexPath = indexPath;
        cell.downImageView.alpha = 0.0;
        cell.confirmButton.alpha = 0.0;
        cell.contentTextField.enabled = YES;
        cell.contentTextField.textAlignment = NSTextAlignmentLeft;
        [cell.contentButton setBackgroundImage:[[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)] forState:UIControlStateNormal];
        [cell.contentButton setBackgroundImage:[[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)] forState:UIControlStateHighlighted];
        if (indexPath.section == kPadUpgradeSectionCardNum)
        {
            cell.titleLabel.text = LS(@"PadMemberCard");
            cell.contentTextField.enabled = NO;
            cell.contentTextField.text = self.memberCard.cardNumber;
            cell.contentTextField.textAlignment = NSTextAlignmentCenter;
        }
        else if (indexPath.section == kPadUpgradeSectionCardType)
        {
            cell.titleLabel.text = LS(@"PadCardUpgradeCardType");
            cell.contentTextField.enabled = NO;
            cell.contentTextField.textAlignment = NSTextAlignmentCenter;
            
            cell.delegate = self;
            cell.downImageView.alpha = 1.0;
            cell.confirmButton.alpha = 0.0;
            if (self.isSelectPriceList)
            {
                cell.downImageView.alpha = 0.0;
                cell.confirmButton.alpha = 1.0;
                [cell.contentButton setBackgroundImage:[[UIImage imageNamed:@"pad_top_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)] forState:UIControlStateNormal];
                [cell.contentButton setBackgroundImage:[[UIImage imageNamed:@"pad_top_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)] forState:UIControlStateHighlighted];
            }
            
            cell.contentTextField.placeholder = LS(@"PadPickerViewModifyCardType");
            if (self.priceList)
            {
                cell.contentTextField.text = [NSString stringWithFormat:LS(@"PadPriceListStartAmount"), self.priceList.name, self.priceList.start_money.integerValue];
            }
            else
            {
                cell.contentTextField.text = @"";
            }
        }
        else if (indexPath.section == kPadUpgradeSectionInvalidDate)
        {
            cell.titleLabel.text = LS(@"PadCardOperateInvalidDate");
            cell.contentTextField.enabled = NO;
            cell.contentTextField.textAlignment = NSTextAlignmentCenter;
            
            cell.delegate = self;
            cell.downImageView.alpha = 1.0;
            cell.confirmButton.alpha = 0.0;
            if (self.isSelectInvalidDate)
            {
                cell.downImageView.alpha = 0.0;
                cell.confirmButton.alpha = 1.0;
                [cell.contentButton setBackgroundImage:[[UIImage imageNamed:@"pad_top_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)] forState:UIControlStateNormal];
                [cell.contentButton setBackgroundImage:[[UIImage imageNamed:@"pad_top_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)] forState:UIControlStateHighlighted];
            }
            
            cell.contentTextField.placeholder = LS(@"PadDatePickerSetInvalidDate");
            if (self.invalidDate)
            {
                cell.contentTextField.text = [self.dateFormatter stringFromDate:self.invalidDate];
            }
            else
            {
                cell.contentTextField.text = @"";
            }
        }
        else if (indexPath.section == kPadUpgradeSectionRemark)
        {
            cell.titleLabel.text = LS(@"PadCardOperateRemark");
            cell.contentTextField.enabled = YES;
        }
        
        return cell;
    }
    else if (indexPath.row == 1)
    {
        if (indexPath.section == kPadUpgradeSectionCardType)
        {
            static NSString *CellIdentifier = @"PadPickerViewCellIdentifier";
            PadPickerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[PadPickerViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.delegate = self;
            }
            
            [cell reloadPickerViewWithPriceLists:self.priceLists];
            if (self.priceList)
            {
                for (int i = 0; i < self.priceLists.count; i++)
                {
                    CDMemberPriceList *price = [self.priceLists objectAtIndex:i];
                    if (self.priceList.priceID.integerValue == price.priceID.integerValue)
                    {
                        [cell.pickerView selectRow:i inComponent:0 animated:NO];
                        break;
                    }
                }
            }
            else if (self.priceLists.count != 0)
            {
                [cell.pickerView selectRow:0 inComponent:0 animated:NO];
            }
            
            return cell;
        }
        else if (indexPath.section == kPadUpgradeSectionInvalidDate)
        {
            static NSString *CellIdentifier = @"PadDatePickerCellIdentifier";
            PadPickerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[PadPickerViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.delegate = self;
            }
            
            [cell reloadDatePickerWithDate:self.invalidDate];
            
            return cell;
        }
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
    if (textField.tag - 1000 == kPadUpgradeSectionRemark)
    {
        self.remarkstr = textField.text;
    }
}


#pragma mark -
#pragma mark PadCardOperateCellDelegate Methods

- (void)didContentButtonClick:(PadCardOperateCell *)cell
{
    if (cell.indexPath.section == kPadUpgradeSectionCardType)
    {
        self.isSelectPriceList = !self.isSelectPriceList;
        if (self.isSelectPriceList)
        {
            [UIView animateWithDuration:0.1 animations:^{
                cell.downImageView.alpha = 0.0;
                cell.confirmButton.alpha = 1.0;
                [self.upgradeTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:kPadUpgradeSectionCardType]] withRowAnimation:UITableViewRowAnimationTop];
            } completion:^(BOOL finished) {
                [self.upgradeTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:kPadUpgradeSectionCardType] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }];
        }
        else
        {
            cell.downImageView.alpha = 1.0;
            cell.confirmButton.alpha = 0.0;
            [self.upgradeTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:kPadUpgradeSectionCardType]] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        [self.upgradeTableView reloadSections:[NSIndexSet indexSetWithIndex:kPadUpgradeSectionCardType] withRowAnimation:UITableViewRowAnimationNone];
    }
    else if (cell.indexPath.section == kPadUpgradeSectionInvalidDate)
    {
        self.isSelectInvalidDate = !self.isSelectInvalidDate;
        if (self.isSelectInvalidDate)
        {
            if (!self.invalidDate)
            {
                self.invalidDate = [NSDate date];
            }
            
            [UIView animateWithDuration:0.1 animations:^{
                cell.downImageView.alpha = 0.0;
                cell.confirmButton.alpha = 1.0;
                [self.upgradeTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:kPadUpgradeSectionInvalidDate]] withRowAnimation:UITableViewRowAnimationTop];
            } completion:^(BOOL finished) {
                [self.upgradeTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:kPadUpgradeSectionInvalidDate] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }];
        }
        else
        {
            cell.downImageView.alpha = 1.0;
            cell.confirmButton.alpha = 0.0;
            [self.upgradeTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:kPadUpgradeSectionInvalidDate]] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        [self.upgradeTableView reloadSections:[NSIndexSet indexSetWithIndex:kPadUpgradeSectionInvalidDate] withRowAnimation:UITableViewRowAnimationNone];
    }
}


#pragma mark -
#pragma mark PadPickerViewCellDelegate Methods

- (void)pickerView:(PadPickerViewCell *)cell selectedPriceList:(CDMemberPriceList *)priceList
{
    self.priceList = priceList;
    PadCardOperateCell *operateCell = [self.upgradeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kPadUpgradeSectionCardType]];
    operateCell.contentTextField.text = [NSString stringWithFormat:LS(@"PadPriceListStartAmount"), self.priceList.name, self.priceList.start_money.integerValue];
    
    [self refreshConfirmButton];
}

- (void)datePicker:(PadPickerViewCell *)cell selectedDate:(NSDate *)date
{
    self.invalidDate = date;
    PadCardOperateCell *operateCell = [self.upgradeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kPadUpgradeSectionInvalidDate]];
    operateCell.contentTextField.text = [self.dateFormatter stringFromDate:self.invalidDate];
}

@end
