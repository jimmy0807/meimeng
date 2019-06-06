//
//  ImportMemberCardViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/8/18.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ImportMemberCardViewController.h"
#import "CBLoadingView.h"
#import "BSEditCell.h"
#import "BSItemAddCell.h"
#import "BSSectionFooter.h"
#import "BSCardItem.h"
#import "BSOverdraft.h"
#import "BSImportMemberCardRequest.h"
#import "CardItemViewController.h"
#import "CardItemCreateViewController.h"
#import "OverdraftViewController.h"
#import "OverdraftCreateViewController.h"
#import "MemberCardAmountViewController.h"
#import "MemberDetailViewController.h"
#import "MemberViewController.h"
#import "CBMessageView.h"
#import "PosOperateAddCell.h"
#import "BSCommonCell.h"
#import "ProductProjectMainController.h"

#define kImportMemberCardCellHeight       50.0

typedef enum kImportSection
{
    kImportSectionCardInfo,
    kImportSectionCardItems,
    kImportSectionCardArrears,
    kImportSectionCount
}kImportSection;


typedef enum kCardInfoRow
{
    kCardInfoUserName,
    kCardInfoCardNumber,
    kCardInfoCreateCardStore,
    kCardInfoDiscountScheme,
    kCardInfoTotalOverage,
    kCardInfoIntegration,
    kCardInfoRowCount
}kCardInfoRow;



@interface ImportMemberCardViewController ()

@property (nonatomic, strong) CDMember *member;
@property (nonatomic, strong) NSString *cardNumber;

@property (nonatomic, strong) CDStore *createCardStore;
@property (nonatomic, strong) CDMemberPriceList *discountScheme;
@property (nonatomic, assign) CGFloat cardAmount;
@property (nonatomic, assign) CGFloat presentAmount;
@property (nonatomic, assign) NSInteger integration;
@property (nonatomic, strong) NSMutableArray *cardItems;
@property (nonatomic, strong) NSMutableArray *overdrafts;

@property (nonatomic, strong) UITableView *importTableView;

@property (nonatomic, strong) NSIndexPath *mIndexPath;

@end

@implementation ImportMemberCardViewController

- (id)initWithMember:(CDMember *)member
{
    self = [super initWithNibName:NIBCT(@"ImportMemberCardViewController") bundle:nil];
    if (self)
    {
        self.member = member;
        self.createCardStore = self.member.store;
        
        char random_char = 'A' + arc4random_uniform(26);
        NSString *random_str;
        if(self.member.mobile.length == 0 || self.member.mobile.length < 11)
        {
            random_str = [NSString stringWithFormat:@"%04d", arc4random() % 10000];
        }
        else
        {
            random_str = [self.member.mobile substringWithRange:NSMakeRange(7, 4)];
        }
        PersonalProfile *profile = [PersonalProfile currentProfile];
        self.cardNumber = [NSString stringWithFormat:@"%@%c%03d%@", profile.businessId, random_char, arc4random() % 1000, random_str];
        
        self.discountScheme = nil;
        self.cardItems = [NSMutableArray array];
        self.overdrafts = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self forbidSwipGesture];
    self.title = LS(@"ImportMemberCard");
    self.view.backgroundColor = COLOR(245.0, 245.0, 245.0, 1.0);
    self.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
    
    BNBackButtonItem *backButtonItem = [[BNBackButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_back_n"] highlightedImage:[UIImage imageNamed:@"navi_back_h"]];
    backButtonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc] initWithTitle:LS(@"Finish")];
    rightButtonItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    [self registerNofitificationForMainThread:kBSCardItemEditFinish];
    [self registerNofitificationForMainThread:kBSOverdraftEditFinish];
    [self registerNofitificationForMainThread:kBSCardAmountEditFinish];
    [self registerNofitificationForMainThread:kBSImportMemberCardResponse];
    
    [self registerNofitificationForMainThread:kBSOverdraftCreateResult];
    [self registerNofitificationForMainThread:kBSCardItemCreateResult];
    [self registerNofitificationForMainThread:kBSCardItemSelectFinish];
    
    self.importTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.importTableView.backgroundColor = [UIColor clearColor];
    self.importTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.importTableView.delegate = self;
    self.importTableView.dataSource = self;
    self.importTableView.showsVerticalScrollIndicator = NO;
    self.importTableView.showsHorizontalScrollIndicator = NO;
    self.importTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.importTableView];
    
    UIView *headerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 19.5, IC_SCREEN_WIDTH, 0.5)];
    lineImageView.backgroundColor = [UIColor clearColor];
    lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
    [headerView addSubview:lineImageView];
//    self.importTableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    footerView.backgroundColor = [UIColor clearColor];
    self.importTableView.tableFooterView = footerView;
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

-(void)didItemBackButtonPressed:(UIButton*)sender
{
    [self popBack];
}

- (void)popBack
{
    if (self.isFromCreateMember) {
        for (UIViewController *viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[MemberViewController class]]) {
                [self.navigationController popToViewController:viewController animated:YES];
                break;
            }
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



- (void)didRightBarButtonItemClick:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (self.cardNumber.length == 0 || self.createCardStore == nil || self.createCardStore.storeID.integerValue == 0 || self.discountScheme == nil)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:LS(@"ImportMemberCardInfoIncomplete")
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.member.memberID, @"member_id",
                                   self.cardNumber, @"no",
                                   @"draft", @"state",
                                   self.member.companyID, @"company_id",
                                   self.createCardStore.storeID, @"shop_id",
                                   [NSNumber numberWithInteger:1], @"type_id",
                                   self.discountScheme.priceID, @"pricelist_id",
                                   [NSNumber numberWithFloat:(self.cardAmount + self.presentAmount)], @"amount",
                                   [NSNumber numberWithFloat:self.presentAmount], @"give_amount",
                                   [NSNumber numberWithFloat:self.integration], @"point", nil];
    
    NSMutableArray *cardItemParams = [NSMutableArray array];
    for (int i = 0; i < self.cardItems.count; i++)
    {
        BSCardItem *cardItem = [self.cardItems objectAtIndex:i];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSString *datestr = @"";
        if (cardItem.isLimited)
        {
            datestr = [dateFormatter stringFromDate:cardItem.limitedDate];
        }
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              cardItem.productID, @"product_id",
                              [NSNumber numberWithFloat:cardItem.unitPrice], @"price_unit",
                              [NSNumber numberWithFloat:cardItem.importQty], @"import_qty",
                              [NSNumber numberWithFloat:cardItem.importQty], @"qty",
                              [NSNumber numberWithBool:cardItem.isLimited], @"limited_qty",
                              datestr.length > 0 ? datestr : false, @"limited_date",
                              cardItem.remark, @"remark", nil];
        [cardItemParams addObject:@[[NSNumber numberWithInteger:kBSDataAdded], [NSNumber numberWithBool:NO], dict]];
    }
    [params setObject:cardItemParams forKey:@"product_line_ids"];
    
    NSMutableArray *overdraftParams = [NSMutableArray array];
    for (int i = 0; i < self.overdrafts.count; i++)
    {
        BSOverdraft *overdraft = [self.overdrafts objectAtIndex:i];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              overdraft.name, @"name",
                              overdraft.type, @"type",
                              [NSNumber numberWithFloat:overdraft.amount], @"arrears_amount",
                              overdraft.remark, @"remark", nil];
        [overdraftParams addObject:@[[NSNumber numberWithInteger:kBSDataAdded], [NSNumber numberWithBool:NO], dict]];
    }
    [params setObject:overdraftParams forKey:@"arrears_ids"];
    
    [[CBLoadingView shareLoadingView] show];
    BSImportMemberCardRequest *request = [[BSImportMemberCardRequest alloc] initWithParams:params];
    [request execute];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSCardAmountEditFinish])
    {
        NSDictionary *dict = (NSDictionary *)notification.object;
        self.cardAmount = [[dict objectForKey:@"CardAmount"] floatValue];
        self.presentAmount = [[dict objectForKey:@"PresentAmount"] floatValue];
        BSEditCell *cell = (BSEditCell *)[self.importTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kCardInfoTotalOverage inSection:kImportSectionCardInfo]];
        cell.contentField.text = [NSString stringWithFormat:@"%.2f", self.cardAmount + self.presentAmount];
    }
    else if ([notification.name isEqualToString:kBSCardItemEditFinish]|| [notification.name isEqualToString:kBSCardItemCreateResult])
    {
        
        self.cardItems = (NSMutableArray *)notification.object;
        [self.importTableView reloadSections:[NSIndexSet indexSetWithIndex:kImportSectionCardItems] withRowAnimation:UITableViewRowAnimationFade];

    }
    else if ([notification.name isEqualToString:kBSCardItemSelectFinish])
    {
        [self.cardItems addObject:notification.object];
        [self.importTableView reloadSections:[NSIndexSet indexSetWithIndex:kImportSectionCardItems] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if ([notification.name isEqualToString:kBSOverdraftEditFinish] || [notification.name isEqualToString:kBSOverdraftCreateResult])
    {
        self.overdrafts = (NSMutableArray *)notification.object;
        [self.importTableView reloadSections:[NSIndexSet indexSetWithIndex:kImportSectionCardArrears] withRowAnimation:UITableViewRowAnimationFade];

    }
    else if ([notification.name isEqualToString:kBSImportMemberCardResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
//            NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
//            MemberDetailViewController *detailViewController = [self.navigationController.viewControllers objectAtIndex:index-1];
//            [detailViewController initDataWithMember:self.member];
            
            CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:[NSString stringWithFormat:@"会员%@导入会员卡成功",self.member.memberName]];
            [messageView show];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kBSPopMemberDetailVCUpdate object:nil];
//            [self.navigationController popViewControllerAnimated:YES];
            [self popBack];
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
    return kImportSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kImportSectionCardInfo)
    {
        return kCardInfoRowCount;
    }
    else if (section == kImportSectionCardItems)
    {
        return self.cardItems.count + 1;
    }
    else if (section == kImportSectionCardArrears)
    {
        return self.overdrafts.count + 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kImportMemberCardCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == kImportSectionCardInfo)
    {
        static NSString *CellIdentifier = @"BSEditCellIdentifier";
        BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[BSEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.contentField.delegate = self;
        }
        cell.titleLabel.font = [UIFont systemFontOfSize:17];
        cell.contentField.font = [UIFont systemFontOfSize:14];
        cell.contentField.tag = 100 * indexPath.section + indexPath.row;
        cell.arrowImageView.hidden = NO;
        if (indexPath.row == kCardInfoUserName)
        {
            cell.titleLabel.text = LS(@"UserInfoUserName");
            cell.contentField.text = self.member.memberName;
        }
        else if (indexPath.row == kCardInfoCardNumber)
        {
            cell.titleLabel.text = LS(@"CardInfoCardNumber");
            cell.contentField.enabled = YES;
            cell.contentField.placeholder = LS(@"PleaseEnter");
            cell.contentField.text = self.cardNumber;
        }
        else if (indexPath.row == kCardInfoCreateCardStore)
        {
            cell.titleLabel.text = LS(@"CardInfoCreateCardStore");
            cell.contentField.enabled = NO;
            cell.contentField.placeholder = LS(@"PleaseSelect");
            cell.contentField.text = self.createCardStore.storeName;
        }
        else if (indexPath.row == kCardInfoDiscountScheme)
        {
            cell.titleLabel.text = LS(@"CardInfoDiscountScheme");
            cell.contentField.enabled = NO;
            cell.contentField.placeholder = LS(@"PleaseSelect");
            cell.contentField.text = self.discountScheme.name;
        }
        else if (indexPath.row == kCardInfoTotalOverage)
        {
            cell.titleLabel.text = LS(@"CardInfoTotalOverage");
            cell.contentField.enabled = NO;
            cell.contentField.placeholder = LS(@"PleaseEnter");
            cell.contentField.text = [NSString stringWithFormat:@"%.2f", self.cardAmount + self.presentAmount];
        }
        else if (indexPath.row == kCardInfoIntegration)
        {
            cell.titleLabel.text = LS(@"CardInfoIntegration");
            cell.contentField.enabled = YES;
            cell.contentField.placeholder = LS(@"PleaseEnter");
            cell.contentField.text = [NSString stringWithFormat:@"%d", self.integration];
        }
        return cell;
    }
    else if (indexPath.section == kImportSectionCardItems || indexPath.section == kImportSectionCardArrears)
    {
        if (indexPath.row == 0) {
            PosOperateAddCell *cell = [PosOperateAddCell createCell];
            cell.lineImgView.hidden  = false;
            if (indexPath.section == kImportSectionCardItems) {
                cell.titleLabel.text = @"添加卡内项目";
            }
            else
            {
                cell.titleLabel.text = @"添加欠款";
            }
            return cell;
        }
        else
        {
            BSCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BSCommonCell"];
            if (cell == nil) {
                cell = [[BSCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BSCommonCell"];
            }
            cell.titleLabel.font = [UIFont systemFontOfSize:17];
            cell.detailLabel.font = [UIFont systemFontOfSize:14];
            cell.valueLabel.font = [UIFont systemFontOfSize:14];
            if (indexPath.section == kImportSectionCardItems) {
                cell.valueLabel.hidden = true;
                BSCardItem *cardItem = [self.cardItems objectAtIndex:indexPath.row - 1];
                cell.titleLabel.text = cardItem.productName;
                cell.detailLabel.text = [NSString stringWithFormat:LS(@"CardItemDetailTitle"), cardItem.importQty];
            }
            else
            {
                cell.valueLabel.hidden = false;
                BSOverdraft *overdraft = [self.overdrafts objectAtIndex:indexPath.row - 1];
                cell.titleLabel.text = overdraft.name;
                cell.detailLabel.text = [NSString stringWithFormat:LS(@"OverdraftDetailTitle"), LS(overdraft.type)];
                cell.valueLabel.text = [NSString stringWithFormat:@"%.2f", overdraft.amount];
            }
            
            return cell;
        }
    }
//        cell.contentField.enabled = NO;
//        cell.contentField.placeholder = LS(@"PleaseSelect");
//        if (indexPath.row == kDetailInfoCardItem)
//        {
//            cell.titleLabel.text = LS(@"CardItem");
//            cell.contentField.text = [NSString stringWithFormat:LS(@"DetailInfoNum"), self.cardItems.count];
//        }
//        else if (indexPath.row == kDetailInfoOverdraft)
//        {
//            cell.titleLabel.text = LS(@"Overdraft");
//            CGFloat overdraftAmount = 0;
//            for (int i = 0; i < self.overdrafts.count; i++)
//            {
//                BSOverdraft *overdraft = [self.overdrafts objectAtIndex:i];
//                overdraftAmount += overdraft.amount;
//            }
//            cell.contentField.text = [NSString stringWithFormat:@"%.2f", overdraftAmount];
//        }

    
    return nil;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TRUE;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == kImportSectionCardInfo)
    {
        if (indexPath.row == kCardInfoCreateCardStore)
        {
            NSInteger index = -1;
            NSMutableArray *stores = [NSMutableArray array];
            NSMutableArray *storeNames = [NSMutableArray array];
            NSArray *shopIds = [PersonalProfile currentProfile].shopIds;
            for (int i = 0; i < shopIds.count; i++)
            {
                CDStore *store = [[BSCoreDataManager currentManager] findEntity:@"CDStore" withValue:[shopIds objectAtIndex:i] forKey:@"storeID"];
                [stores addObject:store];
                [storeNames addObject:store.storeName];
                if (self.createCardStore.storeID.integerValue == store.storeID.integerValue)
                {
                    index = i;
                }
            }
            
            self.mIndexPath = indexPath;
            BSCommonSelectedItemViewController *viewController = [[BSCommonSelectedItemViewController alloc] initWithNibName:NIBCT(@"BSCommonSelectedItemViewController") bundle:nil];
            viewController.dataArray = storeNames;
            viewController.userData = stores;
            viewController.currentSelectIndex = index;
            viewController.delegate = self;
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else if (indexPath.row == kCardInfoDiscountScheme)
        {
            NSInteger index = -1;
            NSMutableArray *discountSchemes = [NSMutableArray array];
            NSMutableArray *discountSchemeNames = [NSMutableArray array];
            NSArray *schemes = [[BSCoreDataManager currentManager] fetchCanUsePriceList];
            for (int i = 0; i < schemes.count; i++)
            {
                CDMemberPriceList *scheme = [schemes objectAtIndex:i];
                [discountSchemes addObject:scheme];
                [discountSchemeNames addObject:scheme.name];
                if ([scheme.name isEqualToString:self.discountScheme.name])
                {
                    index = i;
                }
            }
            
            self.mIndexPath = indexPath;
            BSCommonSelectedItemViewController *viewController = [[BSCommonSelectedItemViewController alloc] initWithNibName:NIBCT(@"BSCommonSelectedItemViewController") bundle:nil];
            viewController.dataArray = discountSchemeNames;
            viewController.userData = discountSchemes;
            viewController.currentSelectIndex = index;
            viewController.delegate = self;
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else if (indexPath.row == kCardInfoTotalOverage)
        {
            MemberCardAmountViewController *viewController = [[MemberCardAmountViewController alloc] initWithCardAmount:self.cardAmount presentAmount:self.presentAmount];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    else if (indexPath.section == kImportSectionCardItems)
    {
        if (indexPath.row == 0)
        {
            
            ProductProjectMainController *productProjectMainVC = [[ProductProjectMainController alloc] init];
            productProjectMainVC.controllerType = ProductControllerType_Import;
            [self.navigationController pushViewController:productProjectMainVC animated:YES];
        }
        else
        {
            CardItemCreateViewController *viewController = [[CardItemCreateViewController alloc] initWithCardItems:self.cardItems editIndex:indexPath.row - 1];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    else if (indexPath.section == kImportSectionCardArrears)
    {
        if (indexPath.row == 0) {
            OverdraftCreateViewController *createViewController = [[OverdraftCreateViewController alloc] initWithOverdrafts:self.overdrafts editIndex:-1];
            [self.navigationController pushViewController:createViewController animated:YES];
        }
        else
        {
            OverdraftCreateViewController *viewController = [[OverdraftCreateViewController alloc] initWithOverdrafts:self.overdrafts editIndex:indexPath.row - 1];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBSSectionFooterHeight;
//    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *CellIdentifier = @"BSSectionFooterIdentifier";
    BSSectionFooter *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BSSectionFooter alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.lineImageView.hidden = true;
    }
    
    return cell;
}

#pragma mark -
#pragma mark BSCommonSelectedItemViewControllerDelegate Methods

-(void)didSelectItemAtIndex:(NSInteger)index userData:(id)userData
{
    if (self.mIndexPath.section == kImportSectionCardInfo)
    {
        if (self.mIndexPath.row == kCardInfoCreateCardStore)
        {
            CDStore *store = [(NSArray *)userData objectAtIndex:index];
            self.member.storeID = store.storeID;
            self.member.storeName = store.storeName;
            self.member.store = store;
            BSEditCell *cell = (BSEditCell *)[self.importTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kCardInfoCreateCardStore inSection:kImportSectionCardInfo]];
            cell.contentField.text = self.member.storeName;
        }
        else if (self.mIndexPath.row == kCardInfoDiscountScheme)
        {
            self.discountScheme = [(NSArray *)userData objectAtIndex:index];
            BSEditCell *cell = (BSEditCell *)[self.importTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kCardInfoDiscountScheme inSection:kImportSectionCardInfo]];
            cell.contentField.text = self.discountScheme.name;
        }
    }
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
    
    NSInteger section = textField.tag / 100;
    NSInteger row = textField.tag % 100;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    BSEditCell *cell = (BSEditCell *)[self.importTableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == kImportSectionCardInfo)
    {
        if (indexPath.row == kCardInfoCardNumber)
        {
            self.cardNumber = textField.text;
            cell.contentField.text = self.cardNumber;
        }
        else if (indexPath.row == kCardInfoIntegration)
        {
            self.integration = textField.text.integerValue;
            cell.contentField.text = [NSString stringWithFormat:@"%d", self.integration];
        }
    }
}

@end
