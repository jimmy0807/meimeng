//
//  PadReplacementViewController.m
//  Boss
//
//  Created by XiaXianBing on 2016-3-11.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadReplacementViewController.h"
#import "PadProjectConstant.h"
#import "PadCardOperateCell.h"
#import "CBLoadingView.h"
#import "BSMemberCardOperateRequest.h"

typedef enum kPadReplacementRowType
{
    kPadReplacementNewCard,
    kPadReplacementRemark,
    kPadReplacementRowCount
}kPadReplacementRowType;

@interface PadReplacementViewController ()

@property (nonatomic, strong) CDMemberCard *memberCard;
@property (nonatomic, strong) UITableView *replacementTableView;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, strong) NSString *remarkstr;

@end

@implementation PadReplacementViewController

- (id)initWithMemberCard:(CDMemberCard *)memberCard
{
    self = [super initWithNibName:@"PadReplacementViewController" bundle:nil];
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
    
    [self registerNofitificationForMainThread:kBSMemberCardOperateResponse];
    
    self.replacementTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight + 60.0, self.view.frame.size.width, IC_SCREEN_HEIGHT - kPadNaviHeight - 32.0 - 60.0 - 60.0 - 32.0) style:UITableViewStylePlain];
    self.replacementTableView.backgroundColor = [UIColor clearColor];
    self.replacementTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.replacementTableView.delegate = self;
    self.replacementTableView.dataSource = self;
    self.replacementTableView.showsVerticalScrollIndicator = NO;
    self.replacementTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.replacementTableView];
    
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
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateHighlighted];
    [self.confirmButton addTarget:self action:@selector(didConfirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.confirmButton];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, self.view.frame.size.width, 60.0)];
    headerView.backgroundColor = COLOR(242.0, 245.0, 245.0, 1.0);
    [self.view addSubview:headerView];
    
    UIImage *checkImage = [UIImage imageNamed:@"pad_check_n"];
    UIImageView *checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(24.0, (60.0 - checkImage.size.height)/2.0, checkImage.size.width, checkImage.size.height)];
    checkImageView.backgroundColor = [UIColor clearColor];
    checkImageView.image = checkImage;
    [headerView addSubview:checkImageView];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(24.0 + checkImage.size.width + 12.0, (60.0 - 20.0)/2.0, self.view.frame.size.width - 2 * 24.0 - checkImage.size.width - 12.0, 20.0)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:16.0];
    headerLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    headerLabel.text = [NSString stringWithFormat:LS(@"PadMasterCardNum"), self.memberCard.cardNumber];
    [headerView addSubview:headerLabel];
    
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
    titleLabel.text = LS(@"PadMemberCardExchange");
    [navi addSubview:titleLabel];
    
    [self refreshConfirmButton];
}

- (void)didBackButtonClick:(id)sender
{
    [self.maskView hidden];
}

- (void)didConfirmButtonClick:(id)sender
{
    if (self.cardNumber.length == 0)
    {
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.memberCard.cardID forKey:@"card_id"];
    [params setObject:self.cardNumber forKey:@"refer_no"];
    if (self.remarkstr.length != 0)
    {
        [params setObject:self.remarkstr forKey:@"remark"];
    }
    
    [[CBLoadingView shareLoadingView] show];
    BSMemberCardOperateRequest *request = [[BSMemberCardOperateRequest alloc] initWithParams:params operateType:kPadMemberCardOperateReplacement];
    [request execute];
}

- (void)refreshConfirmButton
{
    if (self.cardNumber.length == 0)
    {
        self.confirmButton.enabled = NO;
//        [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_highlighted_button_n"] forState:UIControlStateNormal];
//        [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_highlighted_button_n"] forState:UIControlStateHighlighted];
    }
    else
    {
        self.confirmButton.enabled = YES;
//        [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateNormal];
//        [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_h"] forState:UIControlStateHighlighted];
    }
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
            self.memberCard.cardNo = self.cardNumber;
            self.memberCard.cardNumber = self.cardNumber;
            [[NSNotificationCenter defaultCenter] postNotificationName:kPadSelectMemberCardFinish object:self.memberCard userInfo:nil];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kPadReplacementRowCount;
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
        cell.contentTextField.tag = 1000 + indexPath.row;
        cell.contentTextField.delegate = self;
    }
    
    if (indexPath.row == kPadReplacementNewCard)
    {
        cell.titleLabel.text = LS(@"PadNewCardNum");
    }
    else if (indexPath.row == kPadReplacementRemark)
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
    if (textField.tag - 1000 == kPadReplacementNewCard)
    {
        self.cardNumber = textField.text;
    }
    else if (textField.tag - 1000 == kPadReplacementRemark)
    {
        self.remarkstr = textField.text;
    }
    [self refreshConfirmButton];
}

@end
