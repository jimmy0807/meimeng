//
//  PadRedeemViewController.m
//  Boss
//
//  Created by XiaXianBing on 2016-3-15.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadRedeemViewController.h"
#import "PadProjectConstant.h"
#import "CBLoadingView.h"
#import "BSMemberCardRedeemRequest.h"

typedef enum kPadRedeemSectionType
{
    kPadRedeemSectionCard,
    kPadRedeemSectionRedeem,
    kPadRedeemSectionProduct,
    kPadRedeemSectionRemark,
    kPadRedeemSectionCount
}kPadRedeemSectionType;

@interface PadRedeemViewController ()

@property (nonatomic, strong) CDMemberCard *memberCard;
@property (nonatomic, strong) UITableView *redeemTableView;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, assign) NSInteger integral;
@property (nonatomic, strong) CDProjectItem *redeemProduct;
@property (nonatomic, strong) NSString *remarkstr;

@end


@implementation PadRedeemViewController

- (id)initWithMemberCard:(CDMemberCard *)memberCard
{
    self = [super initWithNibName:@"PadRedeemViewController" bundle:nil];
    if (self)
    {
        self.memberCard = memberCard;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.noKeyboardNotification = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0.0, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
    
    [self registerNofitificationForMainThread:kBSMemberCardRedeemResponse];
    
    self.redeemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, self.view.frame.size.width, IC_SCREEN_HEIGHT - kPadNaviHeight - 32.0 - 60.0 - 32.0) style:UITableViewStylePlain];
    self.redeemTableView.backgroundColor = [UIColor clearColor];
    self.redeemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.redeemTableView.delegate = self;
    self.redeemTableView.dataSource = self;
    self.redeemTableView.showsVerticalScrollIndicator = NO;
    self.redeemTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.redeemTableView];
    
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
    titleLabel.text = [NSString stringWithFormat:LS(@"PadCardOperateCurrentIntegral"), self.memberCard.points.integerValue];
    [navi addSubview:titleLabel];
}

- (void)didBackButtonClick:(id)sender
{
    [self.maskView hidden];
}

- (void)didConfirmButtonClick:(id)sender
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.memberCard.cardID forKey:@"card_id"];
    [params setObject:@(self.integral) forKey:@"exchange_point"];
    [params setObject:@"change" forKey:@"type"];
    if (self.remarkstr.length != 0)
    {
        [params setObject:self.remarkstr forKey:@"remark"];
    }
    
    if (self.redeemProduct)
    {
        [params setObject:self.redeemProduct.itemID forKey:@"product_id"];
    }
    
    [[CBLoadingView shareLoadingView] show];
    BSMemberCardRedeemRequest *request = [[BSMemberCardRedeemRequest alloc] initWithParams:params];
    [request execute];
}

- (void)refreshConfirmButton
{
    if (self.integral == 0)
    {
        self.confirmButton.enabled = NO;
    }
    else
    {
        self.confirmButton.enabled = YES;
    }
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSMemberCardRedeemResponse])
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
    return kPadRedeemSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPadCardOperateCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    cell.contentTextField.enabled = YES;
    cell.contentTextField.userInteractionEnabled = YES;
    cell.contentTextField.textAlignment = NSTextAlignmentLeft;
    if (indexPath.section == kPadRedeemSectionCard)
    {
        cell.titleLabel.text = LS(@"PadMemberCard");
        cell.contentTextField.enabled = NO;
        cell.contentTextField.text = self.memberCard.cardNumber;
        cell.contentTextField.textAlignment = NSTextAlignmentCenter;
    }
    else if (indexPath.section == kPadRedeemSectionRedeem)
    {
        cell.titleLabel.text = LS(@"PadCardOperateRedeemIntegral");
    }
    else if (indexPath.section == kPadRedeemSectionProduct)
    {
        cell.titleLabel.text = LS(@"PadCardOperateRedeemProduct");
        cell.delegate = self;
        cell.contentTextField.enabled = NO;
        cell.contentTextField.textAlignment = NSTextAlignmentCenter;
        cell.contentTextField.userInteractionEnabled = NO;
        if (self.redeemProduct)
        {
            cell.contentTextField.text = self.redeemProduct.itemName;
        }
        else
        {
            cell.contentTextField.text = LS(@"PadCardOperateSelectProduct");
        }
    }
    else if (indexPath.section == kPadRedeemSectionRemark)
    {
        cell.titleLabel.text = LS(@"PadCardOperateRemark");
    }
    
    return cell;
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
    if (textField.tag - 1000 == kPadRedeemSectionRedeem)
    {
        self.integral = textField.text.integerValue;
    }
    else if (textField.tag - 1000 == kPadRedeemSectionRemark)
    {
        self.remarkstr = textField.text;
    }
}


#pragma mark -
#pragma mark PadCardOperateCellDelegate Methods

- (void)didContentButtonClick:(PadCardOperateCell *)cell
{
    if (cell.indexPath.section == kPadRedeemSectionProduct)
    {
        PadSelectSingleProductViewController *viewController = [[PadSelectSingleProductViewController alloc] initWithDelegate:self];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


#pragma mark -
#pragma mark PadSelectSingleProductViewControllerDelegate Methods

- (void)didPadSelectSingleProduct:(CDProjectItem *)product
{
    self.redeemProduct = product;
    [self.redeemTableView reloadData];
}

@end
