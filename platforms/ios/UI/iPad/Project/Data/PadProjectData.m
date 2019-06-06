//
//  PadProjectData.m
//  Boss
//
//  Created by XiaXianBing on 15/10/26.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadProjectData.h"

@implementation PadProjectData

@synthesize currentCategory = _currentCategory;

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        self.projectArray = [NSArray array];
        self.existItemIds = [NSArray array];
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:[[BSCoreDataManager currentManager] fetchAllBornCategory]];
        if (![PersonalProfile currentProfile].isFreeCombination.boolValue)
        {
            for (CDBornCategory *bornCategory in mutableArray)
            {
                if (bornCategory.code.integerValue == kPadBornFreeCombination)
                {
                    [mutableArray removeObject:bornCategory];
                    break;
                }
            }
        }
        self.types = [NSArray arrayWithArray:mutableArray];
        self.bornCategory = [self.types objectAtIndex:0];
        
        [self initCardItem];
        [self initBornCategories];
    }
    
    return self;
}

- (void)relaodBornCategories
{
    [self initBornCategories];
}

- (void)initBornCategories
{
    [self reloadPosOperate];
#if 0
    for (int i = 0; i < self.types.count; i++)
    {
        CDBornCategory *bornCategory = [self.types objectAtIndex:i];
        if (bornCategory.code.integerValue >= kPadBornCategoryProduct && bornCategory.code.integerValue <= kPadBornCategoryPackageKit)
        {
            NSArray *types = [NSArray arrayWithObject:bornCategory.code];
            NSArray *otherItems = [[BSCoreDataManager currentManager] fetchProjectItemsWithType:kProjectItemDefault bornCategorys:types categoryIds:@[[NSNumber numberWithInteger:0]] existItemIds:self.existItemIds keyword:nil priceAscending:NO];
            bornCategory.otherCount = [NSNumber numberWithInteger:otherItems.count];
            NSArray *totalItems = [[BSCoreDataManager currentManager] fetchProjectItemsWithType:kProjectItemDefault bornCategorys:types categoryIds:nil existItemIds:self.existItemIds keyword:nil priceAscending:NO];
            bornCategory.totalCount = [NSNumber numberWithInteger:totalItems.count];
        }
    }
#endif
}

- (void)initCardItem
{
    //卡内项目 和 本次购买的
    self.cardItems = [NSMutableArray array];
    for (CDPosProduct *product in self.posOperate.products)
    {
        CDProjectItem *item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:product.product_id forKey:@"itemID"];
        if (item.bornCategory.integerValue == kPadBornCategoryCourses || item.bornCategory.integerValue == kPadBornCategoryPackage || item.bornCategory.integerValue == kPadBornCategoryPackageKit)
        {
            for (CDProjectRelated *related in item.subRelateds)//疗程和套餐里的子项目
            {
                NSLog(@"%@",related);
//                BOOL isExist = NO;
//                for (PadProjectCart *cart in self.cardItems)
//                {
//                    if (cart.item.itemID.integerValue == related.productID.integerValue)
//                    {
//                        isExist = YES;
//                        NSInteger count = 0;
//                        if ( [product.change_qty integerValue] > 0 )
//                        {
//                            count = [product.change_qty integerValue];
//                        }
//                        else
//                        {
//                            count = related.quantity.integerValue;
//                        }
//
//                        cart.quantity += product.product_qty.integerValue * count;
//                        cart.localCount = cart.quantity;
//                        break;
//                    }
//                }
//
//                if (!isExist)
//                {
                    PadProjectCart *cart = [[PadProjectCart alloc] init];
                
                    cart.item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:related.productID forKey:@"itemID"];

                    NSInteger count = 0;
                    if ( [product.change_qty integerValue] > 0 )
                    {
                        count = [product.change_qty integerValue];
                    }
                    else
                    {
                        count = related.quantity.integerValue;
                    }
                    cart.quantity = product.product_qty.integerValue * count;
                    cart.localCount = cart.quantity;
                NSLog(@"%@",cart.item);
                    cart.parentID = product.product_id;
                if (cart.item.bornCategory.intValue == kPadBornCategoryProject) {
                    [self.cardItems addObject:cart];
                }
            
            }
//                }
        }
        else if (item.bornCategory.integerValue == kPadBornCategoryProject )
        {
            if ( [item.package_count integerValue] > 0 )
            {
                BOOL isExist = NO;
                for (PadProjectCart *cart in self.cardItems)
                {
                    if (cart.item.itemID.integerValue == item.itemID.integerValue)
                    {
                        isExist = YES;
                        cart.quantity += product.product_qty.integerValue * item.package_count.integerValue;
                        cart.localCount = cart.quantity;
                        break;
                    }
                }
                
                if (!isExist)
                {
                    PadProjectCart *cart = [[PadProjectCart alloc] init];
                    cart.item = item;
                    cart.quantity = product.product_qty.integerValue * item.package_count.integerValue;
                    cart.localCount = cart.quantity;
                    [self.cardItems addObject:cart];
                }
            }
        }
    }
    
    if (!self.posOperate.member.isDefaultCustomer.boolValue)
    {
        for (CDMemberCardProject *product in self.posOperate.memberCard.products)//卡内产品
        {
            if (product.isDeposit.boolValue && product.projectCount.boolValue > 0)
            {
                product.localCount = [NSNumber numberWithInteger:product.projectCount.integerValue];
                [self.cardItems addObject:product];
            }
        }
        
        for (CDMemberCardProject *project in self.posOperate.memberCard.projects)//卡内项目
        {
            if (project.projectCount.integerValue > 0)
            {
                project.localCount = [NSNumber numberWithInteger:project.projectCount.integerValue];
                [self.cardItems addObject:project];
            }
        }
        
        for (CDCouponCardProduct *project in self.posOperate.couponCard.products)
        {
            if (project.remainQty.integerValue > 0)
            {
                project.localCount = [NSNumber numberWithInteger:project.remainQty.integerValue];
                [self.cardItems addObject:project];
            }
        }
    }
    
    for (CDCurrentUseItem *useItem in self.posOperate.useItems)//本次使用
    {
        BOOL isExist = NO;
        for (NSObject *object in self.cardItems)
        {
            if ([object isKindOfClass:[PadProjectCart class]])//本次购买的 但不在卡里的 如果卡里有 是CDMemberCardProject
            {
                PadProjectCart *cart = (PadProjectCart *)object;
                NSLog(@"%@",useItem.projectItem);
                if ( useItem.type.integerValue == kPadUseItemCurrentPurchase && useItem.itemID.integerValue == cart.item.itemID.integerValue && useItem.parent_id.integerValue == [cart.parentID integerValue])
                {
                    isExist = YES;
                    useItem.totalCount = [NSNumber numberWithInteger:cart.quantity];
                    if (useItem.useCount.integerValue > useItem.totalCount.integerValue)
                    {
                        useItem.useCount = [NSNumber numberWithInteger:useItem.totalCount.integerValue];
                    }
                    cart.localCount = cart.quantity - useItem.useCount.integerValue;
                    [[BSCoreDataManager currentManager] save:nil];
                    break;
                }
            }
            else if ([object isKindOfClass:[CDMemberCardProject class]])
            {
                CDMemberCardProject *project = (CDMemberCardProject *)object;
                if ( useItem.type.integerValue == kPadUseItemMemberCardProject && useItem.itemID.integerValue == project.item.itemID.integerValue && useItem.cardProject.productLineID.integerValue == project.productLineID.integerValue)
                {
                    isExist = YES;
                    useItem.totalCount = [NSNumber numberWithInteger:project.projectCount.integerValue];
                    if (useItem.useCount.integerValue > useItem.totalCount.integerValue)
                    {
                        useItem.useCount = [NSNumber numberWithInteger:useItem.totalCount.integerValue];
                    }
                    project.localCount = [NSNumber numberWithInteger:project.projectCount.integerValue - useItem.useCount.integerValue];
                    [[BSCoreDataManager currentManager] save:nil];
                    break;
                }
            }
            else if ([object isKindOfClass:[CDCouponCardProduct class]])
            {
                CDCouponCardProduct *product = (CDCouponCardProduct *)object;
                if (useItem.itemID.integerValue == product.item.itemID.integerValue && useItem.couponProject.productLineID.integerValue == product.productLineID.integerValue)
                {
                    isExist = YES;
                    useItem.totalCount = [NSNumber numberWithInteger:product.remainQty.integerValue];
                    if (useItem.useCount.integerValue > useItem.totalCount.integerValue)
                    {
                        useItem.useCount = [NSNumber numberWithInteger:useItem.totalCount.integerValue];
                    }
                    product.localCount = [NSNumber numberWithInteger:product.remainQty.integerValue - useItem.useCount.integerValue];
                    [[BSCoreDataManager currentManager] save:nil];
                    break;
                }
            }
        }
        
        if (!isExist)
        {
            NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.posOperate.useItems];
            [orderedSet removeObject:useItem];
            self.posOperate.useItems = orderedSet;
            
            CDProjectItem *item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:useItem.itemID forKey:@"itemID"];
            [self didAddPosOperateWithProjectItem:item withUseCount:useItem.useCount.integerValue];
        }
    }
    
    if (self.cardItemCount != self.cardItems.count)
    {
        self.cardItemCount = self.cardItems.count;
    }
}


#pragma mark -
#pragma mark init Methods

- (void)setCurrentCategory:(CDProjectCategory *)category //点菜单的时候调用的
{
    if (category == nil)
    {
        _currentCategory = nil;
        self.subCategoryArray = [NSArray array];
        return;
    }
    
    _currentCategory = category;
    NSArray *subCategories = _currentCategory.subCategory.array;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemCount != %@", [NSNumber numberWithInteger:0]];
    self.subCategoryArray = [subCategories filteredArrayUsingPredicate:predicate];
}

- (NSArray *)subCategoryIds:(CDProjectCategory *)category
{
    if ( category.categoryID == nil )
        return [NSArray array];
    
    NSMutableArray *ids = [NSMutableArray array];
    [ids addObject:category.categoryID];
    for (int i = 0; i < category.subCategory.count; i++)
    {
        CDProjectCategory *subCategory = [category.subCategory objectAtIndex:i];
        NSArray *subIds = [self subCategoryIds:subCategory];
        [ids addObjectsFromArray:subIds];
    }
    
    return  [NSArray arrayWithArray:ids];
}

- (void)setMemberCard:(CDMemberCard *)memberCard
{
    _memberCard = memberCard;
    [self reloadPosOperate];
}

- (void)setCouponCard:(CDCouponCard *)couponCard
{
    _couponCard = couponCard;
    [self reloadPosOperate];
}


#pragma mark -
#pragma mark PosOperate Methods

- (void)reloadPosOperate
{
    CGFloat totalAmount = 0.0;
    
    for (CDPosProduct *product in self.posOperate.products)//CDPosProduct是右边的 本次购买的  CDCurrentUseItem也是右边的 本次使用的
    {
        totalAmount += roundf(product.product_price.doubleValue * product.product_qty.integerValue * 100) / 100 - product.coupon_deduction.doubleValue - product.point_deduction.doubleValue;
    }
    
    if (self.posOperate.amount != nil)
    {
        self.posOperate.amount = [NSNumber numberWithDouble:totalAmount]; //总的金额
    }
    
    [[BSCoreDataManager currentManager] save:nil];
    
    [self initCardItem];
}


#pragma mark -
#pragma mark ProjectItem Methods

- (void)reloadProjectItem
{
    [self reloadProjectItemWithBornCategory:self.bornCategory];
}

- (void)reloadOnlyParantProjectItem //只取没有分类的项目
{
    [self reloadProjectItemWithBornCategory:self.bornCategory onlyParaent:YES];
}

- (void)reloadProjectItemWithBornCategory:(CDBornCategory *)bornCategory
{
    [self reloadProjectItemWithBornCategory:bornCategory onlyParaent:FALSE];
}

- (void)reloadProjectItemWithBornCategory:(CDBornCategory *)bornCategory onlyParaent:(BOOL)onlyParent//点了最外层的才会调用
{
    self.isOnlyParent = onlyParent;
    
    self.bornCategory = bornCategory;
    self.keyword = @"";
    self.isSearch = NO;
    
    [self reloadPosOperate];
    
    NSArray *categoryIds = [NSArray array];
    if (self.currentCategory != nil)
    {
        if ( onlyParent )
        {
            categoryIds = @[self.currentCategory.categoryID];
        }
        else
        {
            categoryIds = [self subCategoryIds:self.currentCategory];
        }
    }
    else if ( onlyParent )
    {
        categoryIds = @[@(0)];
    }
    
    NSMutableArray* finalArray = [NSMutableArray array];
    NSArray* array = [[BSCoreDataManager currentManager] fetchProjectItemsWithType:kProjectItemDefault bornCategorys:nil categoryIds:categoryIds existItemIds:self.existItemIds keyword:self.keyword priceAscending:self.isPriceSortASC];
    NSMutableDictionary* tempParams = [NSMutableDictionary dictionary];
    for ( CDProjectItem* item in array )
    {
        if ( item.project_group_name.length > 0 )
        {
            NSNumber* t = tempParams[item.project_group_name];
            if ( [t boolValue] )
            {
                continue;
            }
            
            tempParams[item.project_group_name] = @(TRUE);
        }
        
        [finalArray addObject:item];
    }
    
    self.projectArray = finalArray;
}

- (void)reloadProjectItemWithKeyword:(NSString *)keyword
{
    self.isSearch = YES;
    self.keyword = keyword;
    self.resultType = kPadProjectResultSearch;
    NSMutableArray *types = [NSMutableArray array];
    NSArray *bornCategories = [[BSCoreDataManager currentManager] fetchAllBornCategory];
    for (CDBornCategory *category in bornCategories)
    {
        [types addObject:category.code];
    }
    
    NSMutableArray* finalArray = [NSMutableArray array];
    NSArray* array = [[BSCoreDataManager currentManager] fetchProjectItemsWithType:kProjectItemDefault bornCategorys:types categoryIds:nil existItemIds:nil keyword:self.keyword priceAscending:self.isPriceSortASC];
    NSMutableDictionary* tempParams = [NSMutableDictionary dictionary];
    for ( CDProjectItem* item in array )
    {
        if ( item.project_group_name.length > 0 )
        {
            NSNumber* t = tempParams[item.project_group_name];
            if ( [t boolValue] )
            {
                continue;
            }
            
            tempParams[item.project_group_name] = @(TRUE);
        }
        
        [finalArray addObject:item];
    }
    
    self.projectArray = finalArray;
}


#pragma mark -
#pragma mark PosOperate Edit Methods

- (CDPosProduct *)didAddPosOperateWithProjectItem:(CDProjectItem *)item
{
    return [self didAddPosOperateWithProjectItem:item withUseCount:0]; //点了左边跳到右边的时候
}

- (CDPosProduct *)didAddPosOperateWithProjectItem:(CDProjectItem *)item withUseCount:(NSInteger)useCount//进入详情里面修改数量后调用
{
    BOOL isExist = NO;
    for (CDPosProduct *product in self.posOperate.products)
    {
        if (product.product_id.integerValue == item.itemID.integerValue)
        {
            isExist = YES;
            if (useCount == 0)
            {
                product.product_qty = [NSNumber numberWithInteger:product.product_qty.integerValue + 1];
            }
            else
            {
                product.product_qty = [NSNumber numberWithInteger:product.product_qty.integerValue + useCount];
            }
            product.money_total = [NSNumber numberWithFloat:product.product_qty.integerValue * product.product_price.floatValue];
            self.posOperate.amount = @(self.posOperate.amount.doubleValue + product.product_price.doubleValue);
            [[BSCoreDataManager currentManager] save:nil];
            
            if (product.product.bornCategory.integerValue == kPadBornCategoryCourses || product.product.bornCategory.integerValue == kPadBornCategoryPackage || product.product.bornCategory.integerValue == kPadBornCategoryPackageKit)
            {
                [self reloadPosOperate];
            }
            
            break;
        }
    }
    
    if (!isExist)
    {
        CDPosProduct *product = [[BSCoreDataManager currentManager] insertEntity:@"CDPosProduct"];
        product.product = item;
        product.product_id = item.itemID;
        product.product_name = item.itemName;
        product.lastUpdate = item.lastUpdate;
        product.defaultCode = item.defaultCode;
        product.category_id = item.categoryID;
        product.category_name = item.categoryName;
        product.product_price = item.totalPrice;
        if (useCount == 0)
        {
            product.product_qty = [NSNumber numberWithInteger:1];
        }
        else
        {
            product.product_qty = [NSNumber numberWithInteger:useCount];
        }
        product.product_discount = [NSNumber numberWithFloat:10.0];
        product.imageUrl = item.imageUrl;
        product.imageSmallUrl = item.imageSmallUrl;
        product.money_total = @(product.product_price.floatValue * product.product_qty.floatValue);
        NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.posOperate.products];
        [orderedSet addObject:product];
        self.posOperate.products = orderedSet;
        self.posOperate.amount = @(product.product_price.doubleValue + self.posOperate.amount.doubleValue);
        
        [[BSCoreDataManager currentManager] save:nil];
        
        if ( product.product.bornCategory.integerValue == kPadBornCategoryCourses || product.product.bornCategory.integerValue == kPadBornCategoryPackage || product.product.bornCategory.integerValue == kPadBornCategoryPackageKit )
        {
            [self reloadPosOperate];
        }
        else if ( item.bornCategory.integerValue == kPadBornCategoryProject && [item.package_count integerValue] > 0 )
        {
            [self reloadPosOperate];
        }
        
        return product;
    }
    
    return nil;
}

- (CDCurrentUseItem *)didAddPosOperateWithCart:(PadProjectCart *)cart//点了左边的卡内项目
{
    BOOL isExist = NO;
    for (CDCurrentUseItem *useItem in self.posOperate.useItems)
    {
        NSLog(@"%@",cart.item);
        if (useItem.type.integerValue == kPadUseItemCurrentPurchase && useItem.projectItem.itemID.integerValue == cart.item.itemID.integerValue && useItem.parent_id.integerValue == cart.parentID.integerValue )
        {
            isExist = YES;
            useItem.totalCount = [NSNumber numberWithInteger:cart.quantity];
            if (useItem.useCount.integerValue < useItem.totalCount.integerValue)
            {
                useItem.useCount = [NSNumber numberWithInteger:useItem.useCount.integerValue + 1];
            }
            else
            {
                useItem.useCount = [NSNumber numberWithInteger:cart.quantity];
                CDProjectItem *item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:useItem.projectItem.itemID forKey:@"itemID"];
                [self didAddPosOperateWithProjectItem:item];
            }
            cart.localCount = cart.quantity - useItem.useCount.integerValue;
            
            [[BSCoreDataManager currentManager] save:nil];
            break;
        }
    }
    
    if (!isExist)
    {
        CDCurrentUseItem *useItem = [[BSCoreDataManager currentManager] insertEntity:@"CDCurrentUseItem"];
        useItem.type = [NSNumber numberWithInteger:kPadUseItemCurrentPurchase];
        NSLog(@"%@",cart.item);
        useItem.projectItem = cart.item;
        useItem.itemID = cart.item.itemID;
        useItem.itemName = cart.item.itemName;
        useItem.defaultCode = cart.item.defaultCode;
        useItem.uomName = cart.item.uomName;
        useItem.totalCount = [NSNumber numberWithInteger:cart.quantity];
        useItem.parent_id = [NSNumber numberWithInteger:cart.parentID.integerValue];
        useItem.useCount = [NSNumber numberWithInteger:1];
        NSMutableOrderedSet *mutableSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.posOperate.useItems];
        [mutableSet addObject:useItem];
        cart.localCount = cart.quantity - useItem.useCount.integerValue;
        self.posOperate.useItems = mutableSet;
        
        [[BSCoreDataManager currentManager] save:nil];
        return useItem;
    }
    
    return nil;
}

- (CDCurrentUseItem *)didAddPosOperateWithMemberCardProject:(CDMemberCardProject *)project
{
    BOOL isExist = NO;
    for (CDCurrentUseItem *useItem in self.posOperate.useItems)
    {
        if (useItem.type.integerValue == kPadUseItemMemberCardProject && useItem.itemID.integerValue == project.projectID.integerValue && useItem.cardProject.productLineID.integerValue == project.productLineID.integerValue)
        {
            isExist = YES;
            useItem.totalCount = [NSNumber numberWithInteger:project.projectCount.integerValue];
            if (useItem.useCount.integerValue < useItem.totalCount.integerValue)
            {
                useItem.useCount = [NSNumber numberWithInteger:useItem.useCount.integerValue + 1];
            }
            else
            {
                CDProjectItem *item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:project.projectID forKey:@"itemID"];
                [self didAddPosOperateWithProjectItem:item];
            }
            project.localCount = [NSNumber numberWithInteger:project.projectCount.integerValue - useItem.useCount.integerValue];
            [[BSCoreDataManager currentManager] save:nil];
            
            break;
        }
    }
    
    if (!isExist)
    {
        CDCurrentUseItem *useItem = [[BSCoreDataManager currentManager] insertEntity:@"CDCurrentUseItem"];
        useItem.type = [NSNumber numberWithInteger:kPadUseItemMemberCardProject];
        useItem.projectItem = project.item;
        useItem.cardProject = project;
        useItem.itemID = project.projectID;
        useItem.itemName = project.projectName;
        useItem.uomName = project.uomName;
        useItem.defaultCode = project.defaultCode;
        useItem.totalCount = [NSNumber numberWithInteger:project.projectCount.integerValue];
        useItem.useCount = [NSNumber numberWithInteger:1];
        NSMutableOrderedSet *mutableSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.posOperate.useItems];
        [mutableSet addObject:useItem];
        self.posOperate.useItems = mutableSet;
        project.localCount = [NSNumber numberWithInteger:project.projectCount.integerValue - useItem.useCount.integerValue];
        
        [[BSCoreDataManager currentManager] save:nil];
        return useItem;
    }
    
    return nil;
}

- (CDCurrentUseItem *)didAddPosOperateWithCouponCardProduct:(CDCouponCardProduct *)product
{
    BOOL isExist = NO;
    for (CDCurrentUseItem *useItem in self.posOperate.useItems)
    {
        if (useItem.type.integerValue == kPadUseItemCouponCardProject && useItem.itemID.integerValue == product.productID.integerValue && useItem.couponProject.productLineID.integerValue == product.productLineID.integerValue)
        {
            isExist = YES;
            useItem.totalCount = [NSNumber numberWithInteger:product.remainQty.integerValue];
            if (useItem.useCount.integerValue < useItem.totalCount.integerValue)
            {
                useItem.useCount = [NSNumber numberWithInteger:useItem.useCount.integerValue + 1];
            }
            else
            {
                CDProjectItem *item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:product.productID forKey:@"itemID"];
                [self didAddPosOperateWithProjectItem:item];
            }
            product.localCount = [NSNumber numberWithInteger:product.remainQty.integerValue - useItem.useCount.integerValue];
            
            [[BSCoreDataManager currentManager] save:nil];
            break;
        }
    }
    
    if (!isExist)
    {
        CDCurrentUseItem *useItem = [[BSCoreDataManager currentManager] insertEntity:@"CDCurrentUseItem"];
        useItem.type = [NSNumber numberWithInteger:kPadUseItemCouponCardProject];
        useItem.projectItem = product.item;
        useItem.couponProject = product;
        useItem.itemID = product.productID;
        useItem.itemName = product.productName;
        useItem.uomName = product.uomName;
        useItem.defaultCode = product.defaultCode;
        useItem.totalCount = [NSNumber numberWithInteger:product.remainQty.integerValue];
        useItem.useCount = [NSNumber numberWithInteger:1];
        NSMutableOrderedSet *mutableSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.posOperate.useItems];
        [mutableSet addObject:useItem];
        self.posOperate.useItems = mutableSet;
        product.localCount = [NSNumber numberWithInteger:product.remainQty.integerValue - useItem.useCount.integerValue];
        
        [[BSCoreDataManager currentManager] save:nil];
        return useItem;
    }
    
    return nil;
}

@end
