//
//  BSProjectData.m
//  Boss
//
//  Created by XiaXianBing on 15/10/26.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSProjectData.h"

@implementation BSProjectData

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        self.projectArray = [NSArray array];
        self.existItemIds = [NSArray array];
        self.type = kPadBornCategoryProduct;
        [self reloadProjectItem];
    }
    
    return self;
}

- (void)reloadProjectItem
{
    [self reloadProjectItemWithType:self.type];
}

- (void)reloadProjectItemWithType:(kPadBornCategoryType)type
{
    self.type = type;
    [self initCategory];
    [self initProjectItem];
}

- (void)initCurrentCategory:(CDProjectCategory *)category
{
    self.currentCategory = category;
    NSArray *subCategories = self.currentCategory.subCategory.array;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemCount != %@", [NSNumber numberWithInteger:0]];
    self.subCategoryArray = [subCategories filteredArrayUsingPredicate:predicate];
}

- (void)initCategory
{
    NSArray *allItems = [[BSCoreDataManager currentManager] fetchAllProjectItem];
    NSArray *categorys = [[BSCoreDataManager currentManager] fetchAllProjectCategory];
    if (allItems.count == 0)
    {
        for (int i = 0; i < categorys.count; i++)
        {
            CDProjectCategory *category = [categorys objectAtIndex:i];
            category.itemCount = [NSNumber numberWithInteger:0];
        }
        [[BSCoreDataManager currentManager] save:nil];
        
        self.otherCount = 0;
        self.totalCount = 0;
        
        return ;
    }
    
    NSArray *types = [NSArray arrayWithObject:[NSNumber numberWithInteger:self.type]];
    for (int i = 0; i < categorys.count; i++)
    {
        CDProjectCategory *category = [categorys objectAtIndex:i];
        NSArray *categoryIds = [self subCategoryIds:category];
        NSArray *items = [[BSCoreDataManager currentManager] fetchProjectItemsWithType:kProjectItemDefault bornCategorys:types categoryIds:categoryIds existItemIds:self.existItemIds keyword:nil priceAscending:NO];
        category.itemCount = [NSNumber numberWithInteger:items.count];
    }
    [[BSCoreDataManager currentManager] save:nil];
    
    NSArray *otherItems = [[BSCoreDataManager currentManager] fetchProjectItemsWithType:kProjectItemDefault bornCategorys:types categoryIds:@[[NSNumber numberWithInteger:0]] existItemIds:self.existItemIds keyword:nil priceAscending:NO];
    self.otherCount = otherItems.count;
    NSArray *totalItems = [[BSCoreDataManager currentManager] fetchProjectItemsWithType:kProjectItemDefault bornCategorys:types categoryIds:nil existItemIds:self.existItemIds keyword:nil priceAscending:NO];
    self.totalCount = totalItems.count;
}

- (void)initProjectItem
{
    if (self.type >= kPadBornCategoryProduct && self.type <= kPadBornCategoryPackageKit)
    {
        NSArray *types = [NSArray arrayWithObject:[NSNumber numberWithInteger:self.type]];
        NSArray *categoryIds = [NSArray array];
        if (self.currentCategory != nil)
        {
            categoryIds = [self subCategoryIds:self.currentCategory];
        }
        
        self.projectArray = [[BSCoreDataManager currentManager] fetchProjectItemsWithType:kProjectItemDefault bornCategorys:types categoryIds:categoryIds existItemIds:self.existItemIds keyword:self.keyword priceAscending:self.isPriceSortASC];
    }
}

- (NSArray *)subCategoryIds:(CDProjectCategory *)category
{
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

@end
