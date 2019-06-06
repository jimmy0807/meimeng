//
//  MemberCardDetailViewController.m
//  Boss
//
//  Created by mac on 15/7/25.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "MemberBuyCardItemViewController.h"
#import "BSEditCell.h"
#import "CBMessageView.h"
#import "CBLoadingView.h"
#import "BNRightButtonItem.h"
#import "BSImportMemberCardRequest.h"
#import "BSFetchMemberCardProjectRequest.h"
#import "BSFetchMemberCardDetailRequest.h"
#import "MemberCardItemViewController.h"
#import "MemberCardDetailViewController.h"
#import "MemberCreateCardViewController.h"

@interface MemberCardDetailViewController ()<UITableViewDataSource,UITableViewDelegate,BNRightButtonItemDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MemberCardDetailViewController
- (NSMutableArray *)cardInfoArray
{
    if(_cardInfoArray==nil)
    {
        return _cardInfoArray = [[NSMutableArray alloc]init];
    }else{
        return _cardInfoArray;
    }
}

- (NSMutableArray *)cardTypeArray
{
    if(_cardTypeArray==nil)
    {
        return _cardTypeArray = [[NSMutableArray alloc]init];
    }return _cardTypeArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigationBar];
    [self registerNofitificationForMainThread:kBSFetchMemberCardResponse];
    [self registerNofitificationForMainThread:kBSImportMemberCardResponse];
    [self registerNofitificationForMainThread:kBSFetchMemberCardDetailResponse];
    [self registerNofitificationForMainThread:kBSFetchMemberCardProjectResponse];
    
    [self getData];
    [self initDataWith:self.card];
}

- (void)getData
{
    BSFetchMemberCardDetailRequest *request = [[BSFetchMemberCardDetailRequest alloc] initWithMemberCardID:self.card.cardID];
    [request execute];
}

- (void)initDataWith:(CDMemberCard *)card
{
    [self.cardInfoArray removeAllObjects];
    [self.cardTypeArray removeAllObjects];
    NSMutableArray *cardName = [[NSMutableArray alloc]initWithArray:@[@"会员卡类型",@"卡号"]];
    NSMutableArray *cardInfo = [[NSMutableArray alloc]initWithArray:@[self.card.priceList.name,self.card.cardNo]];
    
    [self.cardTypeArray addObject:cardName];
    [self.cardInfoArray addObject:cardInfo];
 
    NSString *balance = self.card.balance==nil?@"":self.card.balance;
    balance = [NSString stringWithFormat:@"%0.2f",[balance floatValue]];
    NSMutableArray *cardValue = [[NSMutableArray alloc]initWithArray:@[@"卡内余额", @"卡内项目", @"购买的产品"]];
    NSMutableArray *cardValue1 = [[NSMutableArray alloc]initWithArray:@[balance, @"", @""]];
    
    [self.cardTypeArray addObject:cardValue];
    [self.cardInfoArray addObject:cardValue1];
}

- (void)initNavigationBar
{
    self.navigationItem.title = self.card.priceList.name;
    //self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = COLOR(242, 242, 242, 1.0);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    
    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc]initWithTitle:@"操作"];
    rightButtonItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}


-(void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if([notification.name isEqualToString:kBSFetchMemberCardResponse])
    {
        if([[notification.userInfo objectForKey:@"rc"] integerValue]==0)
        {
            [self initDataWith:self.card];
            [self.tableView reloadData];
        }
    }
    else if ([notification.name isEqualToString:kBSImportMemberCardResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            ;
        }
    }
    else if ([notification.name isEqualToString:kBSFetchMemberCardDetailResponse] || [notification.name isEqualToString:kBSFetchMemberCardProjectResponse])
    {
        if([[notification.userInfo objectForKey:@"rc"] integerValue]==0)
        {
            [self initDataWith:self.card];
            [self.tableView reloadData];
        }
    }
}
#pragma UITableViewDataSource and UITableViewDelegte
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)self.cardTypeArray[section]).count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil)
    {
        cell = [[BSEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.arrowImageView.hidden = YES;
    cell.titleLabel.text = self.cardTypeArray[indexPath.section][indexPath.row];
    cell.contentField.placeholder = @"";
    cell.contentField.text = self.cardInfoArray[indexPath.section][indexPath.row];
    if(indexPath.section == 1)
    {
        if (indexPath.row == 1)
        {
            cell.arrowImageView.hidden = NO;
            double total = 0;
            for(CDMemberCardProject *project in self.card.projects.array)
            {
                total = total+[project.projectTotalPrice floatValue];
            }
            cell.contentField.text =[NSString stringWithFormat:@"¥%0.2f", total];
        }
        else if (indexPath.row == 2)
        {
            cell.arrowImageView.hidden = NO;
            double total = 0;
            for (CDMemberCardProject *product in self.card.products.array)
            {
                total = total + product.projectTotalPrice.floatValue;
            }
            cell.contentField.text =[NSString stringWithFormat:@"¥%0.2f", total];
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cardTypeArray.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1 && indexPath.row != 0)
    {
        MemberCardItemViewController *item = [[MemberCardItemViewController alloc]initWithNibName:NIBCT(@"MemberCardItemViewController") bundle:nil];
        CDMemberCard *card = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCard" withValue:self.card.cardID forKey:@"cardID"];
        item.cardID = self.card.cardID;
        item.pricelist_id = self.card.priceList.priceID;
        item.memberID = self.card.member.memberID;
        item.card = self.card;
        if (indexPath.row == 1)
        {
            item.title = @"卡内项目";
            item.cardProject = card.projects.array;
        }
        else if (indexPath.row == 2)
        {
            item.title = @"购买的产品";
            item.cardProject = card.products.array;
        }
        [self.navigationController pushViewController:item animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma -Make RightButtonItem Click
-(void)didRightBarButtonItemClick:(id)sender
{
    if([[PersonalProfile currentProfile].posID isEqual:@0]||[PersonalProfile currentProfile].posID==nil)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:LS(@"PleaseVisitTheWebAndSetUserProfiles")
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        if ( [self.card.isActive boolValue] )
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"充值",@"购买",@"获取微卡激活码", nil];
            [actionSheet showInView:self.view];
        }
        else
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确认生效",@"获取微卡激活码", nil];
            [actionSheet showInView:self.view];
        }
        
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( [self.card.isActive boolValue] )
    {
        if ( buttonIndex == 0 || buttonIndex == 1 )
        {
            PersonalProfile* profile = [PersonalProfile currentProfile];
            if ( profile.posID.integerValue > 0 )
            {
                if ( [profile.havePos boolValue] )
                {
                    
                }
                else
                {
                    NSString *message = @"";
                    if (buttonIndex == 0)
                    {
                        message = @"你的账号不能充值";
                    }
                    else if (buttonIndex == 1)
                    {
                        message = @"你的账号不能购买";
                    }
                    CBMessageView *view = [[CBMessageView alloc] initWithTitle:message];
                    [view showInView:self.view];
                    
                    return;
                }
            }
            else
            {
                CBMessageView *view = [[CBMessageView alloc]initWithTitle:@"你的账号没有绑定POS"];
                [view showInView:self.view];
                return;
            }
        }
        
        if( buttonIndex == 0 )
        {
            MemberCreateCardViewController *recharge = [[MemberCreateCardViewController alloc]initWithNibName:NIBCT(@"MemberCreateCardViewController") bundle:nil];
            recharge.card = self.card;
            recharge.operateType = CardOperateRecharge;
            [self.navigationController pushViewController:recharge animated:YES];
        }
        else if (buttonIndex==1)
        {
            
            MemberBuyCardItemViewController *buy = [[MemberBuyCardItemViewController alloc]initWithNibName:NIBCT(@"MemberBuyCardItemViewController") bundle:nil];
            buy.card = self.card;
            [self.navigationController pushViewController:buy animated:YES];
        }
        else if (buttonIndex == 2)
        {
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:nil message:self.card.captcha delegate:nil cancelButtonTitle:@"我记住了" otherButtonTitles:nil, nil];
            [view show];
        }
    }
    else
    {
        if ( buttonIndex == 0 )
        {
            [[CBLoadingView shareLoadingView] show];
            BSImportMemberCardRequest *request = [[BSImportMemberCardRequest alloc] initWithMemberCardID:self.card.cardID];
            [request execute];
        }
        else if ( buttonIndex == 1 )
        {
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:nil message:self.card.captcha delegate:nil cancelButtonTitle:@"我记住了" otherButtonTitles:nil, nil];
            [view show];
        }
    }
}

@end
