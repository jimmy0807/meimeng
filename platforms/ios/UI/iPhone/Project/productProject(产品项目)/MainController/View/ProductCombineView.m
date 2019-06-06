//
//  ProductCombineOrConsumeView.m
//  ds
//  组合或消耗品View
//  Created by lining on 2016/10/31.
//
//

#import "ProductCombineView.h"
#import "BSConsumable.h"
#import "BSProjectItem.h"
#import "BSSubItem.h"
#import "ProductProjectMainController.h"
#import "ShopCartCell.h"
#import "CombineDetailViewController.h"
#import "UILabel+LineSpace.h"

@interface ProductCombineView ()<UITableViewDataSource,UITableViewDelegate>
@property (assign, nonatomic) ProductTmplateType type;

@end

@implementation ProductCombineView

+ (instancetype)createViewWithType:(ProductTmplateType)type bornCategory:(CDBornCategory *)bornCategory
{
    ProductCombineView *view =  [self loadFromNib];
    view.type = type;
    view.bornCategory = bornCategory;
    view.tableView.dataSource = view;
    view.tableView.delegate = view;
    
    [view.tableView registerNib:[UINib nibWithNibName:@"ShopCartCell" bundle:nil] forCellReuseIdentifier:@"ShopCartCell"];
    
    [view registerNofitificationForMainThread:@"kAddSubItemDone"];
    [view registerNofitificationForMainThread:@"kEditSubItemDone"];
    
    if (view.bornCategory.code.integerValue == kPadBornCategoryCourses || view.bornCategory.code.integerValue == kPadBornCategoryPackage) {
        
    }
    
    UIView *footview  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0,60)];
    UILabel *label = [[UILabel alloc] init];
    [footview addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
    
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor grayColor];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:12];
    [label setText:[NSString stringWithFormat:@"注意:之前已购买过此%@的会员，其卡内相应的东西不会改变,如需变更请手动调整卡项",view.bornCategory.bornCategoryName] lineSpace:4];
    view.tableView.tableFooterView = footview;
    
    
    return view;
}


- (void)setProjectTemplate:(CDProjectTemplate *)projectTemplate
{
    _projectTemplate = projectTemplate;
    [self initSubItems];
}


- (void)initSubItems
{
    self.subItems = [NSMutableArray array];
    if (self.projectTemplate.bornCategory.integerValue == kPadBornCategoryProduct || self.projectTemplate.bornCategory.integerValue == kPadBornCategoryProject || self.projectTemplate.projectItems.count == 0)
    {
        return;
    }
    
    CDProjectItem *projectItem = [self.projectTemplate.projectItems objectAtIndex:0];
    for (int i = 0; i < projectItem.subRelateds.count; i++)
    {
        CDProjectRelated *related = [projectItem.subRelateds.allObjects objectAtIndex:i];
        BSSubItem *bsSubItem = [[BSSubItem alloc] init];
        bsSubItem.relatedID = related.relatedID;
        bsSubItem.itemID = related.productID;
        bsSubItem.itemName = related.productName;
        bsSubItem.parentItemID = related.parentProductID;
        bsSubItem.parentItemName = related.parentProductName;
        bsSubItem.count = related.quantity.integerValue;
        bsSubItem.itemPrice = related.openPrice.floatValue;
        bsSubItem.itemSetPrice = related.price.floatValue;
        bsSubItem.isUnlimited = related.isUnlimited.boolValue;
        bsSubItem.unlimitedDays = related.unlimitedDays.integerValue;
        CDProjectItem *item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:related.productID forKey:@"itemID"];
        bsSubItem.projectType = item.bornCategory.integerValue;
        if (related.sameItems.count != 0)
        {
            bsSubItem.projectType = kPadBornCategoryProject;
        }
        
        bsSubItem.sameItems = [NSMutableArray array];
        for (int j = 0; j < related.sameItems.count; j++)
        {
            CDProjectItem *item = [related.sameItems objectAtIndex:j];
            [bsSubItem.sameItems addObject:item];
        }
        
        bsSubItem.projectItem = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDProjectItem" withValue:bsSubItem.itemID forKey:@"itemID"];
    
        [self.subItems addObject:bsSubItem];
    }
}

- (NSInteger)subItemsCount
{
    return self.subItems.count;
}

- (NSArray *)subItemsParams
{
    NSMutableArray *params = [NSMutableArray array];
    NSMutableArray *bsSubItems = [NSMutableArray arrayWithArray:self.subItems];
    BOOL isTotalEdited = NO;
    if (self.type == ProductTmplateType_Edit)
    {
        if (self.projectTemplate.projectItems.count == 0)
        {
            return nil;
        }
        
        CDProjectItem *projectItem = [self.projectTemplate.projectItems objectAtIndex:0];
        for (int i = 0; i < projectItem.subRelateds.count; i++)
        {
            BOOL isDelete = YES;
            CDProjectRelated *related = [projectItem.subRelateds.allObjects objectAtIndex:i];
            
            for (int j = 0; j < bsSubItems.count; j++)
            {
                BSSubItem *bsSubItem = [bsSubItems objectAtIndex:j];
                if (bsSubItem.relatedID.integerValue != 0 && bsSubItem.relatedID.integerValue == related.relatedID.integerValue)
                {
                    isDelete = NO;
                    BOOL isEdited = NO;
                    if (bsSubItem.itemID.integerValue != related.productID.integerValue || bsSubItem.count != related.quantity.integerValue || bsSubItem.itemSetPrice != related.price.floatValue || bsSubItem.sameItems.count != related.sameItems.count)
                    {
                        isEdited = YES;
                        isTotalEdited = YES;
                    }
                    else if (bsSubItem.isUnlimited != related.isUnlimited.boolValue)
                    {
                        isEdited = YES;
                        isTotalEdited = YES;
                    }
                    else if (bsSubItem.isUnlimited == related.isUnlimited.boolValue && bsSubItem.isUnlimited && bsSubItem.unlimitedDays != related.unlimitedDays.integerValue)
                    {
                        isEdited = YES;
                        isTotalEdited = YES;
                    }
                    else
                    {
                        if (bsSubItem.sameItems.count != related.sameItems.count)
                        {
                            isEdited = YES;
                            isTotalEdited = YES;
                        }
                        else
                        {
                            for (int k = 0; k < bsSubItem.sameItems.count; k++)
                            {
                                BOOL isExist = NO;
                                CDProjectItem *bsItem = [bsSubItem.sameItems objectAtIndex:k];
                                for (int l = 0; l < related.sameItems.count; l++)
                                {
                                    CDProjectItem *item = [related.sameItems objectAtIndex:l];
                                    if (bsItem.itemID.integerValue == item.itemID.integerValue)
                                    {
                                        isExist = YES;
                                        break;
                                    }
                                }
                                
                                if (!isExist)
                                {
                                    isEdited = YES;
                                    isTotalEdited = YES;
                                    break;
                                }
                            }
                        }
                    }
                    
                    if (!isEdited)
                    {
                        [params addObject:@[[NSNumber numberWithInteger:kBSDataLinked], bsSubItem.relatedID, [NSNumber numberWithBool:NO]]];
                    }
                    else
                    {
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        [dict setObject:[NSNumber numberWithBool:YES] forKey:@"is_show_more"];
                        if (bsSubItem.itemID.integerValue != 0 && bsSubItem.itemID.integerValue != related.productID.integerValue)
                        {
                            [dict setObject:bsSubItem.itemID forKey:@"product_id"];
                        }
                        
                        if (bsSubItem.itemSetPrice != related.price.floatValue)
                        {
                            [dict setObject:[NSNumber numberWithFloat:bsSubItem.itemSetPrice] forKey:@"lst_price"];
                        }
                        
                        if (bsSubItem.count != related.quantity.integerValue)
                        {
                            [dict setObject:[NSNumber numberWithInteger:bsSubItem.count] forKey:@"quantity"];
                        }
                        
                        if (bsSubItem.isUnlimited != related.isUnlimited.boolValue)
                        {
                            [dict setObject:[NSNumber numberWithInteger:bsSubItem.isUnlimited] forKey:@"limited_qty"];
                            if (bsSubItem.isUnlimited)
                            {
                                [dict setObject:[NSNumber numberWithInteger:bsSubItem.unlimitedDays] forKey:@"limited_date"];
                            }
                        }
                        else
                        {
                            if (bsSubItem.isUnlimited && bsSubItem.unlimitedDays != related.unlimitedDays.integerValue)
                            {
                                [dict setObject:[NSNumber numberWithInteger:bsSubItem.unlimitedDays] forKey:@"limited_date"];
                            }
                        }
                        
                        
                        if (bsSubItem.projectType == kPadBornCategoryProject)
                        {
                            NSMutableArray *sameIds = [NSMutableArray array];
                            for (int k = 0; k < bsSubItem.sameItems.count; k++)
                            {
                                CDProjectItem *bsItem = [bsSubItem.sameItems objectAtIndex:k];
                                [sameIds addObject:bsItem.itemID];
                            }
                            [dict setObject:@[@[[NSNumber numberWithInteger:kBSDataExist], [NSNumber numberWithBool:NO], sameIds]] forKey:@"same_ids"];
                            
                            
                            if (bsSubItem.isShowMore != related.is_show_more.boolValue) {
                                [dict setObject:@(bsSubItem.isShowMore) forKey:@"is_show_more"];
                            }
                            
                            if (bsSubItem.samePriceReplace != related.same_price_replace.boolValue) {
                                [dict setObject:@(bsSubItem.samePriceReplace) forKey:@"same_price_replace"];
                            }
                            
                            if (bsSubItem.samePriceReplaceMax - related.same_price_replace_max.floatValue > 0.001) {
                                [dict setObject:@(bsSubItem.samePriceReplaceMax) forKey:@"same_price_replace_max"];
                            }
                            if (bsSubItem.samePriceReplaceMin - related.same_price_replace_min.floatValue > 0.001) {
                                [dict setObject:@(bsSubItem.samePriceReplaceMin) forKey:@"same_price_replace_min"];
                            }

                            
                        }
                        
                        [params addObject:@[[NSNumber numberWithInteger:kBSDataUpdate], bsSubItem.relatedID, dict]];
                    }
                    
                    [bsSubItems removeObject:bsSubItem];
                    j--;
                    
                    break;
                }
            }
            
            if (isDelete)
            {
                isTotalEdited = YES;
                [params addObject:@[[NSNumber numberWithInteger:kBSDataDelete], related.relatedID, [NSNumber numberWithBool:NO]]];
            }
        }
    }
    
    if (!isTotalEdited && bsSubItems.count == 0)
    {
        return nil;
    }
    
    for (int i = 0; i < bsSubItems.count; i++)
    {
        BSSubItem *bsSubItem = [bsSubItems objectAtIndex:i];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     bsSubItem.itemID, @"product_id",
                                     [NSNumber numberWithFloat:bsSubItem.itemSetPrice], @"lst_price",
                                     [NSNumber numberWithInteger:bsSubItem.count], @"quantity", nil];
        
        [dict setObject:[NSNumber numberWithInteger:bsSubItem.isUnlimited] forKey:@"limited_qty"];
        if (bsSubItem.isUnlimited)
        {
            [dict setObject:[NSNumber numberWithInteger:bsSubItem.unlimitedDays] forKey:@"limited_date"];
        }
        
        if (bsSubItem.projectType == kPadBornCategoryProject)
        {
            NSMutableArray *sameIds = [NSMutableArray array];
            for (int j = 0; j < bsSubItem.sameItems.count; j++)
            {
                CDProjectItem *item = [bsSubItem.sameItems objectAtIndex:j];
                [sameIds addObject:item.itemID];
            }
            [dict setObject:@[@[[NSNumber numberWithInteger:kBSDataExist], [NSNumber numberWithBool:NO], sameIds]] forKey:@"same_ids"];
            
            
            [dict setObject:@(bsSubItem.isShowMore) forKey:@"is_show_more"];
            [dict setObject:@(bsSubItem.samePriceReplace) forKey:@"same_price_replace"];
            [dict setObject:@(bsSubItem.samePriceReplaceMax) forKey:@"same_price_replace_max"];
            [dict setObject:@(bsSubItem.samePriceReplaceMin) forKey:@"same_price_replace_min"];
            
        }
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
    return self.subItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    BSSubItem *subItem = [self.subItems objectAtIndex:indexPath.row];
    ShopCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopCartCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = subItem.itemName;
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",subItem.itemSetPrice];
    cell.countLable.text = [NSString stringWithFormat:@"x%d",subItem.count];
    [cell.imgeView sd_setImageWithURL:[NSURL URLWithString:subItem.projectItem.imageSmallUrl] placeholderImage:[UIImage imageNamed:@"BornCategoryPleceHoledImage"]];
    if (indexPath.row == self.subItems.count - 1) {
        cell.lineImgView.hidden = true;
    }
    else
    {
        cell.lineImgView.hidden = false;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.subItems removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self performSelector:@selector(reloadView) withObject:nil afterDelay:0.1];
    }
}

- (void)reloadView
{
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.subItems.count == 0) {
        return 0;
    }
    return 20;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIImageView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BSSubItem *subItem = [self.subItems objectAtIndex:indexPath.row];
    
    CombineDetailViewController *combineDetailVC = [[CombineDetailViewController alloc] init];
    combineDetailVC.subItem = subItem;
    [self.viewController.navigationController pushViewController:combineDetailVC animated:YES];
}

#pragma mark - button action
- (IBAction)addBtnPressed:(id)sender {
    ProductProjectMainController *productMainVC = [[ProductProjectMainController alloc] init];
    productMainVC.controllerType = ProductControllerType_SubItem;
    productMainVC.templateBornCategory = self.bornCategory;
    productMainVC.subItems = self.subItems;
    [self.viewController.navigationController pushViewController:productMainVC animated:YES];
}


#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
