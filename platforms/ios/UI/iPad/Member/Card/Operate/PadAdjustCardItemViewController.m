//
//  PadAdjustCardItemViewController.m
//  meim
//
//  Created by jimmy on 17/2/8.
//
//

#import "PadAdjustCardItemViewController.h"
#import "PadAdjustItemTableViewCell.h"
#import "PadAdjustItemCardNoTableViewCell.h"
#import "PadProjectDetailViewController.h"
#import "PadInputItemViewController.h"
#import "PadAdjustItemRemarkTableViewCell.h"
#import "BSMemberCardOperateRequest.h"
#import "CBLoadingView.h"
#import "CBMessageView.h"

typedef enum PadAdjustCardItemSection
{
    PadAdjustCardItemSection_CardNo,
    PadAdjustCardItemSection_Item,
    PadAdjustCardItemSection_Remark,
    PadAdjustCardItemSection_Count
}PadAdjustCardItemSection;

@interface PadAdjustCardItemViewController ()<PadProjectDetailViewControllerDelegate, PadInputItemViewControllerDelegate>
@property(nonatomic, weak)IBOutlet UITableView* tableView;
@property(nonatomic, strong)NSMutableArray* cardProjectArray;
@property(nonatomic, strong)NSMutableArray* originalProjectArray;
@end

@implementation PadAdjustCardItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PadAdjustItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"PadAdjustItemTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PadAdjustItemCardNoTableViewCell" bundle:nil] forCellReuseIdentifier:@"PadAdjustItemCardNoTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PadAdjustItemRemarkTableViewCell" bundle:nil] forCellReuseIdentifier:@"PadAdjustItemRemarkTableViewCell"];
    
    self.cardProjectArray = [NSMutableArray array];
    for ( CDMemberCardProject* item in self.memberCard.projects.array )
    {
        if ( [item.remainQty integerValue] < 1 )
            continue;
        
        CDPosProduct* p = [[BSCoreDataManager currentManager] insertEntity:@"CDPosProduct"];
        p.product_name = item.projectName;
        p.product_qty = item.remainQty;
        p.product_price = item.projectPriceUnit;
        p.product_discount = @(10);
        p.product_id = item.projectID;
        p.line_id = item.productLineID;
        [self.cardProjectArray addObject:p];
    }
    
    self.originalProjectArray = [NSMutableArray arrayWithArray:self.cardProjectArray];
    
    [self registerNofitificationForMainThread:kBSMemberCardOperateResponse];
}

-(void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSMemberCardOperateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if( [[notification.userInfo objectForKey:@"rc"] integerValue] == 0 )
        {
            [self.maskView hidden];
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:PadAdjustCardItemSection_Item];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else
        {
            CBMessageView *view = [[CBMessageView alloc]initWithTitle:[notification.userInfo objectForKey:@"rm"] afterTimeHide:1.5];
            [view showInView:self.view];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return PadAdjustCardItemSection_Count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ///调整卡项修改
    //老代码
//    if ( section == PadAdjustCardItemSection_Item )
//        return self.cardProjectArray.count + 1;
//
//    return 1;
    //新代码
    if ( section == PadAdjustCardItemSection_Item )
    {
        return self.cardProjectArray.count;///移除"添加"按钮
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == PadAdjustCardItemSection_CardNo )
    {
        return [self tableView:tableView cellForCardNoRowAtIndexPath:indexPath];
    }
    else if ( indexPath.section == PadAdjustCardItemSection_Item )
    {
        return [self tableView:tableView cellForItemRowAtIndexPath:indexPath];
    }
    else if ( indexPath.section == PadAdjustCardItemSection_Remark )
    {
        return [self tableView:tableView cellForRemarkRowAtIndexPath:indexPath];
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForCardNoRowAtIndexPath:(NSIndexPath *)indexPath
{
    PadAdjustItemCardNoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PadAdjustItemCardNoTableViewCell"];
    cell.card = self.memberCard;
    
    return cell;
}
///调整卡项修改
- (UITableViewCell *)tableView:(UITableView *)tableView cellForItemRowAtIndexPath:(NSIndexPath *)indexPath
{
    PadAdjustItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PadAdjustItemTableViewCell"];
    
    CDPosProduct* cardProject = nil;
    
    //老代码
//    if ( indexPath.row == 0 )
//    {
//        if ( self.cardProjectArray.count == 0 )
//        {
//            cell.bgImageView.image = [[UIImage imageNamed:@"pos_text_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
//        }
//        else
//        {
//            cell.bgImageView.image = [[UIImage imageNamed:@"pos_cell_bg_t"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
//        }
//    }
//    else if ( indexPath.row == self.cardProjectArray.count )
//    {
//        cardProject = self.cardProjectArray[indexPath.row - 1];
//        cell.bgImageView.image = [[UIImage imageNamed:@"pos_cell_bg_b"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
//    }
//    else
//    {
//        cardProject = self.cardProjectArray[indexPath.row - 1];
//        cell.bgImageView.image = [[UIImage imageNamed:@"pos_cell_bg_m"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
//    }
    
    //新代码
    cardProject = self.cardProjectArray[indexPath.row];
    cell.bgImageView.image = [[UIImage imageNamed:@"pos_cell_bg_m"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
    if ( indexPath.row == 0 )
    {
        cell.bgImageView.image = [[UIImage imageNamed:@"pos_cell_bg_t"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
        ///只有一个cell的时候 用四周都切过圆角的背景
        if (self.cardProjectArray.count == 1){
            cell.bgImageView.image = [[UIImage imageNamed:@"pos_text_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
        }
    }
    ///最后一个cell
    else if ( indexPath.row == self.cardProjectArray.count - 1)
    {
        //cardProject = self.cardProjectArray[indexPath.row];
        cell.bgImageView.image = [[UIImage imageNamed:@"pos_cell_bg_b"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
        //cell.backgroundColor = [UIColor orangeColor];
    }
    else {
        cell.bgImageView.image = [[UIImage imageNamed:@"pos_cell_bg_m"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
    }
    //end 新代码
    
    cell.cardProject = cardProject;
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRemarkRowAtIndexPath:(NSIndexPath *)indexPath
{
    PadAdjustItemRemarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PadAdjustItemRemarkTableViewCell"];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == PadAdjustCardItemSection_CardNo )
    {
        return 282;
    }
    else if ( indexPath.section == PadAdjustCardItemSection_Remark )
    {
        return 160;
    }
    
    return 57;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( section == PadAdjustCardItemSection_Item )
    {
        return 40;
    }
    
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v = [[UIView alloc] initWithFrame:CGRectZero];
    v.backgroundColor = [UIColor whiteColor];
    if ( section == PadAdjustCardItemSection_Item )
    {
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(67, 0, kPadMaskViewContentWidth, 20.0)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
        titleLabel.font = [UIFont systemFontOfSize:16.0];
        titleLabel.text = @"卡内项目";
        [v addSubview:titleLabel];
    }
    
    return v;
}
///调整卡项修改
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //老代码
//    if ( indexPath.section == PadAdjustCardItemSection_Item )
//    {
//        if ( indexPath.row == 0 )
//        {
//            PadInputItemViewController *inputViewController = [[PadInputItemViewController alloc] initWithMemberCard:self.memberCard couponCard:nil];
//            inputViewController.maskView = self.maskView;
//            inputViewController.orignalProjectArray = self.cardProjectArray;
//            inputViewController.delegate = self;
//            [self.navigationController pushViewController:inputViewController animated:YES];
//        }
//        else
//        {
//            CDPosProduct *product = (CDPosProduct*)[self.cardProjectArray objectAtIndex:indexPath.row - 1];
//            PadProjectDetailViewController *viewController = [[PadProjectDetailViewController alloc] initWithPosProduct:product detailType:kPadProjectDetailCurrentCashier];
//            viewController.delegate = self;
//            viewController.noTechnician = TRUE;
//            [self.navigationController pushViewController:viewController animated:YES];
//        }
//    }
    
    //新代码
    if ( indexPath.section == PadAdjustCardItemSection_Item )
    {
        CDPosProduct *product = (CDPosProduct*)[self.cardProjectArray objectAtIndex:indexPath.row];
        PadProjectDetailViewController *viewController = [[PadProjectDetailViewController alloc] initWithPosProduct:product detailType:kPadProjectDetailCurrentCashier];
        viewController.delegate = self;
        viewController.noTechnician = TRUE;
        viewController.hiddenProductPrice = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (IBAction)didCloseButtonPressed:(id)sender
{
    [self.maskView hidden];
}

- (void)didPadPosProductDelete:(CDPosProduct *)product
{
    [self.cardProjectArray removeObject:product];
//    [self.tableView reloadData];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:PadAdjustCardItemSection_Item];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didPadPosProductConfirm:(CDPosProduct *)product
{
//    [self.tableView reloadData];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:PadAdjustCardItemSection_Item];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didPadInputItemViewControllerConfirmButtonPressed:(NSArray*)itemArray
{
    self.cardProjectArray = [NSMutableArray arrayWithArray:itemArray];
//    [self.tableView reloadData];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:PadAdjustCardItemSection_Item];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (IBAction)didConfirmButtonPressed:(id)sender
{
    NSMutableArray* now = [NSMutableArray arrayWithArray:self.cardProjectArray];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableArray* productLines = [NSMutableArray array];
    
    [params setObject:self.memberCard.cardID forKey:@"card_id"];

    for ( int j = 0; j < now.count; j++ )
    {
        CDPosProduct* p = now[j];
        if ( [p.line_id integerValue] > 0 )
        {
            [productLines addObject:@[@(4),p.line_id,@(FALSE)]];
            [productLines addObject:@[@(1),p.line_id, @{@"product_id":p.product_id, @"qty":p.product_qty}]];
        }
        else
        {
            NSArray* array = @[@(0), @(NO), @{@"product_id":p.product_id, @"price_unit":p.product_price, @"qty":p.product_qty,@"is_deposit":@(NO)}];
            [productLines addObject:array];
        }
        
        [self.originalProjectArray removeObject:p];
    }
    
    for ( CDPosProduct* p in self.originalProjectArray )
    {
        [productLines addObject:@[@(4),p.line_id,@(FALSE)]];
        [productLines addObject:@[@(1),p.line_id, @{@"product_id":p.product_id, @"qty":@(0)}]];
    }
    
    [params setObject:productLines forKey:@"product_ids"];
    
    [params setObject:@(TRUE) forKey:@"is_update"];
    
    PadAdjustItemCardNoTableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:PadAdjustCardItemSection_CardNo]];
    
    CGFloat cardAmount = [cell.amountTextField.text floatValue];
    if ( fabs([self.memberCard.amount floatValue] - cardAmount) > 0.05 )
    {
        [params setObject:@(cardAmount) forKey:@"amount"];
    }
    
    CGFloat point = [cell.pointTextField.text floatValue];
    if ( fabs([self.memberCard.points floatValue] - point) > 0.05 )
    {
        [params setObject:@(point) forKey:@"point"];
    }
    
    PadAdjustItemRemarkTableViewCell* cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:PadAdjustCardItemSection_Remark]];
    if ( cell2 )
    {
        [params setObject:cell2.remarkTextField.text forKey:@"remark"];
    }
    
    BSMemberCardOperateRequest *request = [[BSMemberCardOperateRequest alloc] initWithParams:params operateType:kPadMemberCardOperateCashier];
    [request execute];
    
    [[CBLoadingView shareLoadingView] show];
}

@end
