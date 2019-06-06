//
//  ProductConsumeView.m
//  ds
//
//  Created by lining on 2016/11/9.
//
//

#import "ProductConsumeView.h"
#import "ProductProjectMainController.h"
#import "BSProjectItem.h"
#import "BSConsumable.h"
#import "ConsumeEditCell.h"
#import "ShopCartCell.h"
#import "ItemCell.h"

@interface ProductConsumeView ()
@property (assign, nonatomic) ProductTmplateType type;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *deleteView;
@property (strong, nonatomic) IBOutlet UIImageView *allSelectedImgView;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;


@property (nonatomic, strong) ShopCartCell *cartCell;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, assign) BOOL isSelectedAll;
@end

@implementation ProductConsumeView

+ (instancetype)createViewWithType:(ProductTmplateType)type bornCategory:(CDBornCategory *)bornCategory
{
    ProductConsumeView *consumeView = [self loadFromNib];
    consumeView.type = type;
    consumeView.bornCategory = bornCategory;
    
    consumeView.tableView.dataSource =  consumeView;
    consumeView.tableView.delegate = consumeView;
    
    [consumeView.tableView registerNib:[UINib nibWithNibName:@"ItemCell" bundle:nil] forCellReuseIdentifier:@"ItemCell"];
    [consumeView.tableView registerNib:[UINib nibWithNibName:@"ConsumeEditCell" bundle:nil] forCellReuseIdentifier:@"ConsumeEditCell"];
    [consumeView.tableView registerNib:[UINib nibWithNibName:@"ShopCartCell" bundle:nil] forCellReuseIdentifier:@"ShopCartCell"];
    
    consumeView.cartCell = [ShopCartCell createCell];
    consumeView.cartCell.titleLabel.preferredMaxLayoutWidth = IC_SCREEN_WIDTH - 50 - 12*2 - 12;
    [consumeView registerNofitificationForMainThread:@"kAddConsumeProductDone"];
    consumeView.isEdit = false;
    
    return consumeView;
}

- (void)setProjectTemplate:(CDProjectTemplate *)projectTemplate
{
    _projectTemplate = projectTemplate;
    [self initConsumables];
}


- (void)initConsumables
{
    
    self.consumeArray = [NSMutableArray array];
    for (int i = 0; i < self.projectTemplate.consumables.count; i++)
    {
        CDProjectConsumable *consumable = [self.projectTemplate.consumables objectAtIndex:i];
        BSConsumable *bsConsumable = [[BSConsumable alloc] init];
        bsConsumable.consumableID = consumable.consumableID;
        bsConsumable.productID = consumable.productID;
        bsConsumable.productName = consumable.productName;
        bsConsumable.baseProductID = consumable.baseProductID;
        bsConsumable.baseProductName = consumable.baseProductName;
        bsConsumable.isStock = consumable.isStock.boolValue;
        bsConsumable.uomID = consumable.uomID;
        bsConsumable.uomName = consumable.uomName;
        bsConsumable.amount = consumable.amount.floatValue;
        bsConsumable.count = consumable.qty.integerValue;

        bsConsumable.projectItem = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDProjectItem" withValue:bsConsumable.productID forKey:@"itemID"];
        
        [self.consumeArray addObject:bsConsumable];
    }
}

- (void)setIsEdit:(BOOL)isEdit
{
    _isEdit = isEdit;
    if (isEdit) {
        self.deleteView.hidden = false;
        self.addBtn.hidden = true;
    }
    else
    {
        self.deleteView.hidden = true;
        self.addBtn.hidden = false;
    }
    [self.tableView reloadData];
}

- (void)setIsSelectedAll:(BOOL)isSelectedAll
{
    _isSelectedAll = isSelectedAll;
    self.allSelectedImgView.highlighted = self.isSelectedAll;
    for (BSConsumable *consumable in self.consumeArray) {
        consumable.isSelected = self.isSelectedAll;
    }
    
    [self.tableView reloadData];
    
}


- (NSMutableArray *)consumableParams
{
    NSMutableArray *params = [NSMutableArray array];
    NSMutableArray *bsConsumables = [NSMutableArray arrayWithArray:self.consumeArray];
    BOOL isTotalEdited = NO;
    if (self.type == ProductTmplateType_Edit)
    {
        for (int i = 0; i < self.projectTemplate.consumables.count; i++)
        {
            CDProjectConsumable *consumable = [self.projectTemplate.consumables objectAtIndex:i];
            BOOL isDelete = YES;
            for (int j = 0; j < bsConsumables.count; j++)
            {
                BSConsumable *bsConsumable = [bsConsumables objectAtIndex:j];
                if (bsConsumable.consumableID.integerValue != 0 && bsConsumable.consumableID.integerValue == consumable.consumableID.integerValue)
                {
                    isDelete = NO;
                    BOOL isEdited = NO;
                    if (bsConsumable.productID.integerValue != consumable.productID.integerValue || bsConsumable.uomID.integerValue != consumable.uomID.integerValue || bsConsumable.count != consumable.qty.integerValue || bsConsumable.isStock != consumable.isStock.boolValue)
                    {
                        isEdited = YES;
                        isTotalEdited = YES;
                    }
                    
                    if (!isEdited)
                    {
                        [params addObject:@[[NSNumber numberWithInteger:kBSDataLinked], bsConsumable.consumableID, [NSNumber numberWithBool:NO]]];
                    }
                    else
                    {
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        if (bsConsumable.productID.integerValue != consumable.productID.integerValue)
                        {
                            [dict setObject:bsConsumable.productID forKey:@"product_id"];
                        }
                        if (bsConsumable.uomID.integerValue != consumable.uomID.integerValue)
                        {
                            [dict setObject:bsConsumable.uomID forKey:@"uom_id"];
                        }
                        if (bsConsumable.count != consumable.qty.integerValue)
                        {
                            [dict setObject:[NSNumber numberWithInteger:bsConsumable.count] forKey:@"qty"];
                        }
                        if (bsConsumable.isStock != consumable.isStock.boolValue)
                        {
                            [dict setObject:[NSNumber numberWithBool:bsConsumable.isStock] forKey:@"is_stock"];
                        }
                        [params addObject:@[[NSNumber numberWithInteger:kBSDataUpdate], bsConsumable.consumableID, dict]];
                    }
                    
                    [bsConsumables removeObject:bsConsumable];
                    j--;
                    
                    break;
                }
            }
            
            if (isDelete)
            {
                isTotalEdited = YES;
                [params addObject:@[[NSNumber numberWithInteger:kBSDataDelete], consumable.consumableID, [NSNumber numberWithBool:NO]]];
            }
        }
    }
    
    if (!isTotalEdited && bsConsumables.count == 0)
    {
        return nil;
    }
    
    for (int i = 0; i < bsConsumables.count; i++)
    {
        BSConsumable *bsConsumable = [bsConsumables objectAtIndex:i];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              bsConsumable.productID, @"product_id",
                              bsConsumable.uomID, @"uom_id",
                              [NSNumber numberWithInteger:bsConsumable.count], @"qty",
                              [NSNumber numberWithBool:bsConsumable.isStock], @"is_stock", nil];
        [params addObject:@[[NSNumber numberWithInteger:kBSDataAdded], [NSNumber numberWithBool:NO], dict]];
    }
    
    return params;

}

#pragma mark - receivedNotification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.consumeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSConsumable *consumable = [self.consumeArray objectAtIndex:indexPath.row];
    if (self.isEdit) {
        
        ConsumeEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConsumeEditCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.consumable = consumable;
        if (indexPath.row == self.consumeArray.count - 1) {
            cell.lineImgView.hidden = true;
        }
        else
        {
            cell.lineImgView.hidden = false;
        }
        
        return cell;
    }
    else
    {
        ShopCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopCartCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = consumable.productName;
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",consumable.amount];
        cell.countLable.text = [NSString stringWithFormat:@"x%d",consumable.count];
        [cell.imgeView sd_setImageWithURL:[NSURL URLWithString:consumable.projectItem.imageSmallUrl] placeholderImage:[UIImage imageNamed:@"BornCategoryPleceHoledImage"]];
        if (indexPath.row == self.consumeArray.count - 1) {
            cell.lineImgView.hidden = true;
        }
        else
        {
            cell.lineImgView.hidden = false;
        }
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isEdit) {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.consumeArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self performSelector:@selector(reloadView) withObject:nil afterDelay:0.1];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isEdit) {
        return 85;
    }
    else
    {
        return 85;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.consumeArray.count == 0) {
        return 0;
    }
    return 40;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = COLOR(245, 245, 245, 1);
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor darkGrayColor];
    [view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.trailing.offset(-15);
        make.leading.offset(0);
    }];
    
    label.textAlignment = NSTextAlignmentRight;
    if (self.isEdit) {
        label.text = @"完成";
    }
    else
    {
        label.text = @"编辑";
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.trailing.offset(0);
        make.width.equalTo(@100);
    }];
    
    [button addTarget:self action:@selector(editBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    return view;
}

- (void)editBtnPressed
{
    self.isEdit = !self.isEdit;
    
}

- (void)reloadView
{
    if (self.consumeArray.count == 0) {
        self.deleteView.hidden = true;
        self.addBtn.hidden = false;
        self.isEdit = false;
        self.allSelectedImgView.highlighted = false;
        self.isSelectedAll = false;
    }
    [self.tableView reloadData];
}

#pragma mark - button action

- (IBAction)addBtnPressed:(id)sender {
    
//    NSMutableArray *exsistsItemIds = [NSMutableArray array];
//    for (BSConsumable *consumable in self.bsItem.consumables) {
//        [exsistsItemIds addObject:consumable.productID];
//    }
    
    ProductProjectMainController *productProjectMainVC = [[ProductProjectMainController alloc] init];
    productProjectMainVC.templateBornCategory = self.bornCategory;
    productProjectMainVC.controllerType = ProductControllerType_Consume;
//    productProjectMainVC.existsItemIds = exsistsItemIds;
    productProjectMainVC.consumeArray = self.consumeArray;
    [self.viewController.navigationController pushViewController:productProjectMainVC animated:YES];
}


- (IBAction)selecteAllBtnPressed:(id)sender {
    self.isSelectedAll = !self.isSelectedAll;
   
}

- (IBAction)deleteBtnPressed:(id)sender {
    for (int i = 0; i < self.consumeArray.count; i ++) {
        BSConsumable *consumable = [self.consumeArray objectAtIndex:i];
        if (consumable.isSelected) {
            [self.consumeArray removeObject:consumable];
        }
    }
    
    [self reloadView];
    
    
}

#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
