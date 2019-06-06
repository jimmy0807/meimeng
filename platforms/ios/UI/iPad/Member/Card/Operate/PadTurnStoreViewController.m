//
//  PadTurnStoreViewController.m
//  Boss
//
//  Created by XiaXianBing on 2016-3-15.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadTurnStoreViewController.h"
#import "PadProjectConstant.h"
#import "CBLoadingView.h"
#import "UIImage+Resizable.h"
#import "PersonalProfile.h"
#import "BSMemberCardTurnStoreRequest.h"

typedef enum kPadTurnStoreSectionType
{
    kPadTurnStoreSectionCard        = 0,
    kPadTurnStoreSectionCStore      = 1,
    kPadTurnStoreSectionRemark      = 2,
    kPadTurnStoreSectionIsMember    = 3,
    kPadTurnStoreSectionCountN      = 4,
    
    kPadTurnStoreSectionMStore      = 4,
    kPadTurnStoreSectionCount       = 5
}kPadTurnStoreSectionType;


@interface PadTurnStoreViewController ()

@property (nonatomic, strong) CDMemberCard *memberCard;
@property (nonatomic, strong) NSArray *companyStores;
@property (nonatomic, strong) UITableView *turnStoreTableView;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) CDStore *cardStore;
@property (nonatomic, assign) BOOL isSelectCardStore;
@property (nonatomic, assign) BOOL isMemberTurnStore;
@property (nonatomic, assign) BOOL isSelectMemberStore;
@property (nonatomic, strong) CDStore *memberStore;
@property (nonatomic, strong) NSString *remarkstr;

@end


@implementation PadTurnStoreViewController

- (id)initWithMemberCard:(CDMemberCard *)memberCard
{
    self = [super initWithNibName:@"PadTurnStoreViewController" bundle:nil];
    if (self)
    {
        self.remarkstr = @"";
        self.memberCard = memberCard;
        self.cardStore = [[BSCoreDataManager currentManager] findEntity:@"CDStore" withValue:self.memberCard.storeID forKey:@"storeID"];
        self.memberStore = [[BSCoreDataManager currentManager] findEntity:@"CDStore" withValue:self.memberCard.member.storeID forKey:@"storeID"];
        self.companyStores = [[BSCoreDataManager currentManager] fetchAllStoreList];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.noKeyboardNotification = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0.0, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
    
    [self registerNofitificationForMainThread:kBSMemberCardTurnStoreResponse];
    
    self.turnStoreTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, self.view.frame.size.width, IC_SCREEN_HEIGHT - kPadNaviHeight - 32.0 - 60.0 - 32.0) style:UITableViewStylePlain];
    self.turnStoreTableView.backgroundColor = [UIColor clearColor];
    self.turnStoreTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.turnStoreTableView.delegate = self;
    self.turnStoreTableView.dataSource = self;
    self.turnStoreTableView.showsVerticalScrollIndicator = NO;
    self.turnStoreTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.turnStoreTableView];
    
    CGFloat originY = self.view.frame.size.height - 32.0 - 60.0 - 32.0;
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, originY - 0.5, self.view.frame.size.width, 0.5)];
    lineImageView.backgroundColor = COLOR(220.0, 230.0, 230.0, 1.0);
    [self.view addSubview:lineImageView];
    originY += 32.0;
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmButton.backgroundColor = [UIColor clearColor];
    self.confirmButton.frame = CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 60.0);
    self.confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [self.confirmButton setTitle:LS(@"PadConfirmButton") forState:UIControlStateNormal];
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
    titleLabel.text = LS(@"PadMemberCardTurnStore");
    [navi addSubview:titleLabel];
}

- (void)didBackButtonClick:(id)sender
{
    [self.maskView hidden];
}

- (void)didConfirmButtonClick:(id)sender
{
    if (self.remarkstr.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:LS(@"RemarkCanNotBeNULL")
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.memberCard.cardID forKey:@"card_id"];
    [params setObject:self.memberCard.member.memberID forKey:@"member_id"];
    if (self.remarkstr.length != 0)
    {
        [params setObject:self.remarkstr forKey:@"remark"];
    }
    
    [params setObject:self.cardStore.storeID forKey:@"new_card_shop_id"];
    [params setObject:@(self.isMemberTurnStore) forKey:@"is_change_member_shop"];
    if (self.isMemberTurnStore)
    {
        [params setObject:self.memberStore.storeID forKey:@"new_member_shop_id"];
    }
    else
    {
        [params setObject:self.memberCard.member.storeID forKey:@"new_member_shop_id"];
    }
    
    [[CBLoadingView shareLoadingView] show];
    BSMemberCardTurnStoreRequest *request = [[BSMemberCardTurnStoreRequest alloc] initWithParams:params];
    [request execute];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSMemberCardTurnStoreResponse])
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
    if (self.isMemberTurnStore)
    {
        return kPadTurnStoreSectionCount;
    }
    
    return kPadTurnStoreSectionCountN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kPadTurnStoreSectionCStore)
    {
        if (self.isSelectCardStore)
        {
            return 2;
        }
    }
    else if (section == kPadTurnStoreSectionMStore)
    {
        if (self.isSelectMemberStore)
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
        if (indexPath.section == kPadTurnStoreSectionIsMember)
        {
            return kPadCardOperateSwitchCellHeight;
        }
        
        return kPadCardOperateCellHeight;
    }
    else if (indexPath.row == 1)
    {
        return kPadPickerViewCellHeight;
    }
    
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == kPadTurnStoreSectionRemark || section == kPadTurnStoreSectionMStore)
    {
        return 36.0;
    }
    
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == kPadTurnStoreSectionRemark || section == kPadTurnStoreSectionMStore)
    {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.turnStoreTableView.frame.size.width, 36.0)];
        footerView.backgroundColor = [UIColor clearColor];
        
        return footerView;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        if (indexPath.section == kPadTurnStoreSectionIsMember)
        {
            static NSString *CellIdentifier = @"PadCardOperateSwitchCellIdentifier";
            PadCardOperateSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[PadCardOperateSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.delegate = self;
            }
            
            cell.titleLabel.text = LS(@"PadTurnStoreModifyMemberStore");
            if (self.isMemberTurnStore)
            {
                cell.isSwitchOn = YES;
            }
            else
            {
                cell.isSwitchOn = NO;
            }
            
            return cell;
        }
        else
        {
            static NSString *CellIdentifier = @"PadCardOperateCellIdentifier";
            PadCardOperateCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[PadCardOperateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.contentTextField.tag = 1000 + indexPath.section;
            }
            
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.contentTextField.enabled = YES;
            cell.contentTextField.delegate = nil;
            cell.downImageView.alpha = 0.0;
            cell.confirmButton.alpha = 0.0;
            cell.contentTextField.textAlignment = NSTextAlignmentLeft;
            [cell.contentButton setBackgroundImage:[[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)] forState:UIControlStateNormal];
            [cell.contentButton setBackgroundImage:[[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)] forState:UIControlStateHighlighted];
            if (indexPath.section == kPadTurnStoreSectionCard)
            {
                cell.titleLabel.text = LS(@"PadMemberCard");
                cell.contentTextField.enabled = NO;
                cell.contentTextField.text = self.memberCard.cardNumber;
                cell.contentTextField.textAlignment = NSTextAlignmentCenter;
            }
            else if (indexPath.section == kPadTurnStoreSectionCStore)
            {
                cell.titleLabel.text = LS(@"PadTurnStoreCardStore");
                cell.contentTextField.enabled = NO;
                cell.contentTextField.textAlignment = NSTextAlignmentCenter;
                
                cell.delegate = self;
                cell.downImageView.alpha = 1.0;
                cell.confirmButton.alpha = 0.0;
                if (self.isSelectCardStore)
                {
                    cell.downImageView.alpha = 0.0;
                    cell.confirmButton.alpha = 1.0;
                    [cell.contentButton setBackgroundImage:[[UIImage imageNamed:@"pad_top_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)] forState:UIControlStateNormal];
                    [cell.contentButton setBackgroundImage:[[UIImage imageNamed:@"pad_top_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)] forState:UIControlStateHighlighted];
                }
                
                if (self.cardStore)
                {
                    cell.contentTextField.text = self.cardStore.storeName;
                }
                else
                {
                    cell.contentTextField.text = @"";
                }
            }
            else if (indexPath.section == kPadTurnStoreSectionRemark)
            {
                cell.titleLabel.text = LS(@"PadCardOperateRemark");
                cell.contentTextField.delegate = self;
                cell.contentTextField.text = self.remarkstr;
            }
            else if (indexPath.section == kPadTurnStoreSectionMStore)
            {
                cell.titleLabel.text = LS(@"PadTurnStoreMemberStore");
                cell.contentTextField.enabled = NO;
                cell.contentTextField.textAlignment = NSTextAlignmentCenter;
                
                cell.delegate = self;
                cell.downImageView.alpha = 1.0;
                cell.confirmButton.alpha = 0.0;
                if (self.isSelectMemberStore)
                {
                    cell.downImageView.alpha = 0.0;
                    cell.confirmButton.alpha = 1.0;
                    [cell.contentButton setBackgroundImage:[[UIImage imageNamed:@"pad_top_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)] forState:UIControlStateNormal];
                    [cell.contentButton setBackgroundImage:[[UIImage imageNamed:@"pad_top_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)] forState:UIControlStateHighlighted];
                }
                
                if (self.memberStore)
                {
                    cell.contentTextField.text = self.memberStore.storeName;
                }
                else
                {
                    cell.contentTextField.text = @"";
                }
            }
            
            return cell;
        }
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
        
        cell.indexPath = indexPath;
        [cell reloadPickerViewWithStores:self.companyStores];
        if (indexPath.section == kPadTurnStoreSectionCStore)
        {
            if (self.cardStore)
            {
                for (int i = 0; i < self.companyStores.count; i++)
                {
                    CDStore *store = [self.companyStores objectAtIndex:i];
                    if (self.cardStore.storeID.integerValue == store.storeID.integerValue)
                    {
                        [cell.pickerView selectRow:i inComponent:0 animated:NO];
                        break;
                    }
                }
            }
            else if (self.companyStores.count != 0)
            {
                [cell.pickerView selectRow:0 inComponent:0 animated:NO];
            }
        }
        else if (indexPath.section == kPadTurnStoreSectionMStore)
        {
            if (self.memberStore)
            {
                for (int i = 0; i < self.companyStores.count; i++)
                {
                    CDStore *store = [self.companyStores objectAtIndex:i];
                    if (self.memberStore.storeID.integerValue == store.storeID.integerValue)
                    {
                        [cell.pickerView selectRow:i inComponent:0 animated:NO];
                        break;
                    }
                }
            }
            else if (self.companyStores.count != 0)
            {
                [cell.pickerView selectRow:0 inComponent:0 animated:NO];
            }
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
    if (textField.tag - 1000 == kPadTurnStoreSectionRemark)
    {
        self.remarkstr = textField.text;
    }
}


#pragma mark -
#pragma mark PadCardOperateSwitchCellDelegate Methods

- (void)didPadCardOperateSwitchButtonClick:(PadCardOperateSwitchCell *)cell
{
    self.isMemberTurnStore = cell.isSwitchOn;
    [self.turnStoreTableView reloadData];
    if (self.isMemberTurnStore)
    {
        [self.turnStoreTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kPadTurnStoreSectionMStore] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    else
    {
        self.isSelectMemberStore = NO;
    }
}


#pragma mark -
#pragma mark PadCardOperateCellDelegate Methods

- (void)didContentButtonClick:(PadCardOperateCell *)cell
{
    if (cell.indexPath.section == kPadTurnStoreSectionCStore)
    {
        self.isSelectCardStore = !self.isSelectCardStore;
        if (self.isSelectCardStore)
        {
            [UIView animateWithDuration:0.1 animations:^{
                cell.downImageView.alpha = 0.0;
                cell.confirmButton.alpha = 1.0;
                [self.turnStoreTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:kPadTurnStoreSectionCStore]] withRowAnimation:UITableViewRowAnimationTop];
            } completion:^(BOOL finished) {
                [self.turnStoreTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kPadTurnStoreSectionCStore] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }];
        }
        else
        {
            cell.downImageView.alpha = 1.0;
            cell.confirmButton.alpha = 0.0;
            [self.turnStoreTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:kPadTurnStoreSectionCStore]] withRowAnimation:UITableViewRowAnimationFade];
        }
        [self.turnStoreTableView reloadSections:[NSIndexSet indexSetWithIndex:kPadTurnStoreSectionCStore] withRowAnimation:UITableViewRowAnimationNone];
    }
    else if (cell.indexPath.section == kPadTurnStoreSectionMStore)
    {
        self.isSelectMemberStore = !self.isSelectMemberStore;
        if (self.isSelectMemberStore)
        {
            [UIView animateWithDuration:0.1 animations:^{
                cell.downImageView.alpha = 0.0;
                cell.confirmButton.alpha = 1.0;
                [self.turnStoreTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:kPadTurnStoreSectionMStore]] withRowAnimation:UITableViewRowAnimationTop];
            } completion:^(BOOL finished) {
                [self.turnStoreTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:kPadTurnStoreSectionMStore] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }];
        }
        else
        {
            cell.downImageView.alpha = 1.0;
            cell.confirmButton.alpha = 0.0;
            [self.turnStoreTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:kPadTurnStoreSectionMStore]] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        [self.turnStoreTableView reloadSections:[NSIndexSet indexSetWithIndex:kPadTurnStoreSectionMStore] withRowAnimation:UITableViewRowAnimationNone];
    }
}


#pragma mark -
#pragma mark PadPickerViewCellDelegate Methods

- (void)pickerView:(PadPickerViewCell *)cell selectedStore:(CDStore *)store
{
    if (cell.indexPath.section == kPadTurnStoreSectionCStore)
    {
        self.cardStore = store;
        PadCardOperateCell *cell = [self.turnStoreTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kPadTurnStoreSectionCStore]];
        cell.contentTextField.text = self.cardStore.storeName;
    }
    else if (cell.indexPath.section == kPadTurnStoreSectionMStore)
    {
        self.memberStore = store;
        PadCardOperateCell *cell = [self.turnStoreTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kPadTurnStoreSectionMStore]];
        cell.contentTextField.text = self.memberStore.storeName;
    }
}

@end
