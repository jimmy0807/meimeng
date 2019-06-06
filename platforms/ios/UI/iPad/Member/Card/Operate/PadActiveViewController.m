//
//  PadActiveViewController.m
//  Boss
//
//  Created by XiaXianBing on 2016-3-15.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadActiveViewController.h"
#import "PadProjectConstant.h"
#import "PadCardOperateCell.h"
#import "CBLoadingView.h"
#import "BSMemberCardOperateRequest.h"
#import "BSEditMemberCardRequest.h"

typedef enum kPadActiveRowType
{
    kPadActiveCardNum,
    kPadActiveRemark,
    kPadActiveRowCount
}kPadActiveRowType;

@interface PadActiveViewController ()

@property (nonatomic, strong) CDMemberCard *memberCard;
@property (nonatomic, strong) UITableView *activeTableView;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) NSString *remarkstr;

@end


@implementation PadActiveViewController

- (id)initWithMemberCard:(CDMemberCard *)memberCard
{
    self = [super initWithNibName:@"PadActiveViewController" bundle:nil];
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
    [self registerNofitificationForMainThread:kBSEditMemberCardResponse];
    
    self.activeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, self.view.frame.size.width, IC_SCREEN_HEIGHT - kPadNaviHeight - 32.0 - 60.0 - 32.0) style:UITableViewStylePlain];
    self.activeTableView.backgroundColor = [UIColor clearColor];
    self.activeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.activeTableView.delegate = self;
    self.activeTableView.dataSource = self;
    self.activeTableView.showsVerticalScrollIndicator = NO;
    self.activeTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.activeTableView];
    
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
    titleLabel.text = LS(@"PadMemberCardActive");
    [navi addSubview:titleLabel];
}

- (void)didBackButtonClick:(id)sender
{
    [self.maskView hidden];
}

- (void)didConfirmButtonClick:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [[CBLoadingView shareLoadingView] show];
    
    if ( self.memberCard.state.integerValue == kPadMemberCardStateDraft )
    {
        BSEditMemberCardRequest *request = [[BSEditMemberCardRequest alloc] initWithCard:self.memberCard];
        request.params = @{@"state":@"active"};
        [request execute];
    }
    else
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:self.memberCard.cardID forKey:@"card_id"];
        if (self.remarkstr.length != 0)
        {
            [params setObject:self.remarkstr forKey:@"remark"];
        }
        
        BSMemberCardOperateRequest *request = [[BSMemberCardOperateRequest alloc] initWithParams:params operateType:kPadMemberCardOperateActive];
        [request execute];
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
    else if ([notification.name isEqualToString:kBSEditMemberCardResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] == 0)
        {
            [self.maskView hidden];
            self.memberCard.state = @(kPadMemberCardStateActive);
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
    return kPadActiveRowCount;
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
    
    cell.contentTextField.enabled = YES;
    cell.contentTextField.textAlignment = NSTextAlignmentLeft;
    if (indexPath.row == kPadActiveCardNum)
    {
        cell.titleLabel.text = LS(@"PadMemberCard");
        cell.contentTextField.enabled = NO;
        cell.contentTextField.text = self.memberCard.cardNumber;
        cell.contentTextField.textAlignment = NSTextAlignmentCenter;
    }
    else if (indexPath.row == kPadActiveRemark)
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
    if (textField.tag - 1000 == kPadActiveRemark)
    {
        self.remarkstr = textField.text;
    }
}

@end
