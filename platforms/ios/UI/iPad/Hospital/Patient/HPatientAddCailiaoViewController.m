//
//  HPatientAddCailiaoViewController.m
//  meim
//
//  Created by 波恩公司 on 2018/7/25.
//

#import "HPatientAddCailiaoViewController.h"
#import "PadProjectConstant.h"
#import "CBLoadingView.h"
#import "PadProjectCell.h"
#import "PadProjectSideCell.h"
#import "BSReturnItem.h"
#import "BSMemberCardOperateRequest.h"
#import "BSProjectItemPriceRequest.h"
#import "PadProjectData.h"
#import "PadPaymentViewController.h"
#import "PadProjectDetailViewController.h"
#import "ChangeYaopingCountViewController.h"

@interface HPatientAddCailiaoViewController ()<HPatientAddCailiaoViewControllerDelegate, UISearchBarDelegate>

@property (nonatomic, strong) CDMemberCard *memberCard;
@property (nonatomic, strong) NSArray *itemArray;

@property (nonatomic, strong) UITableView *itemTableView;
@property (nonatomic, strong) UITableView *returnTableView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) NSDictionary *priceParams;
@property (nonatomic, strong) CDPosOperate *posOperate;
@property (nonatomic, strong) PadProjectData *data;
@property (nonatomic, strong) UISearchBar* searchBar;
@property (nonatomic, strong) UIView *fastInputView;
@property (nonatomic, strong) NSString *fastInputString;
@end

@implementation HPatientAddCailiaoViewController

- (id)initWithMemberCard:(CDMemberCard *)memberCard couponCard:(CDCouponCard*)couponCard
{
    self = [super initWithNibName:@"HPatientAddCailiaoViewController" bundle:nil];
    if (self)
    {
        self.memberCard = memberCard;
        //self.itemArray = [[BSCoreDataManager currentManager] fetchProjectItemsWithType:kProjectItemInput bornCategorys:@[@(kPadBornCategoryProject)] categoryIds:nil existItemIds:nil keyword:nil priceAscending:FALSE];
        //kProjectItemCailiao
        //self.itemArray = [[BSCoreDataManager currentManager] fetchProjectItemsWithType:kProjectItemInput bornCategorys:@[] categoryIds:@[@22] existItemIds:nil keyword:nil priceAscending:FALSE];
        
        self.itemArray = [[BSCoreDataManager currentManager] fetchProjectItemsWithType:kProjectItemCailiao bornCategorys:@[] categoryIds:nil existItemIds:nil keyword:nil priceAscending:FALSE];
        
        NSMutableArray* ids = [NSMutableArray array];
        for ( CDProjectItem* item in self.itemArray )
        {
            [ids addObject:item.itemID];
        }
        if ( ids.count > 0 )
        {
            //BSProjectItemPriceRequest *request = [[BSProjectItemPriceRequest alloc] initWithProjectIds:ids priceListId:memberCard.priceList.priceID];
            //[request execute];
        }
        
        self.data = [[PadProjectData alloc] init];
        self.data.operateType = kPadProjectPosOperateCreate;
        
        self.posOperate = [[BSCoreDataManager currentManager] insertEntity:@"CDPosOperate"];
        self.data.posOperate = self.posOperate;
        
        self.posOperate.isLocal = [NSNumber numberWithBool:YES];
        self.posOperate.memberCard = self.memberCard;
        self.posOperate.couponCard = couponCard;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        self.posOperate.operate_date = [dateFormatter stringFromDate:[NSDate date]];
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
    
    UIView *leftBackground = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width - kPadProjectSideViewWidth, IC_SCREEN_HEIGHT)];
    leftBackground.backgroundColor = COLOR(242.0, 245.0, 245.0, 1.0);
    [self.view addSubview:leftBackground];
    
    self.itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, self.view.frame.size.width - kPadProjectSideViewWidth, self.view.frame.size.height - kPadNaviHeight) style:UITableViewStylePlain];
    self.itemTableView.backgroundColor = [UIColor clearColor];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.itemTableView.dataSource = self;
    self.itemTableView.delegate = self;
    self.itemTableView.showsVerticalScrollIndicator = NO;
    self.itemTableView.showsHorizontalScrollIndicator = NO;
    self.itemTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.itemTableView];
    
    self.returnTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - kPadProjectSideViewWidth, kPadNaviHeight, kPadProjectSideViewWidth, self.view.frame.size.height - kPadNaviHeight - kPadConfirmButtonHeight) style:UITableViewStylePlain];
    self.returnTableView.backgroundColor = [UIColor clearColor];
    self.returnTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.returnTableView.dataSource = self;
    self.returnTableView.delegate = self;
    self.returnTableView.showsVerticalScrollIndicator = NO;
    self.returnTableView.showsHorizontalScrollIndicator = NO;
    self.returnTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.returnTableView];
    
    self.confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - kPadProjectSideViewWidth, self.view.frame.size.height - kPadConfirmButtonHeight, kPadProjectSideViewWidth, kPadConfirmButtonHeight)];
    self.confirmButton.backgroundColor = COLOR(96, 211, 212, 1);
    self.confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmButton setTitle:LS(@"PadConfirmButton") forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"state_background2"] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"state_background1"] forState:UIControlStateHighlighted];
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
    [backButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_back_n"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_back_h"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(didBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navi addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadNaviHeight, (kPadNaviHeight - 24.0)/2.0, self.view.frame.size.width - kPadProjectSideViewWidth - 2 * kPadNaviHeight, 24.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    if ( self.orignalProjectArray )
    {
        titleLabel.text = @"材料";
    }
    else
    {
        titleLabel.text = @"材料";
    }
    
    [navi addSubview:titleLabel];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - kPadProjectSideViewWidth - 1.0, 0.0, 1.0, kPadNaviHeight)];
    lineImageView.backgroundColor = COLOR(216.0, 230.0, 230.0, 1.0);
    [navi addSubview:lineImageView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - kPadProjectSideViewWidth, (kPadNaviHeight - 24.0)/2.0, kPadProjectSideViewWidth, 24.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    
    if ( self.orignalProjectArray )
    {
        titleLabel.text = @"药品清单";
    }
    else
    {
        titleLabel.text = @"药品清单";
    }
    [navi addSubview:titleLabel];
    
    if ( self.orignalProjectArray )
    {
        self.priceParams = nil;
        for ( CDPosProduct* p in self.orignalProjectArray )
        {
            CDProjectItem* item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:p.product_id forKey:@"itemID"];
            if ( item )
            {
                for ( int i = 0; i < [p.product_qty integerValue]; i++ )
                {
                    [self didMemberCardProjectAdded:item];
                }
            }
        }
        [self refreshConfirmButton];
    }
    
    [self setTableViewHeaderView];
    
    self.fastInputView = [[UIView alloc] initWithFrame:CGRectMake(-504, 574, 641, 194)];
    self.fastInputView.backgroundColor = [UIColor clearColor];
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 26, 504, 168)];
    inputView.backgroundColor = COLOR(205, 209, 215, 1);
    for (int i = 0; i < 10 ; i++) {
        int line = i > 5 ? 1 : 0;
        UIButton *numButton = [[UIButton alloc] initWithFrame:CGRectMake(12+i%6*82, 12+line*78, 70, 66)];
        numButton.layer.cornerRadius = 7;
        numButton.backgroundColor = [UIColor whiteColor];
        numButton.tag = i;
        [numButton setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        [numButton setTitleColor:COLOR(37, 37, 37, 1) forState:UIControlStateNormal];
        //        [numButton setBackgroundColor:COLOR(163, 171, 182, 1) forState:UIControlStateHighlighted];
        //        [numButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [numButton addTarget:self action:@selector(fastInput:) forControlEvents:UIControlEventTouchUpInside];
        [numButton addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        [numButton addTarget:self action:@selector(touchCancel:) forControlEvents:UIControlEventTouchUpOutside];
        numButton.titleLabel.font = [UIFont systemFontOfSize:22];
        [inputView addSubview:numButton];
    }
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(340, 90, 152, 66)];
    cancelButton.backgroundColor = COLOR(163, 171, 182, 1);
    cancelButton.layer.cornerRadius = 7;
    [cancelButton setTitle:@"撤销" forState:UIControlStateNormal];
    [cancelButton setTitleColor:COLOR(111, 116, 123, 1) forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelFastInput) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:22];
    [inputView addSubview:cancelButton];
    
    [self.fastInputView addSubview:inputView];
    UIButton *controlButton = [[UIButton alloc] initWithFrame:CGRectMake(504, 100, 127, 56)];
    [controlButton setImage:[UIImage imageNamed:@"fast_input_show"] forState:UIControlStateNormal];
    [controlButton addTarget:self action:@selector(controlButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    controlButton.tag = 100;
    [self.fastInputView addSubview:controlButton];
    
    self.fastInputString = @"";
    [self.maskView addSubview:self.fastInputView];
    
    NSTimer *autoHideFastTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleFastInput) userInfo:nil repeats:YES];
    [autoHideFastTimer fire];
    
    [self registerNofitificationForMainThread:kBSProjectItemPriceResponse];
}

- (void)handleFastInput
{
    //NSLog(@"%@",self.maskView.navi.viewControllers);
    if (self.maskView.navi.viewControllers.count > 1)
    {
        self.fastInputView.hidden = YES;
    }
    else
    {
        self.fastInputView.hidden = NO;
    }
}

- (void)hideFastInput
{
    if (self.fastInputView.frame.origin.x >= 0)
    {
        [self controlButtonClicked];
    }
}

- (void)controlButtonClicked
{
    NSLog(@"%@",self.maskView.subviews);
    UIButton *button = [self.fastInputView viewWithTag:100];
    if (self.fastInputView.frame.origin.x < 0)
    {
        self.fastInputView.frame = CGRectMake(0, 574, 641, 194);
        button.frame = CGRectMake(484, 0, 127, 56);
        [button setImage:[UIImage imageNamed:@"fast_input_hide"] forState:UIControlStateNormal];
    }
    else
    {
        self.fastInputView.frame = CGRectMake(-504, 574, 641, 194);
        button.frame = CGRectMake(504, 100, 127, 56);
        [button setImage:[UIImage imageNamed:@"fast_input_show"] forState:UIControlStateNormal];
    }
}

- (void)touchDown:(UIButton *)button
{
    button.backgroundColor = COLOR(163, 171, 182, 1);
}

- (void)touchCancel:(UIButton *)button
{
    button.backgroundColor = [UIColor whiteColor];
}

- (void)fastInput:(UIButton *)button
{
    button.backgroundColor = [UIColor whiteColor];
    self.fastInputString = [self.fastInputString stringByAppendingString:[NSString stringWithFormat:@"%d",button.tag]];
    NSLog(@"%@",self.fastInputString);
    if ([self.fastInputString length] == 2)
    {
        NSLog(@"%@",self.fastInputString);
        //        CDProjectItem* item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:self.fastInputString forKey:@"itemID"];
        //        if (item != nil)
        //        {
        //            [self didPadProjectViewItemClick:item];
        //        }
        self.fastInputString = @"";
    }
}

- (void)cancelFastInput
{
    NSString *newText;
    if([self.fastInputString length] > 0){
        newText = [self.fastInputString substringToIndex:([self.fastInputString length]-1)];// 去掉最后一个","
    }else{
        newText = self.fastInputString;
    }
    self.fastInputString = newText;
    NSLog(@"%@",self.fastInputString);
}

- (void)setTableViewHeaderView
{
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.itemTableView.frame.size.width, 77)];
    v.backgroundColor = [UIColor clearColor];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(25, 13, v.frame.size.width - 50, v.frame.size.height - 26)];
    UIImage *searchBarImage = [[UIImage imageNamed:@"pad_search_bar_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(7.0, 20.0, 7.0, 20.0)];
    [self.searchBar setBackgroundImage:searchBarImage];
    self.searchBar.placeholder = @"搜索项目";
    self.searchBar.contentMode = UIViewContentModeLeft;
    self.searchBar.returnKeyType = UIReturnKeySearch;
    self.searchBar.delegate = self;
    [v addSubview:self.searchBar];
    
    self.itemTableView.tableHeaderView = v;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //self.itemArray = [[BSCoreDataManager currentManager] fetchProjectItemsWithType:kProjectItemInput bornCategorys:@[] categoryIds:nil existItemIds:nil keyword:searchText priceAscending:FALSE];
    self.itemArray = [[BSCoreDataManager currentManager] fetchProjectItemsWithType:kProjectItemCailiao bornCategorys:@[] categoryIds:nil existItemIds:nil keyword:nil priceAscending:FALSE];
    [self.itemTableView reloadData];
}

- (void)refreshConfirmButton
{
    if (self.posOperate.products == 0)
    {
        [self.confirmButton setTitleColor:COLOR(168.0, 205.0, 205.0, 1.0) forState:UIControlStateNormal];
        [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_disable_button_n"] forState:UIControlStateNormal];
        [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_disable_button_h"] forState:UIControlStateHighlighted];
    }
    else
    {
        [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateNormal];
        [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_h"] forState:UIControlStateHighlighted];
    }
}

- (void)didBackButtonClick:(id)sender
{
    [[BSCoreDataManager currentManager] deleteObject:self.posOperate];
    
    if ( self.orignalProjectArray )
    {
        [self.maskView.navi popViewControllerAnimated:YES];
    }
    else
    {
        [self.maskView hidden];
    }
}

- (void)didConfirmButtonClick:(id)sender
{
    [self.data reloadPosOperate];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddCailiaoFinished" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.posOperate.products.array, @"Cailiao", nil]];

    [self.delegate didHPatientAddCailiaoViewControllerConfirmButtonPressed:self.posOperate.products.array];
    if ( self.orignalProjectArray )
    {
        [self.maskView.navi popViewControllerAnimated:YES];
    }
    else
    {
        [self.maskView hidden];
    }
}

- (void)didMemberCardProjectAdded:(CDProjectItem *)item
{
    CDPosProduct* product = [self.data didAddPosOperateWithProjectItem:item];
    NSNumber* price = self.priceParams[item.itemID];
    if ( price )
    {
        product.product_price = price;
    }
    
    [self.returnTableView reloadData];
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
            [[BSCoreDataManager currentManager] deleteObject:self.posOperate];
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
    else if ([notification.name isEqualToString:kBSProjectItemPriceResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            self.priceParams = notification.userInfo;
            [self.itemTableView reloadData];
        }
    }
}

#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.itemTableView)
    {
        return 1;
    }
    else if (tableView == self.returnTableView)
    {
        return 1;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.itemTableView)
    {
        return self.itemArray.count;
    }
    else if (tableView == self.returnTableView)
    {
        if (section == 0)
        {
            return self.posOperate.products.count;
        }
        else
        {
            if (self.posOperate.products.count == 0)
            {
                return 1;
            }
            else
            {
                return 1;
            }
        }
        
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.itemTableView)
    {
        return kPadCustomItemCellHeight;
    }
    else if (tableView == self.returnTableView)
    {
        return kPadProjectSideCellHeight;
    }
    
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.itemTableView)
    {
        static NSString *CellIdentifier = @"PadProjectCellIdentifier";
        PadProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PadProjectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        CDProjectItem *item = [self.itemArray objectAtIndex:indexPath.row];
        cell.titleLabel.text = item.itemName;
        NSNumber* price = self.priceParams[item.itemID];
        if ( price == nil )
        {
            price = item.totalPrice;
        }
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%.02f", [price floatValue]];
        
        return cell;
    }
    else if (tableView == self.returnTableView)
    {
        if (indexPath.section == 1)
        {
            NSString *yizhuCellIdentifier = @"yizhuCellIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:yizhuCellIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:yizhuCellIdentifier];
            }
            UILabel *yizhuTitle = [[UILabel alloc] initWithFrame:CGRectMake(25, 19, 100, 16)];
            yizhuTitle.text = @"医嘱";
            yizhuTitle.textColor = COLOR(149, 171, 171, 1);
            [cell addSubview:yizhuTitle];
            
            UITextView *yizhuTextView = [[UITextView alloc] initWithFrame:CGRectMake(25, 50, 250, 185)];
            yizhuTextView.layer.cornerRadius = 6;
            yizhuTextView.layer.borderWidth = 1;
            yizhuTextView.layer.borderColor = COLOR(236, 237, 237, 1).CGColor;
            yizhuTextView.font = [UIFont systemFontOfSize:16];
            CGFloat xMargin = 10, yMargin = 12;
            // 使用textContainerInset设置top、left、right
            yizhuTextView.textContainerInset = UIEdgeInsetsMake(yMargin, xMargin, 0, xMargin);
            //当光标在最后一行时，始终显示低边距，需使用contentInset设置bottom.
            yizhuTextView.contentInset = UIEdgeInsetsMake(0, 0, yMargin, 0);
            //防止在拼音打字时抖动
            yizhuTextView.layoutManager.allowsNonContiguousLayout=NO;
            [cell addSubview:yizhuTextView];
            
            return cell;
        }
        static NSString *CellIdentifier = @"PadProjectSideCellIdentifier";
        PadProjectSideCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PadProjectSideCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        CDPosProduct *product = (CDPosProduct*)[self.posOperate.products.array objectAtIndex:indexPath.row];
        cell.titleLabel.text = product.product_name;
        cell.numberLabel.text = [NSString stringWithFormat:LS(@"PadPosProductNum"), [product.product_qty integerValue]];
        cell.priceLabel.text = [NSString stringWithFormat:@"%.2f", [@(product.product_price.floatValue * product.product_qty.floatValue) floatValue]];
        
        return cell;
    }
    
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.returnTableView)
    {
        if (indexPath.section == 0) {
            return YES;
        }
    }
    
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.returnTableView)
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSMutableOrderedSet *mutableSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.data.posOperate.products];
        [mutableSet removeObjectAtIndex:indexPath.row];
        self.data.posOperate.products = mutableSet;
        
        [self.data reloadPosOperate];
        
        [self.returnTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self refreshConfirmButton];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.itemTableView)
    {
        CDProjectItem *item = [self.itemArray objectAtIndex:indexPath.row];
        [self didMemberCardProjectAdded:item];
        
        [self.returnTableView reloadData];
        [self refreshConfirmButton];
    }
    else if (tableView == self.returnTableView)
    {
        
        if (indexPath.section == 0)
        {
            CDPosProduct *product = (CDPosProduct*)[self.posOperate.products.array objectAtIndex:indexPath.row];
            PadProjectDetailViewController *viewController = [[PadProjectDetailViewController alloc] initWithPosProduct:product detailType:kPadProjectDetailCurrentCashier];
            viewController.delegate = self;
            viewController.noTechnician = TRUE;
            [self.maskView.navi pushViewController:viewController animated:NO];
            //[self.maskView.navi pushViewController:returnItemViewController animated:NO];
        }
        //        CDPosProduct *product = (CDPosProduct*)[self.posOperate.products.array objectAtIndex:indexPath.row];
        //        PadProjectDetailViewController *viewController = [[PadProjectDetailViewController alloc] initWithPosProduct:product detailType:kPadProjectDetailCurrentCashier];
        //        viewController.delegate = self;
        //        viewController.noTechnician = TRUE;
        //        [self.navigationController pushViewController:viewController animated:YES];
        
        //        CDPosProduct *product = [self.inputArray objectAtIndex:indexPath.row];
        //        PadProjectDetailViewController *viewController = [[PadProjectDetailViewController alloc] initWithReturnItem:returnItem];
        //        viewController.delegate = self;
        //        viewController.maskView = self.maskView;
        //
        
        //
        //        viewController.delegate = self;
        //        viewController.maskView = self.maskView;
        //        viewController.member = self.data.posOperate.member;
        //        self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
        //        self.maskView.navi.navigationBarHidden = YES;
        //        self.maskView.navi.view.frame = CGRectMake(kPadMaskViewLeftWidth, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
        //        [self.maskView addSubview:self.maskView.navi.view];
        //        [self.maskView show];
    }
}

- (void)didPadPosProductConfirm:(CDPosProduct *)product
{
    [self.returnTableView reloadData];
}

#pragma mark -
#pragma mark PadProjectDetailViewControllerDelegate Methods

- (void)didPadReturnItemDelete:(BSReturnItem *)returnItem
{
    //[self.inputArray removeObject:returnItem];
    [self.returnTableView reloadData];
}

- (void)didPadReturnItemEditConfirm:(BSReturnItem *)returnItem
{
    [self.returnTableView reloadData];
}

@end
