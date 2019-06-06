//
//  MemberBuyCardItemViewController.m
//  Boss
//
//  Created by mac on 15/8/7.
//
//Copyright (c) 2015年 BORN. All rights reserved.
//
#import "MemberCardDetailViewController.h"
#import "BSMemberCardOperateRequest.h"
#import "CBMessageView.h"
#import "MemberCardItemDetailViewController.h"
#import "AddProductCell.h"
#import "BSFetchTotalPriceRequest.h"
#import "CDMemberCardProject.h"
#import "ProjectViewController.h"
#import "MemberPayViewController.h"
#import "UIImage+Resizable.h"
#import "BSEditCell.h"
#import "CBLoadingView.h"
#import "MemberBuyCardItemViewController.h"

#define kBottomViewHeight  73
#define kMarginSize 20


NS_ENUM(int, CardSection)
{
    CardSectionInfo = 0,
    CardSectionPay = 1,
    CardSectionItem = 2,
    CardSectionCode = 3,
};

NS_ENUM(int, CardRow)
{
    CardRowZero = 0,
    CardRowOne  = 1,
    CardRowTwo  = 2,
    CardRowThree = 3,
};

@interface MemberBuyCardItemViewController ()<UITableViewDataSource,UITableViewDelegate,MemberPayViewControllerDelegate,UITextFieldDelegate,MemberCardItemDetailViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain)NSMutableDictionary *cachePicParams;

@end

@implementation MemberBuyCardItemViewController
- (NSMutableArray *)cardInfoArray
{
    if( _cardInfoArray==nil )
    {
        return _cardInfoArray = [[NSMutableArray alloc]init];
    }
    else
    {
        return _cardInfoArray;
    }
}

- (NSMutableArray *)cardTypeArray
{
    if(_cardTypeArray==nil)
    {
        return _cardTypeArray = [[NSMutableArray alloc]init];
    }
    
    return _cardTypeArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerNofitificationForMainThread:kBSFetchTotalPriceRequest];
    [self registerNofitificationForMainThread:kBSCardBuyItemSelectFinish];
    [self registerNofitificationForMainThread:kBSMemberCardOperateResponse];
    [self initNavigationBar];
    [self initDataWith:self.card];
    [self initBottomView];
}

- (void)initBottomView
{
    UIView *bottomView = [[UIView alloc] init];//WithFrame:CGRectMake(0, self.view.frame.size.height - kBottomViewHeight, IC_SCREEN_WIDTH, kBottomViewHeight)];
    bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bottomView];
    NSMutableArray *constarints = [[NSMutableArray alloc]init];
    
    [constarints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[bottomView]-(0)-|" options:0 metrics:nil views:@{@"bottomView":bottomView}]];
    [constarints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[bottomView(kBottomViewHeight)]-(0)-|" options:0 metrics:@{@"kBottomViewHeight":@(kBottomViewHeight)} views:@{@"bottomView":bottomView}]];
    [self.view addConstraints:constarints];
    
    UIImage *normalImg = [[UIImage imageNamed:@"order_btn_add.png"] imageResizableWithCapInsets:UIEdgeInsetsMake(10, 160, 10, 20)];
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.frame = CGRectMake(kMarginSize, (kBottomViewHeight - normalImg.size.height)/2.0, IC_SCREEN_WIDTH - 2*kMarginSize, normalImg.size.height);
    bottomBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [bottomBtn setTitle:@"添加商品" forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(bottomBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtn setBackgroundImage:normalImg forState:UIControlStateNormal];
    [bottomView addSubview:bottomBtn];
}

- (void)initDataWith:(CDMemberCard *)card
{
    [self.cardInfoArray removeAllObjects];
    [self.cardTypeArray removeAllObjects];
    NSString *balance = self.card.balance==nil?@"":self.card.balance;
    balance = [NSString stringWithFormat:@"%0.2f",[balance floatValue]];
    
    NSMutableArray *cardName = [[NSMutableArray alloc]initWithArray:@[@"会员卡类型",@"卡号",@"卡内余额"]];
    NSMutableArray *cardInfo = [[NSMutableArray alloc]initWithArray:@[self.card.priceList.name,self.card.cardNo,balance]];
    
    [self.cardTypeArray addObject:cardName];
    [self.cardInfoArray addObject:cardInfo];
    
    NSMutableArray *cardValue = [[NSMutableArray alloc]initWithArray:@[@"支付金额"]];
    NSMutableArray *cardValue1 = [[NSMutableArray alloc]initWithArray:@[@""]];
    
    [self.cardTypeArray addObject:cardValue];
    [self.cardInfoArray addObject:cardValue1];
    
    NSMutableArray *cardItem = [[NSMutableArray alloc]initWithArray:@[@"购买商品列表"]];
    NSMutableArray *cardItem1 = [[NSMutableArray alloc]initWithArray:@[@"x0"]];
    
    [self.cardTypeArray addObject:cardItem];
    [self.cardInfoArray addObject:cardItem1];
    
    self.cardProjects = [[NSMutableArray alloc]init];
    self.cachePicParams = [[NSMutableDictionary alloc]init];
}

- (void)initNavigationBar
{
    self.navigationItem.title = self.card.priceList.name;
    //self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = COLOR(242, 242, 242, 1.0);
    self.tableView.backgroundColor = [UIColor clearColor];
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    
    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc]initWithTitle:@"确定"];
    rightButtonItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

-(void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if([notification.name isEqualToString:kBSCardBuyItemSelectFinish])
    {
        CDProjectItem *item = notification.object;
        NSArray *projctArray = [self.card.projects objectEnumerator].allObjects;
        BOOL projectISExist = NO;
        CDMemberCardProject *project = nil;
        for(CDMemberCardProject *pro in projctArray)
        {
            if([pro.projectID isEqual:item.itemID])

            {
                projectISExist = YES;
                project = pro;
                break;
            }
        }
        
        if(!projectISExist)
        {
            project = [[BSCoreDataManager currentManager] insertEntity:@"CDMemberCardProject"];
            project.projectID = item.itemID;
        }
        
        project.card = self.card;
        project.defaultCode = item.defaultCode;
        project.projectName = item.itemName;
        project.item = item;
        project.projectPriceUnit = item.totalPrice;
        project.discount = [NSNumber numberWithDouble:10.0];
        project.projectCount = (project.projectCount.integerValue == 0) ? @(1) : project.projectCount;
        NSString *categorystr = [NSString stringWithFormat:@"BornCategory%d", item.bornCategory.integerValue];
        project.detailInfo = [NSString stringWithFormat:LS(@"ProjectItemDetail"), item.totalPrice.doubleValue, item.uomName, LS(categorystr), LS(item.type)];
        
        BSFetchTotalPriceRequest *request = [[BSFetchTotalPriceRequest alloc]initWithProjectID:@[project.projectID] priceListID:self.card.priceList.priceID];
        [request execute];
        BOOL isExist = NO;
        for(CDMemberCardProject *pro in self.cardProjects)
        {
            if([project.productLineID isEqual:pro.productLineID])
            {
                isExist = YES;
                int i = [pro.projectCount integerValue]+1;
                pro.projectCount = [NSNumber numberWithInteger:i];
            }
        }
        
        if(!isExist)
        {
            project.projectCount = [NSNumber numberWithInteger:1];
            [self.cardProjects addObject:project];
            self.cardInfoArray[CardSectionItem][CardRowZero] = [NSString stringWithFormat:@"x%d",self.cardProjects.count];
        }
        
        [[BSCoreDataManager currentManager] save:nil];
        [self.tableView reloadData];
    }
    else if ([notification.name isEqualToString:kBSFetchTotalPriceRequest])
    {
        if([[notification.userInfo objectForKey:@"rc"] integerValue]==0)
        {
            float total = 0;
            for(CDMemberCardProject *project in self.cardProjects)
            {
               CDMemberCardProject *project1 = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCardProject" withValue:project.productLineID forKey:@"productLineID"];
                project.projectTotalPrice = project1.projectTotalPrice;
                
                total = total + [[[BSCoreDataManager currentManager] calculateMemberCardBuyPrice:project] floatValue];
            }
            self.shouldPayAmount = @(total);
            [self.tableView reloadData];
        }
    }
    else if ([notification.name isEqualToString:kBSMemberCardOperateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if( [[notification.userInfo objectForKey:@"rc"] integerValue] == 0 )
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            CBMessageView *view = [[CBMessageView alloc]initWithTitle:[notification.userInfo objectForKey:@"rm"] afterTimeHide:1.5];
            [view showInView:self.view];
        }
    }
}

-(void)popController
{
    MemberCardDetailViewController *cardDetail = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers indexOfObject:self]-1];
    [cardDetail getData];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma UITableViewDataSource and UITableViewDelegte
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==CardSectionItem)
    {
        return self.cardProjects.count+2;
    }
    else
    {
        return ((NSArray *)self.cardTypeArray[section]).count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section!=CardSectionItem||(indexPath.section==CardSectionItem&&indexPath.row==CardRowZero))
    {
        BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell==nil)
        {
            cell = [[BSEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.contentField.placeholder = @"";
        if((indexPath.section==CardSectionInfo)||(indexPath.section==CardSectionItem&&indexPath.row==CardRowZero))
        {
            cell.arrowImageView.hidden = YES;
        }
        
        if(indexPath.section == CardSectionCode)
        {
            cell.contentField.enabled = self.isNeedManagerCode;
            cell.contentField.delegate = self;
        }
        
        cell.titleLabel.text = self.cardTypeArray[indexPath.section][indexPath.row];
        cell.contentField.text = self.cardInfoArray[indexPath.section][indexPath.row];
        
        return cell;
    }
    else if (indexPath.section==CardSectionItem&&indexPath.row==self.cardProjects.count+1)
    {
        BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"totalCell"];
        if(cell==nil)
        {
            cell = [[BSEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"totalCell"];
        }
        
        cell.arrowImageView.hidden = YES;
        cell.titleLabel.text = @"总计";
        cell.contentField.text = [NSString stringWithFormat:@"¥%0.2f",self.shouldPayAmount==nil?0.00:[self.shouldPayAmount floatValue]];
        return cell;
        
    }else
    {
        AddProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productCell"];
        if(cell==nil)
        {
            cell = [[AddProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productCell" width:IC_SCREEN_WIDTH canExpand:false];
        }
        
        CDMemberCardProject *project = (CDMemberCardProject *)self.cardProjects[indexPath.row-1];
        cell.nameLabel.text = project.projectName;
        cell.detailLabel.text = [NSString stringWithFormat:@"x%@",project.projectCount];
        cell.priceLabel.text = [[BSCoreDataManager currentManager] calculateMemberCardBuyPrice:project];
        
        [cell.picView sd_setImageWithURL:[NSURL URLWithString:project.item.imageSmallUrl] placeholderImage:[UIImage imageNamed:@"project_item_default_48_36"]];
        return cell;
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==CardSectionItem&&indexPath.row>0&&indexPath.row<self.cardProjects.count+1)
    {
        return 60;
    }
    else
    {
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ( indexPath.section == CardSectionPay && indexPath.row == CardRowZero )
    {
        MemberPayViewController *payViewController = [[MemberPayViewController alloc]initWithNibName:NIBCT(@"MemberPayViewController") bundle:nil];
        if(self.payModes==nil)
        {
            NSArray *priceArray = [[BSCoreDataManager currentManager]fetchItems:@"CDPOSPayMode" sortedByKey:@"payID"];
            NSMutableArray *payArray = [[NSMutableArray alloc]init];
            
            for(CDPOSPayMode *payMode in priceArray)
            {
                //if(![payMode.is_card boolValue]&&![payMode.is_coupon boolValue]&&![payMode.is_other_coupon boolValue])
                {
                    MemberPay *pay = [[MemberPay alloc]init];
                    pay.payID = payMode.statementID;
                    pay.payName = payMode.payName;
                    [payArray addObject:pay];
                }
            }
            
            payViewController.MemberPays = payArray;
        }
        else
        {
            payViewController.MemberPays = self.payModes;
        }

        payViewController.delegate = self;
        [self.navigationController pushViewController:payViewController animated:YES];
    }
    else if( indexPath.section > CardSectionPay && indexPath.row > CardRowZero&&indexPath.row <= self.cardProjects.count )
    {
        MemberCardItemDetailViewController *cardItemController = [[MemberCardItemDetailViewController alloc]initWithNibName:NIBCT(@"MemberCardItemDetailViewController") bundle:nil];
        cardItemController.project = self.cardProjects[indexPath.row-1];
        cardItemController.delegate = self;
        [self.navigationController pushViewController:cardItemController animated:YES];
    }
}

#pragma -Make RightButtonItem Click
-(void)didRightBarButtonItemClick:(id)sender
{
    if([self isInfoLegal])
    {
        [[CBLoadingView shareLoadingView] show];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:self.card.cardID forKey:@"card_id"];
        [params setObject:[NSArray array] forKey:@"coupon_ids"];
        [params setObject:@(0) forKey:@"now_arrears_amount"];
        
        NSMutableArray *statememtIds = [NSMutableArray array];
        for(MemberPay *pay in self.statements)
        {
            NSArray *array = @[@(0), @(NO), @{@"amount":@([pay.payMoney floatValue]), @"statement_id":pay.payID, @"point":@(0)}];
            [statememtIds addObject:array];
        }
        [params setObject:statememtIds forKey:@"statement_ids"];
        
        NSMutableArray *productLineIds = [NSMutableArray array];
        for (CDMemberCardProject *project in self.cardProjects)
        {
            NSArray *array = @[@(0), @false, @{@"product_id":project.projectID, @"price_unit":project.projectPriceUnit, @"qty":@([project.projectCount floatValue]), @"card_pay_amount":@(project.projectPriceUnit.doubleValue * project.projectCount.integerValue), @"is_deposit":@(NO)}];
            [productLineIds addObject:array];
        }
        [params setObject:productLineIds forKey:@"product_line_ids"];
        
        BSMemberCardOperateRequest *request = [[BSMemberCardOperateRequest alloc] initWithParams:params operateType:kPadMemberCardOperateCashier];
        [request execute];
    }
}

-(BOOL)isInfoLegal
{
    if([self.shouldPayAmount floatValue]!=[self.payAmount floatValue])
    {
        CBMessageView *view = [[CBMessageView alloc]initWithTitle:@"支付金额不正确" afterTimeHide:1.5];
        [view showInView:self.view];
        return NO;
    }
    else if ([self.shouldPayAmount floatValue]>0&&(self.statements==nil||self.statements.count<1))
    {
        CBMessageView *view = [[CBMessageView alloc]initWithTitle:@"无效的支付方式" afterTimeHide:1.5];
        [view showInView:self.view];
        return NO;
    }
    else if ( self.isNeedManagerCode==YES && (self.managerCode == nil || [self.managerCode isEqual:@""]) )
    {
//        CBMessageView *view = [[CBMessageView alloc]initWithTitle:@"经理授权码不能为空" afterTimeHide:1.5];
//        [view showInView:self.view];
    }
    
    return YES;
}

#pragma bottomButtonPressed
-(void)bottomBtnPressed:(UIButton *)button
{
    ProjectViewController *viewController = [[ProjectViewController alloc] initWithViewType:kProjectSelectCardBuyItem existItemIds:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma MemberPayViewControlerDelegate
-(void)didChoosedPayModeWithAmount:(NSNumber *)amount payModes:(NSArray *)payModes
{
    self.payAmount = amount;
    self.payModes = payModes;
    self.statements = [[NSMutableArray alloc] init];
    
    for(MemberPay *memberPay in payModes)
    {
        if(memberPay.payMoney!=nil&&![memberPay.payMoney isEqualToString:@"0"])
        {
            [self.statements addObject:memberPay];
        }
    }
    
    [self.cardInfoArray[1] replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"¥%.02f",[self.payAmount floatValue]]];
    [self.tableView reloadData];
}

#pragma mark - UITextFieldDelegate 
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.managerCode = textField.text;
    return YES;
}

-(void)didSetProjectInfo:(BOOL)isNeedManagerCode
{
    self.isPriceUnitChanged = isNeedManagerCode;
    [self.tableView reloadData];
}
 
-(BOOL)isNeedManagerCode
{
    for(CDMemberCardProject *project in self.cardProjects)
    {
        if([project.discount floatValue]>0)
        {
            return YES;
        }
    }
    
    if(self.isPriceUnitChanged==YES)
    {
        return YES;
    }
    return NO;
}

-(NSNumber *)shouldPayAmount
{
    float total = 0;
    for(CDMemberCardProject *project in self.cardProjects)
    {
        total = total + [[[BSCoreDataManager currentManager] calculateMemberCardBuyPrice:project] floatValue];
    }
    
    return @(total);
}

@end
