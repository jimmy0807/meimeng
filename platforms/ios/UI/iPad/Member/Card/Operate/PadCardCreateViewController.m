//
//  PadCardCreateViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/10/28.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadCardCreateViewController.h"
#import "PadProjectConstant.h"
#import "UIImage+Resizable.h"
#import "PadCardOperateViewController.h"
#import "PadDetailInputCell.h"
#import "CBLoadingView.h"
#import "BSMemberCardOperateRequest.h"
#import "PadOperateSuccessViewController.h"

typedef enum kPadCardCreateSectionType
{
    kPadCardCreateSectionCardNum        = 0,
    kPadCardCreateSectionCardType       = 1,
    kPadCardCreateSectionCount          = 2
}kPadCardCreateSectionType;

@interface PadCardCreateViewController ()
{
    BOOL isAnimation;
    BOOL isSelectCardType;
}

@property (nonatomic, strong) CDMember *member;
@property (nonatomic, strong) NSArray *priceLists;
@property (nonatomic, strong) CDMemberPriceList *priceList;
@property (nonatomic, strong) NSString *memberCardNum;

@property (nonatomic, strong) UITableView *contentTableView;

@end


@implementation PadCardCreateViewController

- (id)initWithMember:(CDMember *)member
{
    self = [super initWithNibName:@"PadCardCreateViewController" bundle:nil];
    if (self)
    {
        self.member = member;
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
    
    [self initRandomCardNumber];
    self.priceLists = [[BSCoreDataManager currentManager] fetchCanUsePriceList];
    
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, self.view.frame.size.width, self.view.frame.size.height - kPadNaviHeight - 32.0 - 60.0 - 32.0) style:UITableViewStylePlain];
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contentTableView.backgroundColor = [UIColor clearColor];
    self.contentTableView.showsVerticalScrollIndicator = NO;
    self.contentTableView.showsHorizontalScrollIndicator = NO;
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 28.0)];
    footerView.backgroundColor = [UIColor clearColor];
    self.contentTableView.tableFooterView = footerView;
    [self.view addSubview:self.contentTableView];
    
    UIImage *naviImage = [UIImage imageNamed:@"pad_navi_background"];
    UIImageView *navi = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, naviImage.size.height)];
    navi.backgroundColor = [UIColor clearColor];
    navi.image = naviImage;
    navi.userInteractionEnabled = YES;
    [self.view addSubview:navi];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0.0, 0.0, kPadNaviHeight, kPadNaviHeight);
    closeButton.backgroundColor = [UIColor clearColor];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_close_n"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_close_h"] forState:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(didCloseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navi addSubview:closeButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadNaviHeight, 0.0, self.view.frame.size.width - 2 * kPadNaviHeight, kPadNaviHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    titleLabel.text = LS(@"PadCreateCard");
    [navi addSubview:titleLabel];
    
    CGFloat originY = self.view.frame.size.height - 32.0 - 60.0 - 32.0;
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, originY - 0.5, self.view.frame.size.width, 0.5)];
    lineImageView.backgroundColor = COLOR(220.0, 230.0, 230.0, 1.0);
    [self.view addSubview:lineImageView];
    originY += 32.0;
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.backgroundColor = [UIColor clearColor];
    confirmButton.frame = CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 60.0);
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [confirmButton setTitle:LS(@"PadConfirmButton") forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateHighlighted];
    [confirmButton addTarget:self action:@selector(didConfirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
}

- (void)initRandomCardNumber
{
//    PersonalProfile *profile = [PersonalProfile currentProfile];
//    char randomChar = 'A' + arc4random_uniform(26);
//    int charInt = (arc4random()%901) + 100;
    NSString *phoneNumber = self.member.mobile;
    if (self.member.mobile.length == 0 || [self.member.mobile isEqualToString:@"0"])
    {
        phoneNumber = [NSString stringWithFormat:@"%d", (arc4random()%9001)+1000];
    }
    NSString *substring = [phoneNumber substringWithRange:NSMakeRange(7, 4)];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyyMMdd";
    NSString* today = [dateFormat stringFromDate:[NSDate date]];
    
    self.memberCardNum = [NSString stringWithFormat:@"%@%@%02d", substring, [today substringFromIndex:2], arc4random()%100];
}

- (void)didCloseButtonClick:(id)sender
{
    [self.maskView hidden];
}

- (void)didConfirmButtonClick:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (self.memberCardNum.length < 6)
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@""
                                  message:LS(@"PadMemberCardNumberAtLeastSixCharacters")
                                  delegate:nil
                                  cancelButtonTitle:LS(@"Cancel")
                                  otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    else if (self.priceList.name.length == 0 || self.priceList.priceID.integerValue == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@""
                                  message:LS(@"PadMemberCardTypeCanNotBeNULL")
                                  delegate:nil
                                  cancelButtonTitle:LS(@"Cancel")
                                  otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (self.priceList.start_money.integerValue != 0)
    {
        PadCardOperateViewController *viewController = [[PadCardOperateViewController alloc] initWithMember:self.member priceList:self.priceList cardNumber:self.memberCardNum];
        viewController.maskView = self.maskView;
        [self.navigationController pushViewController:viewController animated:YES];
        
        return;
    }
    
    [self startMemberCardCreate];
}

- (void)startMemberCardCreate
{
    NSDictionary *params = @{@"no":self.memberCardNum, @"member_id":self.member.memberID, @"pricelist_id":self.priceList.priceID, @"now_arrears_amount":@(0), @"statement_ids":@[], @"commission_ids": @[], @"invalid_date":@(NO), @"default_code":@(NO), @"remark":@(NO)};
    
    [[CBLoadingView shareLoadingView] show];
    BSMemberCardOperateRequest *request = [[BSMemberCardOperateRequest alloc] initWithParams:params operateType:kPadMemberCardOperateCreate];
    [request execute];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSMemberCardOperateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
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
#pragma mark UITableViewDataSource && UITableViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kPadCardCreateSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kPadCardCreateSectionCardNum)
    {
        return 1;
    }
    else if (section == kPadCardCreateSectionCardType)
    {
        if (isSelectCardType)
        {
            return 2;
        }
        
        return 1;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kPadCardCreateSectionCardNum)
    {
        return kPadDetailInputCellHeight;
    }
    else if (indexPath.section == kPadCardCreateSectionCardType)
    {
        if (indexPath.row == 0)
        {
            return kPadDetailInputCellHeight;
        }
        
        return kPadPickerViewCellHeight;
    }
    
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        static NSString *CellIdentifier = @"PadDetailInputCellIdentifier";
        PadDetailInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PadDetailInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.confirmButton.alpha = 0.0;
        if (indexPath.section == kPadCardCreateSectionCardNum)
        {
            cell.delegate = nil;
            cell.titleLabel.text = LS(@"PadMemberCardNum");
            cell.contentButton.hidden = YES;
            cell.downImageView.hidden = YES;
            cell.inputTextField.enabled = YES;
            cell.inputTextField.text = self.memberCardNum;
            cell.inputTextField.placeholder = LS(@"PadMemberCardNumPlaceholder");
            cell.inputTextField.delegate = self;
        }
        else if (indexPath.section == kPadCardCreateSectionCardType)
        {
            cell.delegate = self;
            cell.titleLabel.text = LS(@"PadMemberCardType");
            cell.contentButton.hidden = NO;
            cell.downImageView.hidden = NO;
            cell.inputTextField.enabled = NO;
            cell.inputTextField.delegate = nil;
            if (self.priceList != nil)
            {
                cell.inputTextField.text = [NSString stringWithFormat:LS(@"PadPriceListStartAmount"), self.priceList.name, self.priceList.start_money.integerValue];
            }
            cell.inputTextField.placeholder = LS(@"PadMemberCardTypePlaceholder");
            if (isSelectCardType)
            {
                cell.confirmButton.alpha = 1.0;
                cell.background.image = [[UIImage imageNamed:@"pad_top_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
            }
            else
            {
                cell.background.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
            }
        }
        
        return cell;
    }
    else if (indexPath.row == 1)
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
    self.memberCardNum = textField.text;
}


#pragma mark -
#pragma mark PadDetailInputCellDelegate Methods

- (void)didShowAndHidePickerView:(PadDetailInputCell *)cell
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    isSelectCardType = !isSelectCardType;
    if (isSelectCardType)
    {
        if (self.priceList == nil && self.priceLists.count != 0)
        {
            self.priceList = [self.priceLists objectAtIndex:0];
        }
        
        [UIView animateWithDuration:0.1 animations:^{
            cell.confirmButton.alpha = 1.0;
            [self.contentTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:kPadCardCreateSectionCardType]] withRowAnimation:UITableViewRowAnimationFade];
        } completion:^(BOOL finished) {
            ;
        }];
    }
    else
    {
        cell.confirmButton.alpha = 0.0;
        [self.contentTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:kPadCardCreateSectionCardType]] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.contentTableView reloadSections:[NSIndexSet indexSetWithIndex:kPadCardCreateSectionCardType] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark -
#pragma mark PadPickerViewCellDelegate Methods

- (void)pickerView:(PadPickerViewCell *)cell selectedPriceList:(CDMemberPriceList *)priceList
{
    self.priceList = priceList;
    PadDetailInputCell *inputCell = [self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kPadCardCreateSectionCardType]];
    inputCell.inputTextField.text = [NSString stringWithFormat:LS(@"PadPriceListStartAmount"), self.priceList.name, self.priceList.start_money.integerValue];
}

@end
