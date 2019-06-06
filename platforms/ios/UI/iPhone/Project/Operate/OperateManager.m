//
//  OperateManager.m
//  Boss
//
//  Created by lining on 16/7/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "OperateManager.h"
#import "PadProjectCart.h"
#import "NSDate+Formatter.h"

@implementation OperateManager
@synthesize posOperate = _posOperate;


+ (instancetype)shareManager
{
    static OperateManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[OperateManager alloc] init];
    });
    return manager;
}


- (void)setPosOperate:(CDPosOperate *)posOperate
{
    _posOperate = posOperate;
    [self reloadPosOperate];
}


- (CDPosOperate *)posOperate
{
    if (_posOperate == nil) {
        _posOperate = [[BSCoreDataManager currentManager] insertEntity:@"CDPosOperate"];
    }
    else
    {
        if (_posOperate.isFault || _posOperate.isDeleted) {
            _posOperate = [[BSCoreDataManager currentManager] insertEntity:@"CDPosOperate"];
            _posOperate.member = self.memberCard.member;
            _posOperate.memberCard = self.memberCard;
            _posOperate.couponCard = self.couponCard;
            [self reloadPosOperate];
        }
    }
    return _posOperate;
}



- (void)setMemberCard:(CDMemberCard *)memberCard
{
    _memberCard = memberCard;
    self.posOperate.member = memberCard.member;
    self.posOperate.memberCard = memberCard;
    [self reloadPosOperate];
}

- (void)setCouponCard:(CDCouponCard *)couponCard
{
    _couponCard = couponCard;
    self.posOperate.member = couponCard.member;
    self.posOperate.couponCard = couponCard;
    [self reloadPosOperate];
}

- (void)guaDan
{
    self.posOperate.operate_date = [[NSDate date] dateString];
    self.posOperate.isLocal = @(true);
    [[BSCoreDataManager currentManager] save:nil];
 
    self.posOperate = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocalGuaDanResponse object:nil];
}

- (void)reloadPosOperate
{
    CGFloat totalAmount = 0.0;
    
    for (CDPosProduct *product in self.posOperate.products)//CDPosProduct是右边的 本次购买的  CDCurrentUseItem也是右边的 本次使用的
    {
        totalAmount += product.product_price.floatValue * product.product_qty.integerValue;
    }
    self.posOperate.amount = [NSNumber numberWithFloat:totalAmount]; //总的金额
    [[BSCoreDataManager currentManager] save:nil];
    
    [self initCardItem];
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
                BOOL isExist = NO;
                for (PadProjectCart *cart in self.cardItems)
                {
                    if (cart.item.itemID.integerValue == related.productID.integerValue)
                    {
                        isExist = YES;
                        cart.quantity += product.product_qty.integerValue * related.quantity.integerValue;
                        cart.localCount = cart.quantity;
                        break;
                    }
                }
                
                if (!isExist)
                {
                    PadProjectCart *cart = [[PadProjectCart alloc] init];
                    cart.item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:related.productID forKey:@"itemID"];
                    cart.quantity = product.product_qty.integerValue * related.quantity.integerValue;
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
            if (product.isDeposit.boolValue && product.projectCount.integerValue > 0)
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
                if (useItem.itemID.integerValue == cart.item.itemID.integerValue)
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
                if (useItem.itemID.integerValue == project.item.itemID.integerValue && useItem.cardProject.productLineID.integerValue == project.productLineID.integerValue)
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
            [self addProjectItem:item withUseCount:useItem.useCount.integerValue];
        }
    }
    

}


- (void)addObject:(NSObject *)object
{
    if ([object isKindOfClass:[CDProjectItem class]]) {
        CDProjectItem *item = (CDProjectItem *)object;
        [self addProjectItem:item withUseCount:0];
    }
    else if ([object isKindOfClass:[PadProjectCart class]])
    {
        PadProjectCart *cart = (PadProjectCart *)object;
        [self addProjectCart:cart];
    }
    else if ([object isKindOfClass:[CDMemberCardProject class]])
    {
        CDMemberCardProject *cardProject = (CDMemberCardProject *)object;
        [self addMemberCardProject:cardProject];
    }
    else if ([object isKindOfClass:[CDCouponCardProduct class]])
    {
        CDCouponCardProduct *couponProduct = (CDCouponCardProduct *)object;
        [self addMemberCouponProduct:couponProduct];
    }
}





- (CDPosProduct *)addProjectItem:(CDProjectItem *)item withUseCount:(NSInteger)useCount
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
            self.posOperate.amount = @(self.posOperate.amount.floatValue + product.product_price.floatValue);
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
        NSLog(@"count: %d",self.posOperate.products.count);
        self.posOperate.amount = @(self.posOperate.amount.floatValue + product.product_price.floatValue);
        
        [[BSCoreDataManager currentManager] save:nil];
        
        if ( product.product.bornCategory.integerValue == kPadBornCategoryCourses || product.product.bornCategory.integerValue == kPadBornCategoryPackage || product.product.bornCategory.integerValue == kPadBornCategoryPackageKit )
        {
            [self reloadPosOperate];
        }
        
        return product;
    }
    
    return nil;
}


- (CDCurrentUseItem *)addProjectCart:(PadProjectCart *)cart //点击了本次购买的项目
{
    BOOL isExist = NO;
    for (CDCurrentUseItem *useItem in self.posOperate.useItems)
    {
        if (useItem.type.integerValue == kPadUseItemCurrentPurchase && useItem.projectItem.itemID.integerValue == cart.item.itemID.integerValue)
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
                [self addProjectItem:item withUseCount:0];
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
        useItem.projectItem = cart.item;
        useItem.itemID = cart.item.itemID;
        useItem.itemName = cart.item.itemName;
        useItem.defaultCode = cart.item.defaultCode;
        useItem.uomName = cart.item.uomName;
        useItem.totalCount = [NSNumber numberWithInteger:cart.quantity];
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



- (void)addMemberCardProject:(CDMemberCardProject *)project
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
                [self addProjectItem:item withUseCount:0];
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
    }
}


- (CDCurrentUseItem *)addMemberCouponProduct:(CDCouponCardProduct *)product
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
                [self addProjectItem:item withUseCount:0];
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
