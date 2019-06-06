//
//  BSCoreDataManager+Customized.m
//  Boss
//
//  Created by jimmy on 15/5/11.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSCoreDataManager+Customized.h"
#import "HomeCountData.h"
#import "BSDataManager.h"


@implementation BSCoreDataManager (Customized)

- (NSString *)fetchLastUpdateTimeWithEntityName:(NSString *)entityName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastUpdate" ascending:false];
    NSArray *sortArry = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArry];
    fetchRequest.fetchLimit = 1;
    
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (array.count > 0)
    {
        id object = [array objectAtIndex:0];
        if (object && [object respondsToSelector:@selector(lastUpdate)])
        {
            NSString *lastUpdate = [object performSelector:@selector(lastUpdate) withObject:nil];
            return lastUpdate;
        }
    }
    
    return nil;
}

- (CDTodayIncomeMain*)fetchTodayIncomeDetail
{
    CDTodayIncomeMain* main = [[BSCoreDataManager currentManager] findEntity:@"CDTodayIncomeMain" withValue:[[HomeCountData currentData] getToday] forKey:@"today"];
    
    return main;
}

- (NSArray*)fetchHomePassengerFlowDetail
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"today == %@",[[HomeCountData currentData] getToday]];
    NSArray* array = [[BSCoreDataManager currentManager] fetchItems:@"CDPassengerFlow" sortedByKey:@"itemID" ascending:YES predicate:predicate];
    
    return array;
}

- (NSArray*)fetchHomeMyTodayIncomeDetail
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"today == %@",[[HomeCountData currentData] getToday]];
    NSArray* array = [[BSCoreDataManager currentManager] fetchItems:@"CDMyTodayInComeItem" sortedByKey:@"itemID" ascending:YES predicate:predicate];
    
    return array;
}

- (NSString *)fetchPermissionLastUpdateTime
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDPermission" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"last_time" ascending:false];
    NSArray *sortArry = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArry];
    fetchRequest.fetchLimit = 1;
    
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    CDPermission *permisson;
    if (array.count > 0) {
        permisson = [array objectAtIndex:0];
    }
    
    return permisson.last_time;
}

- (NSString *)fetchPermissionModelLastUpdateTime
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDPermissionModel" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"last_time" ascending:false];
    NSArray *sortArry = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArry];
    fetchRequest.fetchLimit = 1;
    
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    CDPermissionModel *permissonModel;
    if (array.count > 0) {
        permissonModel = [array objectAtIndex:0];
    }
    
    return permissonModel.last_time;
}

- (NSArray *)fetchAllStoreList
{
    return [self fetchItems:@"CDStore" sortedByKey:@"storeID" ascending:YES predicate:nil];
}

- (NSArray *)fetchStoreListWithShopID:(NSArray *)shopId
{
    NSPredicate *predicate = nil;
    if (shopId) {
        predicate = [NSPredicate predicateWithFormat:@"storeID in %@",shopId];
    }
    
    return [self fetchItems:@"CDStore" sortedByKey:@"storeID" ascending:YES predicate:predicate];
}

- (NSArray *)fetchAllUser
{
    return [self fetchAllUserWithStartDate:nil endDate:nil];
}

- (NSArray *)fetchAllUserWithStartDate:(NSString *)startDate endDate:(NSString *)endDate
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDUser" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:true];
    NSArray *sortArry = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArry];
    
    if (startDate)
    {
        NSPredicate *predicate;
        if (endDate)
        {
            predicate  = [NSPredicate predicateWithFormat:@"birthday >= %@ and birthday < %@",startDate,endDate];
        }
        else
        {
            predicate  = [NSPredicate predicateWithFormat:@"birthday == %@",startDate];
        }
        [fetchRequest setPredicate:predicate];
    }
    
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchChangedUsersWithCurrentUserID:(NSNumber *)userId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDUser" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_id != %@", userId];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"user_id" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchAllPermissionModels
{
    return [self fetchItems:@"CDPermissionModel" sortedByKey:@"modelID" ascending:YES];
}

- (NSArray *)fetchAllPermissions
{
    return [self fetchItems:@"CDPermission" sortedByKey:@"permissionID" ascending:YES];
}

#pragma mark - Staff 员工

- (NSArray *)fetchAllStaffs
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"staffID > %@",@0];//防止取出我们本地自己新建的员工
    return [self fetchItems:@"CDStaff" sortedByKey:@"staffID" ascending:YES predicate:predicate];
}

- (NSArray *)fetchStaffsWithShopID:(NSNumber *)shopID 
{
    NSMutableString *filterString = [NSMutableString  stringWithFormat:@"staffID > %@",@0];
    if ([shopID integerValue] > 0 )
    {
        //[filterString appendFormat:@"&& store.storeID == %@",shopID];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:filterString];
    return [self fetchItems:@"CDStaff" sortedByKey:@"staffID" ascending:YES predicate:predicate];
}

- (NSArray *)fetchShejishiStaffsWithShopID:(NSNumber *)shopID
{
    NSMutableString *filterString = [NSMutableString  stringWithFormat:@"staffID > %@",@0];
    if ([shopID integerValue] > 0 )
    {
        //[filterString appendFormat:@" && store.storeID == %@",shopID];
    }
    
    [filterString appendFormat:@"&& hr_category == \"%@\"",@"designers"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:filterString];
    return [self fetchItems:@"CDStaff" sortedByKey:@"staffID" ascending:YES predicate:predicate];
}

- (NSArray *)fetchDoctorStaffsWithShopID:(NSNumber *)shopID
{
    NSMutableString *filterString = [NSMutableString  stringWithFormat:@"staffID > %@",@0];
    if ([shopID integerValue] > 0 )
    {
        //[filterString appendFormat:@" && store.storeID == %@",shopID];
    }
    
    //[filterString appendFormat:@"&& hr_category == \"%@\"",@"Designers"];
    [filterString appendFormat:@"&& hr_category == \"%@\"",@"doctors"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:filterString];
    return [self fetchItems:@"CDStaff" sortedByKey:@"staffID" ascending:YES predicate:predicate];
}

- (NSArray *)fetchOperateStaffsWithShopID:(NSNumber *)shopID
{
    NSMutableString *filterString = [NSMutableString stringWithFormat:@"staffID > %@",@0];
    if ([shopID integerValue] > 0 )
    {
        //[filterString appendFormat:@" && store.storeID == %@",shopID];
    }
    
    [filterString appendFormat:@"&& hr_category == \"%@\"",@"operater"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:filterString];
    return [self fetchItems:@"CDStaff" sortedByKey:@"staffID" ascending:YES predicate:predicate];
}

- (NSArray *)fetchGuwenStaffsWithShopID:(NSNumber *)shopID
{
    NSMutableString *filterString = [NSMutableString  stringWithFormat:@"staffID > %@",@0];
    if ([shopID integerValue] > 0)
    {
        //[filterString appendFormat:@" && store.storeID == %@",shopID];
    }
    
    [filterString appendFormat:@" && hr_category == \"%@\"",@"adviser"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:filterString];
    return [self fetchItems:@"CDStaff" sortedByKey:@"staffID" ascending:YES predicate:predicate];
}

- (NSArray *)fetchShejizongjianStaffsWithShopID:(NSNumber *)shopID
{
    NSMutableString *filterString = [NSMutableString  stringWithFormat:@"staffID > %@",@0];
    if ([shopID integerValue] > 0)
    {
        //[filterString appendFormat:@"&& store.storeID == %@",shopID];
    }
    
    [filterString appendFormat:@"&& hr_category == \"%@\"",@"director"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:filterString];
    return [self fetchItems:@"CDStaff" sortedByKey:@"staffID" ascending:YES predicate:predicate];
}

- (NSArray *)fetchStaffsWithShopID:(NSNumber *)shopID need_role_id:(bool)need_role_id
{
    NSMutableString *filterString = [NSMutableString  stringWithFormat:@"staffID > %@",@0];
    if ([shopID integerValue] > 0) {
        [filterString appendFormat:@"&& store.storeID == %@",shopID];
    }
    if (need_role_id) {
        [filterString appendFormat:@"&& rule_id != %@",@0];
    }
   
    NSPredicate *predicate = [NSPredicate predicateWithFormat:filterString];
     
    return [self fetchItems:@"CDStaff" sortedByKey:@"staffID" ascending:YES predicate:predicate];
}

- (NSArray *)fetchAllStaffDepartments
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"department_id > %@",@0];
    return [self fetchItems:@"CDStaffDepartment" sortedByKey:@"department_id" ascending:YES predicate:predicate] ;
}

- (NSArray *)fetchAllStaffJobs
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"job_id > %@",@0];
    return [self fetchItems:@"CDStaffJob" sortedByKey:@"job_id" ascending:YES predicate:predicate];
}

- (NSArray *)fetchAllStaffRoles
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"roleID > %@",@0];
    return [self fetchItems:@"CDStaffRole" sortedByKey:@"roleID" ascending:YES predicate:predicate];
}

#pragma mark -
#pragma mark 手术安排
- (NSArray<CDTeam *> *)fetchAllShoushuTeam
{
    return [self fetchItems:@"CDTeam" sortedByKey:@"team_id" ascending:YES];
}

#pragma mark -
#pragma mark PosConfig Methods

- (NSArray *)fetchAllPosConfig
{
    return [self fetchItems:@"CDPosConfig" sortedByKey:@"posID" ascending:YES];
}


#pragma mark -
#pragma mark Restaurant Methods

- (NSArray *)fetchAllRestaurantFloor
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDRestaurantFloor" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isActive = TRUE", floor];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"floorSequence" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"floorID" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObjects:sortDescriptor1,sortDescriptor2,nil];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchAllRestaurantTable
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDRestaurantTable" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tableSequence" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchRestaurantTableWithFloor:(CDRestaurantFloor*)floor
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDRestaurantTable" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"floor == %@ && isActive = TRUE", floor];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tableSequence" ascending:YES];
    NSSortDescriptor *secondDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tableID" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObjects:sortDescriptor,secondDescriptor,nil];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchRestaurantTableUseWithBookIds:(NSArray *)bookIds
{
    NSPredicate *predicate;
    if (bookIds.count > 0) {
        
        predicate = [NSPredicate predicateWithFormat:@"book.book_id in %@",bookIds];
    }
   return [self fetchItems:@"CDRestaurantTableUse" sortedByKey:@"use_id" ascending:false predicate:predicate];
}

#pragma mark -
#pragma mark Project Methods

- (NSArray *)fetchAllBornCategory
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDBornCategory" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sequence" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return array;
}

- (NSArray *)fetchAllProjectCategory
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDProjectCategory" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryID" ascending:YES];
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"sequence" ascending:YES];
    
    NSArray *sortArray = @[sortDescriptor1,sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchAllTopProjectCategory
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDProjectCategory" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parentID == %@", [NSNumber numberWithInteger:0]];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryID" ascending:YES];
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"sequence" ascending:YES];
    
    NSArray *sortArray = @[sortDescriptor1,sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchTopProjectCategory
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDProjectCategory" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parentID == %@",[NSNumber numberWithInteger:0]];
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parentID == %@ and itemCount != %@", [NSNumber numberWithInteger:0], [NSNumber numberWithInteger:0]];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryID" ascending:YES];
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"sequence" ascending:YES];
    
    NSArray *sortArray = @[sortDescriptor1,sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchAllProjectUomCategory
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDProjectUomCategory" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"uomCategoryID" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchAllProjectUom
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDProjectUom" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"uomID" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchAllProjectRelated
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDProjectRelated" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"relatedID" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}
#pragma mark 获取疗程的组合套
- (NSArray *)fetchConsumableRelatedProject
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDProjectRelated" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *presdicate = [NSPredicate predicateWithFormat:@"item.bornCategory == %@ &&  item.projectTemplate != NULL",[NSNumber numberWithInteger:3]];
    [fetchRequest setPredicate:presdicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"relatedID" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}
- (NSArray *)fetchAllProjectConsumable
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDProjectConsumable" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"consumableID" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchAllProjectCheck
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDProjectCheck" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"checkID" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchConsumeProduct
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDProjectTemplate" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *presdicate = [NSPredicate predicateWithFormat:@"type == %@", @"consu"];
    [fetchRequest setPredicate:presdicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"templateID" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

-(NSArray*)fetchConsumeProductWithTemplateId:(NSInteger*)templateId
{
    if (templateId == nil) {
        return [NSArray array];
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDProjectTemplate" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *presdicate = [NSPredicate predicateWithFormat:@"type == %@ && templateID ==%d", @"consu",templateId];
    [fetchRequest setPredicate:presdicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"templateID" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}
- (NSArray *)fetchAllProjectAttribute
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDProjectAttribute" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"attributeID" ascending:false];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchAllProjectAttributeValue
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDProjectAttributeValue" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"attributeValueID" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchAllProjectAttributePrice
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDProjectAttributePrice" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"attributePriceID" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchAllProjectAttributeLine
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDProjectAttributeLine" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"attributeLineID" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}


#pragma mark -
#pragma mark ProjectTemplate && ProjectItem

// type: product-库存商品 consu-消耗品 service-服务
- (NSArray *)fetchAllProjectTemplate
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDProjectTemplate" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"templateID" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchAllLastUpdateProjectTemplate:(NSString *)lastUpdate
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDProjectTemplate" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *presdicate = [NSPredicate predicateWithFormat:@"lastUpdate > %@", lastUpdate];
    [fetchRequest setPredicate:presdicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"templateID" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchProjectTemplatesWithBornCategorys:(NSArray *)bornCategorys categoryIds:(NSArray *)categoryIds keyword:(NSString *)keyword priceAscending:(BOOL)ascending
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDProjectTemplate" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    /*
     kPadBornCategoryProduct     = 1,    // 产品
     kPadBornCategoryProject     = 2,    // 项目
     kPadBornCategoryCourses     = 3,    // 疗程
     kPadBornCategoryPackage     = 4,    // 套餐
     kPadBornFreeCombination     = 5,    // 定制组合
     kPadBornCategoryPackageKit  = 6,    // 套盒
     kPadBornCategoryCustomPrice = 999,   // 定制价格
     kPadBornCategoryCardItem     = 9999  // 卡内项目
     */
    NSMutableArray *filters = [NSMutableArray array];
    if (bornCategorys.count==0 || [[bornCategorys lastObject] isEqual:@(kPadBornCategoryAll)]) {
        bornCategorys = @[@(kPadBornCategoryProduct),@(kPadBornCategoryProject),@(kPadBornCategoryCourses),@(kPadBornCategoryPackage),@(kPadBornFreeCombination),@(kPadBornCategoryPackageKit),@(kPadBornCategoryCustomPrice),@(kPadBornCategoryCardItem)];
    }
   [filters addObject:[NSPredicate predicateWithFormat:@"bornCategory in %@ and type != %@ and canSale = %@ and isActive = %@", bornCategorys, @"consu", [NSNumber numberWithBool:YES], [NSNumber numberWithBool:YES]]];
   
    if (categoryIds != nil && categoryIds.count != 0)
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"categoryID in %@", categoryIds]];
    }
    if (keyword.length != 0)
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"templateName contains[c] %@ || templateNameLetter contains[cd] %@ || templateNameFirstLetter contains[cd] %@ || defaultCode contains[cd] %@ || barcode contains[cd] %@", keyword, keyword, keyword, keyword, keyword]];
    }
    [filters addObject:[NSPredicate predicateWithFormat:@"not (projectItems.@count = %@ and (bornCategory = %@ or bornCategory = %@ or bornCategory=%@))", [NSNumber numberWithInteger:0], [NSNumber numberWithInteger:kPadBornCategoryCourses], [NSNumber numberWithInteger:kPadBornCategoryPackage],@(kPadBornCategoryPackageKit)]];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filters];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *priceSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"listPrice" ascending:ascending];
    NSSortDescriptor *idSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"templateID" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObjects:priceSortDescriptor, idSortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}


- (NSArray *)fetchAllProjectItem
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDProjectItem" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *presdicate = [NSPredicate predicateWithFormat:@"isActive = %@", [NSNumber numberWithBool:YES], [NSNumber numberWithBool:NO]];
    [fetchRequest setPredicate:presdicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sequence" ascending:YES];
    
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchAllLastUpdateProjectItem:(NSString *)lastUpdate
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDProjectItem" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *presdicate = [NSPredicate predicateWithFormat:@"lastUpdate > %@ and isActive = %@", lastUpdate, [NSNumber numberWithBool:YES], [NSNumber numberWithBool:NO]];
    [fetchRequest setPredicate:presdicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sequence" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchProjectItemsWithType:(kProjectItemType)type bornCategorys:(NSArray *)bornCategorys categoryIds:(NSArray *)categoryIds existItemIds:(NSArray *)itemIds keyword:(NSString *)keyword priceAscending:(BOOL)ascending
{
    if (bornCategorys.count==0 || [[bornCategorys lastObject] isEqual:@(kPadBornCategoryAll)]) {
        bornCategorys = @[@(kPadBornCategoryProduct),@(kPadBornCategoryProject),@(kPadBornCategoryCourses),@(kPadBornCategoryPackage),@(kPadBornFreeCombination),@(kPadBornCategoryPackageKit),@(kPadBornCategoryCustomPrice),@(kPadBornCategoryCardItem)];
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDProjectItem" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSMutableArray *filters = [NSMutableArray array];
    [filters addObject:[NSPredicate predicateWithFormat:@"bornCategory in %@ and isActive = %@", bornCategorys, [NSNumber numberWithBool:YES]]];
    
    switch (type)
    {
        case kProjectItemDefault:
            [filters addObject:[NSPredicate predicateWithFormat:@"type != %@", @"consu"]];
            [filters addObject:[NSPredicate predicateWithFormat:@"canSale = %@", [NSNumber numberWithBool:YES]]];
            break;
            
        case kProjectItemConsumable:
            [filters addObject:[NSPredicate predicateWithFormat:@"canSale = %@", [NSNumber numberWithBool:YES]]];
            break;
            
        case kProjectItemSubItem:
            [filters addObject:[NSPredicate predicateWithFormat:@"type != %@", @"consu"]];
            [filters addObject:[NSPredicate predicateWithFormat:@"canSale = %@", [NSNumber numberWithBool:YES]]];
            break;
            
        case kProjectItemSameItem:
            [filters addObject:[NSPredicate predicateWithFormat:@"type != %@", @"consu"]];
            [filters addObject:[NSPredicate predicateWithFormat:@"canSale = %@", [NSNumber numberWithBool:YES]]];
            break;
            
        case kProjectItemPurchase:
            [filters addObject:[NSPredicate predicateWithFormat:@"canPurchase = %@", [NSNumber numberWithBool:YES]]];
            [filters addObject:[NSPredicate predicateWithFormat:@"canSale = %@", [NSNumber numberWithBool:YES]]];
            break;
            
        case kProjectItemCardItem:
            [filters addObject:[NSPredicate predicateWithFormat:@"type != %@", @"consu"]];
            [filters addObject:[NSPredicate predicateWithFormat:@"canSale = %@", [NSNumber numberWithBool:YES]]];
            break;
            
        case kProjectItemCardBuyItem:
            [filters addObject:[NSPredicate predicateWithFormat:@"canSale = %@ and type != %@", [NSNumber numberWithBool:YES], @"consu"]];
            break;
        case kProjectItemInput:
            break;
        case kProjectItemCailiao:
            [filters addObject:[NSPredicate predicateWithFormat:@"is_consumables = %@", [NSNumber numberWithBool:YES]]];
            break;
        default:
            [filters addObject:[NSPredicate predicateWithFormat:@"canSale = %@", [NSNumber numberWithBool:YES]]];
            break;
    }
    
    if (categoryIds != nil && categoryIds.count != 0)
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"categoryID in %@", categoryIds]];
    }
    if (itemIds != nil && itemIds.count != 0)
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"not itemID in %@", itemIds]];
    }
    if (keyword.length != 0)
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"itemName contains[cd] %@ || itemNameLetter contains[cd] %@ || itemNameFirstLetter contains[cd] %@ || defaultCode contains[cd] %@ || barcode contains[cd] %@", keyword, keyword, keyword, keyword,keyword]];
    }
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filters];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sequenceSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sequence" ascending:YES];
    NSSortDescriptor *priceSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"totalPrice" ascending:ascending];
    NSSortDescriptor *idSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"itemID" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObjects:sequenceSortDescriptor,priceSortDescriptor, idSortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchPrescriptionsItems
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDProjectItem" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSMutableArray *filters = [NSMutableArray array];
    [filters addObject:[NSPredicate predicateWithFormat:@"bornCategory = %@", @(kPadBornCategoryProduct)]];
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filters];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sequenceSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sequence" ascending:YES];
    NSSortDescriptor *priceSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"totalPrice" ascending:TRUE];
    NSSortDescriptor *idSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"itemID" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObjects:sequenceSortDescriptor,priceSortDescriptor, idSortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchProjectItemsWithGroup:(NSString*)group
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDProjectItem" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *presdicate = [NSPredicate predicateWithFormat:@"project_group_name = %@ && canSale = %@ && type != %@", group, @(TRUE),@"consu"];
    [fetchRequest setPredicate:presdicate];
    
    NSSortDescriptor *sequenceSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sequence" ascending:YES];
    NSSortDescriptor *priceSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"totalPrice" ascending:YES];
    NSSortDescriptor *idSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"itemID" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObjects:sequenceSortDescriptor,priceSortDescriptor, idSortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

#pragma mark -
#pragma mark Member

- (NSArray *)fetchAllMemberCard
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDMemberCard" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cardID" ascending:YES];
//    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
//    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchMemberCardWithMemberID:(NSNumber *)memberId
{
    NSPredicate *predicate;
    if (memberId) {
        predicate = [NSPredicate predicateWithFormat:@"member.memberID = %@",memberId];
    }
    NSArray *array = [self fetchItems:@"CDMemberCard" sortedByKey:@"cardID" ascending:YES predicate:predicate];
    return array;
}

- (NSArray *)fetchMemberCardWithIDs:(NSArray*)ids
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDMemberCard" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *presdicate = [NSPredicate predicateWithFormat:@"cardID in %@ and isActive = %@", ids,@(TRUE)];
    [fetchRequest setPredicate:presdicate];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    array = [array sortedArrayUsingComparator:^NSComparisonResult(CDMemberCard* obj1, CDMemberCard* obj2) {
        return [ids indexOfObject:obj1.cardID] > [ids indexOfObject:obj2.cardID];
    }];
    
    return array;
}



- (NSArray *)fetchAllMemberCardProject
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDMemberCardProject" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchCardProjectsWithMemberCardID:(NSNumber *)cardID
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"card.cardID = %@",cardID];
    
    NSArray *array = [self fetchItems:@"CDMemberCardProject" sortedByKey:@"productLineID" ascending:YES predicate:predicate];
    return array;
}

- (NSArray *)fetchCardProjectsWithProjectIds:(NSArray *)projectIds
{
    NSPredicate *predicate;
    if (projectIds.count > 0) {
       predicate = [NSPredicate predicateWithFormat:@"productLineID in %@",projectIds];
    }
    NSArray *array = [self fetchItems:@"CDMemberCardProject" sortedByKey:@"productLineID" ascending:YES predicate:predicate];
    return array;
}

- (NSArray *)fetchbuyProjectsWithMemberCardID:(NSNumber *)cardID
{
    return nil;
}

- (NSArray *)fetchMemberProductsWithMemberID:(NSNumber *)memberID
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"member_id = %@",memberID];
    
    NSArray *array = [self fetchItems:@"CDMemberCardProject" sortedByKey:@"productLineID" ascending:false predicate:predicate];
    return array;
}

- (NSFetchedResultsController *)fetchMemberProductCategoryWithMemberID:(NSNumber *)memberID
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CDMemberCardProject"];
    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"section_category" ascending:false];
    
//    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"productLineID" ascending:false];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"member_id = %@",memberID];
    
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:@[sortDescriptor1]];
//    [fetchRequest setSortDescriptors:@[sortDescriptor1,sortDescriptor2]];
    
    NSFetchedResultsController *fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"section_category" cacheName:nil];
    
    [fetchResultsController performFetch:nil];
    
    return fetchResultsController;
}

- (NSFetchedResultsController *)fetchMemberProductDateWithMemberID:(NSNumber *)memberID
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CDMemberCardProject"];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"create_date" ascending:false];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"member_id = %@",memberID];
    
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSFetchedResultsController *fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"section_date" cacheName:nil];
    
    [fetchResultsController performFetch:nil];
    
    return fetchResultsController;
}

- (NSArray *)fetchAllMemberCardExchange
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDMemberCardExchange" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchAllCouponCard
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDCouponCard" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cardID" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchCouponCardWithMemberId:(NSNumber *)memberId
{
    NSPredicate *predicate;
    if (memberId) {
        predicate = [NSPredicate predicateWithFormat:@"member.memberID = %@",memberId];
    }
    NSArray *array = [self fetchItems:@"CDCouponCard" sortedByKey:@"cardID" ascending:YES predicate:predicate];
    return array;
}

- (NSArray *)fetchCouponCardWithIds:(NSArray *)ids
{
    NSPredicate *predicate;
    if (ids.count > 0) {
        predicate = [NSPredicate predicateWithFormat:@"cardID in %@",ids];
    }
    NSArray *array = [self fetchItems:@"CDCouponCard" sortedByKey:@"cardID" ascending:YES predicate:predicate];
    return array;
}




- (NSArray *)fetchAllCouponCardProduct
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDCouponCardProduct" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchAllCouponCardProductsWithCouponId:(NSNumber *)couponId
{
    NSPredicate *predicate;
    if (couponId) {
        predicate = [NSPredicate predicateWithFormat:@"coupon.cardID = %@",couponId];
    }
    NSArray *array = [self fetchItems:@"CDCouponCardProduct" sortedByKey:@"productLineID" ascending:YES predicate:predicate];
    return array;
}

- (NSArray *)fetchCouponCardProductsWithProductIds:(NSArray *)productIds
{
    NSPredicate *predicate;
    if (productIds.count > 0) {
        predicate = [NSPredicate predicateWithFormat:@"productLineID in %@",productIds];
    }
    NSArray *array = [self fetchItems:@"CDCouponCardProduct" sortedByKey:@"productLineID" ascending:YES predicate:predicate];
    return array;
}


- (NSArray *)fetchAllMemberCardArrears
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDMemberCardArrears" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchAllMember
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDMember" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"memberID" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchAllMemberWithStoreID:(NSNumber *)storeID
{
    return [self fetchAllMemberWithStoreID:storeID keyword:nil];
}

- (NSArray *)fetchAllMemberWithStoreID:(NSNumber *)storeID keyword:(NSString *)keyword
{
    return [self fetchAllMemberWithStoreID:storeID keyword:keyword guwenID:nil];
}

- (NSArray *)fetchAllMemberWithStoreID:(NSNumber *)storeID guwenID:(NSNumber *)guwenID
{
    return [self fetchAllMemberWithStoreID:storeID keyword:nil guwenID:guwenID];
}

- (NSArray *)fetchAllMemberWithStoreID:(NSNumber *)storeID keyword:(NSString *)keyword guwenID:(NSNumber *)guwenID
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDMember" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSMutableArray *filters = [NSMutableArray array];
    [filters addObject:[NSPredicate predicateWithFormat:@"memberID > %@", @(0)]];
    [filters addObject:[NSPredicate predicateWithFormat:@"isDefaultCustomer = %@", @(FALSE)]];
    
    if (keyword.length != 0)
    {
        if ( 1/*[keyword hasPrefix:@"1"]*/)
        {
            NSString *mobile = [NSString stringWithFormat:@"*%@*", keyword];
            [filters addObject:[NSPredicate predicateWithFormat:@"mobile like %@ || memberName contains[cd] %@ || memberNameLetter contains[cd] %@ || memberNameFirstLetter contains[cd] %@", mobile, keyword, keyword, keyword]];
        }
        else
        {
            [filters addObject:[NSPredicate predicateWithFormat:@"memberName contains[cd] %@ || memberNameLetter contains[cd] %@ || memberNameFirstLetter contains[cd] %@", keyword, keyword, keyword]];
        }
    }
    if (storeID.integerValue != 0)
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"storeID = %@", storeID]];
    }
    
    if (guwenID)
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"member_guwen_id = %@ || member_shejishi_id = %@",guwenID, guwenID]];
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filters];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor0 = [[NSSortDescriptor alloc] initWithKey:@"isDefaultCustomer" ascending:NO];
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"memberNameLetter" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObjects:sortDescriptor0, sortDescriptor1, nil];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;

}

- (NSArray *)fetchAllMemberWithStoreID:(NSNumber *)storeID isTiYan:(BOOL)isTiYan guwenID:(NSNumber *)guwenID
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDMember" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSMutableArray *filters = [NSMutableArray array];
    [filters addObject:[NSPredicate predicateWithFormat:@"memberID > %@", @(0)]];
    
    if (storeID.integerValue != 0)
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"storeID = %@", storeID]];
    }
    
    [filters addObject:[NSPredicate predicateWithFormat:@"isTiyan = %@", @(isTiYan)]];
    [filters addObject:[NSPredicate predicateWithFormat:@"isDefaultCustomer = %@", @(FALSE)]];
    
    if (guwenID)
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"member_guwen_id = %@ || member_shejishi_id = %@",guwenID, guwenID]];
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filters];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor0 = [[NSSortDescriptor alloc] initWithKey:@"isDefaultCustomer" ascending:NO];
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"memberNameLetter" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObjects:sortDescriptor0, sortDescriptor1, nil];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchWevipMembersWithStoreID:(NSNumber *)storeID
{
    NSMutableArray *filters = [NSMutableArray array];
    [filters addObject:[NSPredicate predicateWithFormat:@"memberID > %@", @(0)]];
//    [filters addObject:[NSPredicate predicateWithFormat:@"isDefaultCustomer = %@", @(0)]];
    [filters addObject:[NSPredicate predicateWithFormat:@"isWevipCustom = %@", @(1)]];
    
    if (storeID) {
        [filters addObject:[NSPredicate predicateWithFormat:@"storeID = %@", storeID]];
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filters];
    
    return [self fetchItems:@"CDMember" sortedByKey:@"memberNameLetter" ascending:YES predicate:predicate];
    
}
- (NSArray *)fetchMemberQinyouWithMember:(CDMember *)member
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"partner_id = %@",member.memberID];
    NSArray *qinyouArray = [self fetchItems:@"CDMemberQinyou" sortedByKey:@"qy_id" ascending:YES predicate:predicate];
    return qinyouArray;
}


- (NSArray *)fetchMemberTezhengWithMember:(CDMember *)member
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"member_id = %@",member.memberID];
    NSArray *tezhengArray = [self fetchItems:@"CDMemberTeZheng" sortedByKey:@"tz_id" ascending:true predicate:predicate];
    return tezhengArray;
}

- (NSArray *)fetchMemberSource
{
    NSArray *tezhengArray = [self fetchItems:@"CDMemberSource" sortedByKey:@"source_id" ascending:true];
    return tezhengArray;
}

- (NSArray *)fetchPartner
{
    NSArray *partner = [self fetchItems:@"CDPartner" sortedByKey:@"partner_id" ascending:true];
    return partner;
}

- (NSArray *)fetchPartnerWithKeyWord:(NSString*)keyword
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDPartner" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSMutableArray *filters = [NSMutableArray array];
    
    if (keyword.length != 0)
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"name contains[cd] %@ || nameLetter contains[cd] %@ || nameFirstLetter contains[cd] %@", keyword, keyword, keyword]];
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filters];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"nameLetter" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObjects:sortDescriptor1, nil];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
    
    NSArray *partner = [self fetchItems:@"" sortedByKey:@"partner_id" ascending:true];
    return partner;
}

- (NSArray *)fetchPartner:(NSString*)partner_category
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"partner_category = %@",partner_category];
    
    NSArray *partner = [self fetchItems:@"CDPartner" sortedByKey:@"partner_id" ascending:true predicate:predicate];
    
    return partner;
}

- (NSArray *)fetchMemberFeedbackWithMember:(CDMember *)member
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"member.memberID = %@",member.memberID];
    
    NSArray *feedbacks = [self fetchItems:@"CDMemberFeedback" sortedByKey:@"feedback_id" ascending:YES predicate:predicate];
    
    return feedbacks;
}

- (NSArray *)fetchMemberFollowsWithMember:(CDMember *)member
{
    NSPredicate *predicate = nil;
    if (member) {
        predicate = [NSPredicate predicateWithFormat:@"member_id = %@",member.memberID];
    }
    
    NSArray *follows = [self fetchItems:@"CDMemberFollow" sortedByKey:@"follow_date" ascending:false predicate:predicate];
    return follows;
}

- (NSArray *)fetchMemberFollowProductsWithFollow:(CDMemberFollow *)follow
{
    NSPredicate *predicate = nil;
    if (follow) {
        predicate = [NSPredicate predicateWithFormat:@"follow_id = %@",follow.follow_id];
    }
//    CDMemberFollowProduct
    NSArray *followProducts = [self fetchItems:@"CDMemberFollowProduct" sortedByKey:@"line_id" ascending:YES predicate:predicate];
    return followProducts;
}

- (NSArray *)fetchMemberFollowContentsWithFollow:(CDMemberFollow *)follow
{
    NSPredicate *predicate = nil;
    if (follow) {
        predicate = [NSPredicate predicateWithFormat:@"follow_id = %@",follow.follow_id];
    }
    //    CDMemberFollowContent
    NSArray *followContents = [self fetchItems:@"CDMemberFollowContent" sortedByKey:@"content_id" ascending:YES predicate:predicate];
    return followContents;
}

- (NSArray *)fetchMemberRecordsWithStoreID:(NSNumber *)storeID
{
    NSPredicate *predicate = nil;
    if (storeID) {
        predicate = [NSPredicate predicateWithFormat:@"shop_id = %@",storeID];
    }
    return [self fetchItems:@"CDMemberCallRecord" sortedByKey:@"record_id" ascending:TRUE predicate:predicate];
}

- (NSArray *)fetchMemberFollowPeriodsWithMonth:(NSInteger)month
{
    NSPredicate *predicate;
    if (month > 0) {
        predicate = [NSPredicate predicateWithFormat:@"special = %@ && period_id <= %d",@0,month + 1];
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"special = %@",@0];
    }
    return [self fetchItems:@"CDMemberFollowPeroid" sortedByKey:@"period_id" ascending:false predicate:predicate];
}


- (NSArray *)fetchExtends
{
    return [self fetchItems:@"CDExtend" sortedByKey:@"extend_id" ascending:YES];
}

- (NSArray *)fetchMemberMessagesWithType:(NSString *)type
{
    NSPredicate *predicate;
    if (type) {
        predicate = [NSPredicate predicateWithFormat:@"template_type = %@",type];
    }
    return [self fetchItems:@"CDMessageTemplate" sortedByKey:@"message_id" ascending:false predicate:predicate];
}

- (NSArray *)fetchMemberMessageRecords
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"born_uuid = %@ && shop_uuid = %@ && company_uuid = %@",[PersonalProfile currentProfile].born_uuid,[PersonalProfile currentProfile].shopUUID,[PersonalProfile currentProfile].companyUUID];
    return [self fetchItems:@"CDMessageRecord" sortedByKey:@"send_date" ascending:false predicate:predicate];
}

/* 评论 */
-(NSArray *)fetchCommentsWithMember:(CDMember *)memebr
{
    NSPredicate *predicate = nil;
    if (memebr) {
        predicate = [NSPredicate predicateWithFormat:@"member_id = %@",memebr.memberID];
    }
    NSArray *comments = [self fetchItems:@"CDComment" sortedByKey:@"comment_id" ascending:true predicate:predicate];
    
    return comments;
}

-(NSArray *)fetchCommentType
{
    NSArray *comments = [self fetchItems:@"CDCommentType" sortedByKey:@"type_id" ascending:true];
    
    return comments;
}

/* 积分 */
- (NSArray *)fetchCardPointsWithCardID:(NSNumber *)cardID
{
    NSPredicate *predictate = [NSPredicate predicateWithFormat:@"card.cardID = %@",cardID];
    NSArray *points = [self fetchItems:@"CDMemberCardPoint" sortedByKey:@"point_id" ascending:true predicate:predictate];
    return points;
}

- (NSArray *)fetchCardPointsWithMemberID:(NSNumber *)memberID
{
    NSPredicate *predictate = [NSPredicate predicateWithFormat:@"member.memberID = %@",memberID];
    NSArray *points = [self fetchItems:@"CDMemberCardPoint" sortedByKey:@"point_id" ascending:true predicate:predictate];
    return points;
}

/* 操作明细 */
- (NSArray *)fetchCardOperatesWithCardID:(NSNumber *)cardID
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"memberCard.cardID = %@",cardID];
//    CDPosOperate
    NSArray *operates = [self fetchItems:@"CDPosOperate" sortedByKey:@"operate_id" ascending:false predicate:predicate];
    return operates;
}

- (NSArray *)fetchCardOperatesWithMemberID:(NSNumber *)memberID
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"member.memberID = %@",memberID];
    //    CDPosOperate
    NSArray *operates = [self fetchItems:@"CDPosOperate" sortedByKey:@"operate_id" ascending:false predicate:predicate];
    return operates;
}


/* 消费 */
- (NSArray *)fetchCardConsumesWithCardID:(NSNumber *)cardID
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"card.cardID = %@",cardID];
    
    //    CDMemberCardConsume
    NSArray *operates = [self fetchItems:@"CDMemberCardConsume" sortedByKey:@"consume_id" ascending:true predicate:predicate];
    return operates;
}

- (NSArray *)fetchCardConsumesWithMemberID:(NSNumber *)memberID
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"member.memberID = %@",memberID];
    
    //    CDMemberCardConsume
    NSArray *operates = [self fetchItems:@"CDMemberCardConsume" sortedByKey:@"consume_id" ascending:true predicate:predicate];
    return operates;
}


/* 金额变动 */
- (NSArray *)fetchCardAmountsWithCardID:(NSNumber *)cardID
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"card.cardID = %@",cardID];

    //    CDMemberCardAmount
    NSArray *operates = [self fetchItems:@"CDMemberCardAmount" sortedByKey:@"amount_id" ascending:true predicate:predicate];
    return operates;
}

- (NSArray *)fetchCardAmountsWithMemberID:(NSNumber *)memberID
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"member.memberID = %@",memberID];
    
    //    CDMemberCardAmount
    NSArray *operates = [self fetchItems:@"CDMemberCardAmount" sortedByKey:@"amount_id" ascending:true predicate:predicate];
    return operates;
}

/* 欠款还款 */
- (NSArray *)fetchCardArrearsWithCardID:(NSNumber *)cardID
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"memberCard.cardID = %@",cardID];
    
    NSArray *arrears = [self fetchItems:@"CDMemberCardArrears" sortedByKey:@"arrearsID" ascending:true predicate:predicate];
    
    return arrears;
}

- (NSArray *)fetchCardArrearsWithMemberID:(NSNumber *)memberID
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"member.memberID = %@",memberID];
    
    NSArray *arrears = [self fetchItems:@"CDMemberCardArrears" sortedByKey:@"arrearsID" ascending:true predicate:predicate];
    
    return arrears;
}

/* 转店履历 */
- (NSArray *)fetchChangeShopRecordsWithMember:(CDMember *)member
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"member_id = %@",member.memberID];
    
    NSArray *changeShopRecords = [self fetchItems:@"CDMemberChangeShop" sortedByKey:@"record_id" ascending:true predicate:predicate];
    return changeShopRecords;
}

- (NSString *)operateType:(NSString *)type
{
    if ([type isEqualToString:@"upgrade"])
    {
        type = @"卡升级";
    }
    else if ([type isEqualToString:@"refund"])
    {
        type = @"退款";
    }
    else if ([type isEqualToString:@"retreat"])
    {
        type = @"退货";
    }
    else if ([type isEqualToString:@"consume"])
    {
        type = @"消费";
    }
    else if ([type isEqualToString:@"card"])
    {
        type = @"开卡";
    }
    else if ([type isEqualToString:@"lost"])
    {
        type = @"挂失";
    }
    else if ([type isEqualToString:@"active"])
    {
        type = @"激活";
    }
    else if ([type isEqualToString:@"exchange"])
    {
        type = @"退换";
    }
    else if ([type isEqualToString:@"merger"])
    {
        type = @"并卡";
    }
    else if ([type isEqualToString:@"change"])
    {
        type = @"兑换";
    }
    else if ([type isEqualToString:@"buy"])
    {
        type = @"消费";
    }
    else if ([type isEqualToString:@"replacement"])
    {
        type = @"换卡";
    }
    else if ([type isEqualToString:@"repayment"])
    {
        type = @"还款";
    }
    else if ([type isEqualToString:@"recharge"])
    {
        type = @"充值";
    }
    else if ([type isEqualToString:@"other"])
    {
        type = @"其他";
    }
    return type;
}

#pragma mark - Purchase 采购订单

- (NSArray *)fetchAllProviders
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"provider_id > 0"];
    return [self fetchItems:@"CDProvider" sortedByKey:@"provider_id" ascending:NO predicate:predicate];
}

- (NSArray *)fetchAllWarehouses
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pick_id > 0"];
    return [self fetchItems:@"CDWarehouse" sortedByKey:@"pick_id" ascending:YES predicate:predicate];
}

- (NSArray *)fetchAllStoreages
{
     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"storage_id > 0"];
    return [self fetchItems:@"CDStorage" sortedByKey:@"storage_id" ascending:YES predicate:predicate];
}

- (NSArray *)fetchPurchaseOrdersWithState:(NSString *)state
{
    NSPredicate *predicate = nil;
    if (state != nil) {
        if ([state isEqualToString:@"approved"]) {
            predicate = [NSPredicate predicateWithFormat:@"state == %@ and shipped = %d",state,0];
        }
        else if ([state isEqualToString:@"done"])
        {
            predicate = [NSPredicate predicateWithFormat:@"(state == %@ and shipped = %d) or (state == %@)",@"approved",1,state];
        }
        else
        {
            predicate = [NSPredicate predicateWithFormat:@"state == %@",state];
        }
    }
    return [self fetchItems:@"CDPurchaseOrder" sortedByKey:@"orderId" ascending:NO predicate:predicate];
    
}

- (NSArray *)fetchPurchaseMoveOrdersWithOrigin:(NSString *)origin
{
    NSPredicate *predicate = nil;
    if (origin) {
        predicate = [NSPredicate predicateWithFormat:@"origin == %@",origin];
    }
    return [self fetchItems:@"CDPurchaseOrderMove" sortedByKey:@"move_id" ascending:NO predicate:predicate];
}


- (NSArray *)fetchPurchaseMoveOrderItemsWithItemIds:(NSArray *)item_ids
{
    NSPredicate *predicate = nil;
    if (item_ids) {
        predicate = [NSPredicate predicateWithFormat:@"item_id in %@",item_ids];
        
    }
    return [self fetchItems:@"CDPurchaseOrderMoveItem" sortedByKey:@"item_id" ascending:NO predicate:predicate];
}

- (NSArray *)fetchPurchaseOrderTaxs
{
    //  CDPurchaseOrderTax
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent_id = %@",@0];
    
    return [self fetchItems:@"CDPurchaseOrderTax" sortedByKey:@"tax_id" ascending:NO predicate:predicate];
}


#pragma mark - Stock 仓库
- (NSArray *)fetchPanDiansWithState:(NSString *)state
{
    NSPredicate *predicate = nil;
    if (state != nil) {
        predicate = [NSPredicate predicateWithFormat:@"state == %@",state];
    }
    return [self fetchItems:@"CDPanDian" sortedByKey:@"pd_id" ascending:NO predicate:predicate];
}

- (NSArray *)fetchPanDianItemsWithIds:(NSArray *)item_ids
{
    if (item_ids == nil) {
        return  nil;
    }
    NSPredicate *predicate = nil;
    if (item_ids) {
        predicate = [NSPredicate predicateWithFormat:@"item_id in %@",item_ids];
        
    }
    return [self fetchItems:@"CDPanDianItem" sortedByKey:@"item_id" ascending:NO predicate:predicate];
}


#pragma mark -
#pragma mark POS

- (NSArray*)fetchAllPriceList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"canUse == %@", @(TRUE)];
    return [self fetchItems:@"CDMemberPriceList" sortedByKey:@"priceID" ascending:YES predicate:predicate];
}

- (NSArray*)fetchCanUsePriceList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"canUse == %@", @(YES)];
    return [self fetchItems:@"CDMemberPriceList" sortedByKey:@"priceID" ascending:YES predicate:predicate];
}

- (NSArray *)fetchPOSPayMode
{
    return [self fetchItems:@"CDPOSPayMode" sortedByKey:@"payID"];
}

- (NSArray *)fetchPOSPayModeSortByMode
{
    return [self fetchItems:@"CDPOSPayMode" sortedByKey:@"mode"];
}

- (NSString*)calculateMemberCardBuyPrice:(CDMemberCardProject*)project
{
    CGFloat totalPrice = 0;
    if ( project.projectManualPrice.length > 0 )
    {
        totalPrice = [project.projectManualPrice floatValue] * [project.projectCount floatValue];
        if ( [project.discount integerValue] > 0 )
        {
            totalPrice = totalPrice * [project.discount integerValue] / 10;
        }
    }
    else
    {
        if ( [project.discount integerValue] > 0 )
        {
            totalPrice = [project.discount integerValue] * [project.projectCount floatValue] * [project.projectTotalPrice floatValue] / 10;
        }
        else
        {
            totalPrice = [project.projectTotalPrice floatValue] * [project.projectCount floatValue];
        }
    }
    
    return [NSString stringWithFormat:@"%0.2f",totalPrice];
}

#pragma mark - PadPosCardOperate PadPos操作单据

- (NSArray *)fetchAllPadOrder
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDPosOperate" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *presdicate = [NSPredicate predicateWithFormat:@"operateType = %@ && orderState in %@", [NSNumber numberWithInteger:kPadOrderFromPad], @[[NSNumber numberWithInteger:kPadOrderDraft], [NSNumber numberWithInteger:kPadOrderSubmit]]];
    [fetchRequest setPredicate:presdicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"operate_date" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchPosOperates
{
    return [self fetchItems:@"CDPosOperate" sortedByKey:@"operate_id" ascending:YES predicate:nil];
}

- (NSArray *)fetchLocalPosOperates:(NSString*)sortKey
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isLocal == %@ and isTakeout == %@", [NSNumber numberWithBool:YES], [NSNumber numberWithBool:NO]];
    return [self fetchItems:@"CDPosOperate" sortedByKey:sortKey ascending:YES predicate:predicate];
}

- (NSArray *)fetchTakeoutPosOperates:(NSString *)sortKey
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isTakeout == %@", [NSNumber numberWithBool:YES]];
    return [self fetchItems:@"CDPosOperate" sortedByKey:sortKey ascending:YES predicate:predicate];
}

- (NSArray *)fetchHistoryPosOperatesByType:(NSString*)type storeID:(NSNumber*)storeID
{
    NSString *start = nil;
    NSString *end = nil;
    
    if ( [type isEqualToString:@"day"] )
    {
        [BSDataManager getTodayString:&start end:&end];
    }
    else if ( [type isEqualToString:@"week"] )
    {
        [BSDataManager getWeekString:&start end:&end];
    }
    else if ( type.length > 0 )
    {
        [BSDataManager getMonthString:type start:&start end:&end];
    }

    NSPredicate *predicate;
    
    if ( storeID )
    {
        if ( start && end )
        {
            predicate = [NSPredicate predicateWithFormat:@"operate_date >= %@ and operate_date <= %@ && isLocal == FALSE && operate_shop_id == %@",start,end,storeID];
        }
        else
        {
            predicate = [NSPredicate predicateWithFormat:@"isLocal == FALSE && operate_shop_id == %@",storeID];
        }
    }
    else
    {
        if ( start && end )
        {
            predicate = [NSPredicate predicateWithFormat:@"operate_date >= %@ and operate_date <= %@ && isLocal == FALSE",start,end];
        }
        else
        {
            predicate = [NSPredicate predicateWithFormat:@"isLocal == FALSE"];
        }
        
    }

    return [self fetchItems:@"CDPosOperate" sortedByKey:@"operate_date" ascending:NO predicate:predicate];
}

- (NSArray *)fetchHistoryPosOperatesByKeyword:(NSString*)keyword
{
    NSString *start = nil;
    NSString *end = nil;
    
    [BSDataManager getTodayString:&start end:&end];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"operate_date >= %@ and operate_date <= %@ && (name contains[cd] %@ || member_name contains[cd] %@ || member_mobile contains[cd] %@ || memberNameFirstLetter contains[cd] %@ || memberNameLetter contains[cd] %@)",start,end,keyword,keyword,keyword,keyword,keyword];
    
    return [self fetchItems:@"CDPosOperate" sortedByKey:@"operate_date" ascending:NO predicate:predicate];
}


- (NSFetchedResultsController *)fetchHistoryPosOprerateResultControllerByType:(NSString *)type storeID:(NSNumber *)storeID
{
    
    NSString *start = nil;
    NSString *end = nil;

    if ( [type isEqualToString:@"day"] )
    {
        [BSDataManager getTodayString:&start end:&end];
    }
    else if ( [type isEqualToString:@"week"] )
    {
        [BSDataManager getWeekString:&start end:&end];
    }
    else
    {
        [BSDataManager getMonthString:type start:&start end:&end];
    }
    
    NSPredicate *predicate;
    
    if ( storeID )
    {
        predicate = [NSPredicate predicateWithFormat:@"operate_date >= %@ and operate_date <= %@ && isLocal == FALSE && operate_shop_id == %@",start,end,storeID];
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"operate_date >= %@ and operate_date <= %@ && isLocal == FALSE",start,end];
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CDPosOperate"];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"operate_date" ascending:false];
    [fetchRequest setSortDescriptors:@[sortDescriptor1]];
    
    NSFetchedResultsController *resultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"year_month_day" cacheName:nil];
    [resultController performFetch:nil];
    
    return resultController;
}

- (NSArray *)fetchHistoryPosMonthIncome
{
    return [self fetchItems:@"CDPosMonthIncome" sortedByKey:@"sortIndex" ascending:YES];
}


- (NSFetchedResultsController *)fetchHistoryPosMonthIncomeResultsController
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CDPosMonthIncome"];

    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"sortIndex" ascending:true];
    [fetchRequest setSortDescriptors:@[sortDescriptor1]];
    
    NSFetchedResultsController *resultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"year" cacheName:nil];
    [resultController performFetch:nil];
    
    return resultController;
}

- (NSArray *)fetchPosCommissionWithOperateID:(NSNumber *)operateID productID:(NSNumber *)productID
{
    NSPredicate *predicate;
    if (productID == nil) {
        predicate = [NSPredicate predicateWithFormat:@"operate.operate_id = %@",operateID];
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"product_id = %@ && operate.operate_id = %@",productID,operateID];
    }
    
    return [self fetchItems:@"CDPosCommission" sortedByKey:@"commission_id" ascending:YES predicate:predicate];
}


- (NSArray *)fetchCommissionRules
{
    return [self fetchItems:@"CDCommissionRule" sortedByKey:@"rule_id" ascending:YES];
}

- (NSArray *)fetchPosProductsWithOperate:(CDPosOperate *)operate
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"operate_id = %@",operate.operate_id];
    return [self fetchItems:@"CDPosProduct" sortedByKey:@"line_id" ascending:YES predicate:predicate];
}


- (NSArray *)fetchPosProductsWithOperateIds:(NSArray *)operateIds
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"operate_id in %@",operateIds];
    
    return [self fetchItems:@"CDPosProduct" sortedByKey:@"line_id" ascending:YES predicate:predicate];
}


- (NSArray *)fetchConsumeProductsWithOperate:(CDPosOperate *)operate
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"operate_id = %@",operate.operate_id];
    return [self fetchItems:@"CDPosConsumeProduct" sortedByKey:@"line_id" ascending:YES predicate:predicate];
}

//pos消费项目中的卡扣项目
- (NSArray *)fetchConsumeProductsInCardWithOperate:(CDPosOperate *)operate
{
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"operate_id = %@ && pack_product_line_id > 0",operate.operate_id];
//    return [self fetchItems:@"CDPosConsumeProduct" sortedByKey:@"line_id" ascending:YES predicate:predicate];
    
    return [self fetchConsumeProductsWithOperate:operate];
}

- (NSArray *)fetchPosCouponProductsWithOPerate:(CDPosOperate *)operate
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"operate.operate_id = %@",operate.operate_id];
    return [self fetchItems:@"CDPosCouponProduct" sortedByKey:@"line_id" ascending:YES predicate:predicate];
}

- (NSArray *)fetchPosMemberCardProductWithOperate:(CDPosOperate *)operate
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"operate_id = %@ && pay_type = %@",operate.operate_id,[NSNumber numberWithInteger:kPadPayModeTypeCard]];
    return [self fetchItems:@"CDPosConsumeProduct" sortedByKey:@"line_id" ascending:YES predicate:predicate];
}

#pragma mark - pad 预约

- (NSArray *)fetchAllBooks
{
    return [self fetchItems:@"CDBook" sortedByKey:@"book_id" ascending:false];
}

- (NSArray *)fetchTodayBooks
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDBook" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *datestr = [dateFormatter stringFromDate:date];
    
    NSPredicate *presdicate = [NSPredicate predicateWithFormat:@"state == %@ && start_date BEGINSWITH %@ && book_id != 0 && isUsed == %@", @"approved", datestr, [NSNumber numberWithBool:NO]];
    [fetchRequest setPredicate:presdicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"book_id" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchHomeTodayBooks
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDBook" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *datestr = [dateFormatter stringFromDate:date];
    
    NSPredicate *presdicate = [NSPredicate predicateWithFormat:@"state == %@ && start_date BEGINSWITH %@ && book_id != 0 && isUsed == 0 && is_reservation_bill != TRUE", @"approved",datestr];
    [fetchRequest setPredicate:presdicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"book_id" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchBooksWithLastUpdateTime:(NSString *)updateTime
{
    NSPredicate *predicate = nil;
    if (updateTime) {
        predicate = [NSPredicate predicateWithFormat:@"lastUpdate > %@",updateTime];
    }
    NSArray *array = [self fetchItems:@"CDBook" sortedByKey:@"book_id" ascending:false predicate:predicate];
    return array;
}

- (NSArray *)fetchBooksWithDay:(NSString *)day
{
    NSString *starttring = [NSString stringWithFormat:@"%@ 00:00:00",day];
    NSString *endString = [NSString stringWithFormat:@"%@ 23:59:59",day];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"start_date >= %@ && end_date<=%@ && (book_id != 0)",starttring, endString];
    return [self fetchItems:@"CDBook" sortedByKey:@"book_id" ascending:false predicate:predicate];
}


- (NSArray *)fetchBooksWithTechnician:(CDStaff *)staff
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"technician_id = %@ && (book_id != 0)",staff.staffID];
    return [self fetchItems:@"CDBook" sortedByKey:@"book_id" ascending:false predicate:predicate];
}



- (NSArray *)fetchBooksWithTechnician:(CDStaff *)staff day:(NSString *)day
{
    NSString *starttring = [NSString stringWithFormat:@"%@ 00:00:00",day];
    NSString *endString = [NSString stringWithFormat:@"%@ 23:59:59",day];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"technician_id = %@ && start_date >= %@ && end_date<=%@ && (book_id != 0)",staff.staffID,starttring, endString];
    return [self fetchItems:@"CDBook" sortedByKey:@"book_id" ascending:false predicate:predicate];
}

- (NSArray *)fetchLatestBooksWithTechnician:(CDStaff *)staff
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *datestr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *endstr = [NSString stringWithFormat:@"%@ 23:59:59", [datestr substringToIndex:10]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"technician_id = %@ && end_date >= %@ && end_date <= %@ && (book_id != 0)",staff.staffID, datestr, endstr];
    return [self fetchItems:@"CDBook" sortedByKey:@"start_date" ascending:YES predicate:predicate];
}



- (NSArray *)fetchBooksWithTable:(CDRestaurantTable *)table
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tableUse.table_id = %@ && (book_id != 0)",table.tableID];
    return [self fetchItems:@"CDBook" sortedByKey:@"book_id" ascending:false predicate:predicate];
}


- (NSArray *)fetchBooksWithTable:(CDRestaurantTable *)table day:(NSString *)day
{
    NSString *starttring = [NSString stringWithFormat:@"%@ 00:00:00",day];
    NSString *endString = [NSString stringWithFormat:@"%@ 23:59:59",day];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tableUse.table_id = %@ && start_date >= %@ && end_date<=%@ && (book_id != 0)",table.tableID,starttring, endString];
    return [self fetchItems:@"CDBook" sortedByKey:@"book_id" ascending:false predicate:predicate];
}

- (NSArray *)fetchLatestBooksWithTable:(CDRestaurantTable *)table
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *datestr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *endstr = [NSString stringWithFormat:@"%@ 23:59:59", [datestr substringToIndex:10]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tableUse.table_id = %@ && end_date >= %@ && end_date <= %@ && (book_id != 0)",table.tableID, datestr, endstr];
    return [self fetchItems:@"CDBook" sortedByKey:@"start_date" ascending:YES predicate:predicate];
}


- (NSArray *)fetchIntersectBooksWithBook:(CDBook *)book
{
//    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"(((start_date > %@ && start_date < %@) || (end_date >%@ && end_date < %@) || (start_date < %@ && end_date > %@)) && (technician_id = %@) && (book_id != 0) )",book.start_date,book.end_date,book.start_date,book.end_date,book.start_date,book.end_date,book.technician_id];
    NSPredicate *predicate;
    if ([PersonalProfile currentProfile].isTable.boolValue) {
        predicate = [NSPredicate predicateWithFormat:@"((start_date < %@ && end_date > %@) || (start_date > %@ && start_date< %@)) && (tableUse.table_id = %@) && (book_id != 0)",book.start_date,book.start_date,book.start_date,book.end_date,book.tableUse.table_id];
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"((start_date < %@ && end_date > %@) || (start_date > %@ && start_date< %@)) && (technician_id = %@) && (book_id != 0)",book.start_date,book.start_date,book.start_date,book.end_date,book.technician_id];
    }
    
    NSArray *array = [self fetchItems:@"CDBook" sortedByKey:@"book_id" ascending:false predicate:predicate];

    return array;
}

- (NSArray *)fetchIntersectRoomBooksWithBook:(CDBook *)book
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"((start_date < %@ && end_date > %@) || (start_date > %@ && start_date< %@)) && (tableUse.table_id = %@) && (book_id != 0) && technician_id = %@",book.start_date,book.start_date,book.start_date,book.end_date,book.tableUse.table_id, book.technician_id];
    NSArray *array = [self fetchItems:@"CDBook" sortedByKey:@"book_id" ascending:false predicate:predicate];
    
    return array;
}

- (NSArray *)fetchIntersectTechBooksWithBook:(CDBook *)book
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"((start_date < %@ && end_date > %@) || (start_date > %@ && start_date< %@)) && (technician_id = %@) && (book_id != 0)",book.start_date,book.start_date,book.start_date,book.end_date,book.technician_id];
    NSArray *array = [self fetchItems:@"CDBook" sortedByKey:@"book_id" ascending:false predicate:predicate];
    
    return array;
}

- (NSArray *)fetchBookStaffs
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"is_book = %@",@1];
    return [self fetchItems:@"CDStaff" sortedByKey:@"staffID" ascending:true predicate:predicate];
}

#pragma mark - pad 卡券模板

- (NSFetchedResultsController *)fetchCardTemplates
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CDCardTemplate"];
    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"card_type" ascending:true];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"money" ascending:true];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor1,sortDescriptor2]];
    //    [fetchRequest setSortDescriptors:@[sortDescriptor1,sortDescriptor2]];
    
    NSFetchedResultsController *fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"card_type" cacheName:nil];
    
    [fetchResultsController performFetch:nil];
    
    return fetchResultsController;
}

- (NSArray *)fetchCardTemplatesWithType:(NSInteger)type
{
    //('1', u'会员卡'), ('2', u'礼品券'), ('3', u'礼品卡')
    NSPredicate *predicate;
    if (type != 0) {
        predicate = [NSPredicate predicateWithFormat:@"card_type = %@",@(type)];
    }
    return [self fetchItems:@"CDCardTemplate" sortedByKey:@"template_id" ascending:true predicate:predicate];
}


- (NSArray *)fetchCardTemplateProducts:(CDCardTemplate *)cardTemplate
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"template_id = %@",cardTemplate.template_id];
    
    return [self fetchItems:@"CDCardTemplateProduct" sortedByKey:@"line_id" ascending:true predicate:predicate];
}

- (NSArray *)fetchWXCardTemplatesList
{
    return [self fetchItems:@"CDWXCardTemplate" sortedByKey:@"sortIndex"];
}

#pragma mark -
#pragma mark Message

- (NSArray*)fetchAllMessage;
{
    return [self fetchItems:@"CDMessage" sortedByKey:@"time" ascending:NO];
}

- (NSArray*)fetchUnReadMessage
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isRead == 0"];
    return [self fetchItems:@"CDMessage" sortedByKey:@"messageID" ascending:NO predicate:predicate];
}

- (NSArray*)fetchUnSendMessage
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSend == 0 and isRead = 1"];
    return [self fetchItems:@"CDMessage" sortedByKey:@"messageID" ascending:NO predicate:predicate];
}

- (NSString *)fetchMessageLastCreateTime
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDMessage" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:false];
    NSArray *sortArry = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArry];
    fetchRequest.fetchLimit = 1;
    
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (array.count > 0)
    {
        id object = [array objectAtIndex:0];
        if (object && [object respondsToSelector:@selector(time)])
        {
            NSString *time = [object performSelector:@selector(time) withObject:nil];
            return time;
        }
    }
    
    return nil;
}

- (NSArray*)fetchWePosTranWithMonth:(NSString*)yearmonth phoneNumber:(NSString*)phoneNumber
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year_month == %@ && phoneNumber == %@",yearmonth,phoneNumber];
    return [self fetchItems:@"CDWePosTran" sortedByKey:@"time" ascending:NO predicate:predicate];
}

//医美
- (NSArray *)fetchTopKeshi
{
    NSPredicate *predicate = nil;
#if 0
    if ( [PersonalProfile currentProfile].departments_ids.count > 0 )
    {
        predicate = [NSPredicate predicateWithFormat:@"keshi_id in %@ && parentID == 0",[PersonalProfile currentProfile].departments_ids];
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"parentID == 0"];
    }
#else
    predicate = [NSPredicate predicateWithFormat:@"parentID == 0"];
#endif
    return [self fetchItems:@"CDKeShi" sortedByKey:@"keshi_id" ascending:true predicate:predicate];
}

- (NSArray *)fetchALLKeshi
{
    return [self fetchItems:@"CDKeShi" sortedByKey:@"keshi_id" ascending:true];
}

- (NSArray *)fetchKeshiRemark
{
    return [self fetchItems:@"CDKeshiRemarks" sortedByKey:@"remark_id" ascending:true];
}

- (NSArray *)fetchChildKeshi:(CDKeShi*)parent
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parentID == %@",parent.keshi_id];
    return [self fetchItems:@"CDKeShi" sortedByKey:@"keshi_id" ascending:true predicate:predicate];
}

- (NSArray *)fetchALLWorkFlowActivity
{
    return [self fetchItems:@"CDWorkFlowActivity"];
}

- (NSArray *)fetchSortedWorkFlowActivity
{
    NSArray* array = [self fetchALLWorkFlowActivity];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:array.count];
    
    NSNumber* parentID = @(0);
    
    for ( CDWorkFlowActivity* w in array )
    {
        [params setObject:w forKey:w.workID];
        if ( [w.isEnd boolValue] )
        {
            parentID = w.workID;
        }
    }
    
    NSMutableArray* sortedArray = [NSMutableArray array];
    
    while ( TRUE )
    {
        CDWorkFlowActivity* w = params[parentID];
        if ( [w.parentID integerValue] == 0 )
            break;
        
        [sortedArray insertObject:w atIndex:0];
        parentID = w.parentID;
    }
    
    return sortedArray;
}

- (NSArray *)fetchYimeiPosOperates:(NSNumber*)workID
{
    CDWorkFlowActivity* w = [self findEntity:@"CDWorkFlowActivity" withValue:workID forKey:@"workID"];
    if ( [w.isEnd boolValue] )
    {
        NSPredicate *predicate = nil;
        if ( [PersonalProfile currentProfile].departments_ids.count > 0 )
        {
            predicate = [NSPredicate predicateWithFormat:@"currentWorkflowID == %@ && keshi_id in %@ && current_workflow_activity_id > 0", workID,[PersonalProfile currentProfile].departments_ids];
        }
        else
        {
            predicate = [NSPredicate predicateWithFormat:@"currentWorkflowID == %@ && current_workflow_activity_id > 0", workID];
        }
        
        return [self fetchItems:@"CDPosOperate" sortedByKey:@"yimei_orderIndex" ascending:YES predicate:predicate];
    }
    
    NSPredicate *predicate = nil;
    if ( [PersonalProfile currentProfile].departments_ids.count > 0 )
    {
        predicate = [NSPredicate predicateWithFormat:@"currentWorkflowID == %@ && keshi_id in %@ && current_workflow_activity_id > 0", workID, [PersonalProfile currentProfile].departments_ids];
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"currentWorkflowID == %@ && current_workflow_activity_id > 0", workID];
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDPosOperate" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:@"yimei_orderIndex" ascending:YES];
    NSSortDescriptor* des2 = [NSSortDescriptor sortDescriptorWithKey:@"operate_date" ascending:YES];
    [fetchRequest setSortDescriptors: @[des,des2]];
    if ( predicate )
    {
        [fetchRequest setPredicate: predicate];
    }
    
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSInteger)fetchYimeiRoleOptionWithWorkID:(NSNumber*)workID
{
    CDWorkFlowActivity* w = [self findEntity:@"CDWorkFlowActivity" withValue:workID forKey:@"workID"];
    return [w.role integerValue];
}

//医院
- (NSArray *)fetchAllCustomer
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDHCustomer" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"memberID" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchAllCustomerWithStoreID:(NSNumber *)storeID
{
    return [self fetchAllCustomerWithStoreID:storeID keyword:nil];
}

- (NSArray *)fetchAllCustomerWithStoreID:(NSNumber *)storeID keyword:(NSString *)keyword
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDHCustomer" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSMutableArray *filters = [NSMutableArray array];
    [filters addObject:[NSPredicate predicateWithFormat:@"memberID > %@", @(0)]];
    
    if (keyword.length != 0)
    {
        if ( 1/*[keyword hasPrefix:@"1"]*/)
        {
            NSString *mobile = [NSString stringWithFormat:@"*%@*", keyword];
            [filters addObject:[NSPredicate predicateWithFormat:@"mobile like %@ || memberName contains[cd] %@ || memberNameLetter contains[cd] %@ || memberNameFirstLetter contains[cd] %@", mobile, keyword, keyword, keyword]];
        }
        else
        {
            [filters addObject:[NSPredicate predicateWithFormat:@"memberName contains[cd] %@ || memberNameLetter contains[cd] %@ || memberNameFirstLetter contains[cd] %@", keyword, keyword, keyword]];
        }
    }
    if (storeID.integerValue != 0)
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"storeID = %@", storeID]];
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filters];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"memberNameLetter" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObjects:sortDescriptor1, nil];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchAllHZixun:(NSString*)categoryName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDHZixun" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"zixun_id" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category_name == %@", categoryName];
    [fetchRequest setPredicate: predicate];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchAllHZixunWithStoreID:(NSNumber *)storeID categoryName:(NSString*)categoryName
{
    return [self fetchAllHZixunWithStoreID:storeID keyword:nil categoryName:categoryName];
}

- (NSArray *)fetchAllHZixunWithStoreID:(NSNumber *)storeID keyword:(NSString *)keyword categoryName:(NSString*)categoryName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDHZixun" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSMutableArray *filters = [NSMutableArray array];
    //[filters addObject:[NSPredicate predicateWithFormat:@"zixun_id > %@", @(0)]];
    
    if (keyword.length != 0)
    {
        if ( 1/*[keyword hasPrefix:@"1"]*/)
        {
            [filters addObject:[NSPredicate predicateWithFormat:@"customer_name contains[cd] %@ || nameLetter contains[cd] %@ || nameFirstLetter contains[cd] %@", keyword, keyword, keyword]];
        }
        else
        {
            [filters addObject:[NSPredicate predicateWithFormat:@"memberName contains[cd] %@ || memberNameLetter contains[cd] %@ || memberNameFirstLetter contains[cd] %@", keyword, keyword, keyword]];
        }
    }
    if (storeID.integerValue != 0)
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"storeID = %@", storeID]];
    }
    
    [filters addObject:[NSPredicate predicateWithFormat:@"category_name = %@", categoryName]];
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filters];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"zixun_id" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchAllFenzhen
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDHFenzhen" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fenzhen_id" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchAllFenzhenWithStoreID:(NSNumber *)storeID
{
    return [self fetchAllFenzhenWithStoreID:storeID keyword:nil];
}

- (NSArray *)fetchAllFenzhenWithStoreID:(NSNumber *)storeID keyword:(NSString *)keyword
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDHFenzhen" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSMutableArray *filters = [NSMutableArray array];
    [filters addObject:[NSPredicate predicateWithFormat:@"fenzhen_id > %@", @(0)]];
    
    if (keyword.length != 0)
    {
        if ( 1/*[keyword hasPrefix:@"1"]*/)
        {
            NSString *mobile = [NSString stringWithFormat:@"*%@*", keyword];
            [filters addObject:[NSPredicate predicateWithFormat:@"mobile like %@ || memberName contains[cd] %@ || memberNameLetter contains[cd] %@ || memberNameFirstLetter contains[cd] %@", mobile, keyword, keyword, keyword]];
        }
        else
        {
            [filters addObject:[NSPredicate predicateWithFormat:@"memberName contains[cd] %@ || memberNameLetter contains[cd] %@ || memberNameFirstLetter contains[cd] %@", keyword, keyword, keyword]];
        }
    }
    if (storeID.integerValue != 0)
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"storeID = %@", storeID]];
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filters];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fenzhen_id" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchAllJiaoHao:(NSString*)keyword isDepart:(BOOL)isDepart isFinish:(BOOL)isFinish isPrint:(BOOL)isPrint
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDHJiaoHao" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSMutableArray *filters = [NSMutableArray array];
    
    if (keyword.length != 0)
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"memberNameLetter contains[cd] %@ || memberNameFirstLetter contains[cd] %@ || customer_name contains[cd] %@",keyword, keyword, keyword]];
    }
#if 0
    if ( isDepart )
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"departments_id in %@ || create_uid = %@",[PersonalProfile currentProfile].departments_ids,[PersonalProfile currentProfile].userID]];
    }
    
    if ( isFinish )
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"progre_status = %@",@"done"]];
    }
    else
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"progre_status != %@",@"done"]];
    }
    
    if ( isPrint )
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"is_print = %@",@(TRUE)]];
    }
#endif
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filters];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"sort_index" ascending:YES];
    NSArray *sortArray = @[sortDescriptor1];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchAllPatientWithKeyword:(NSString*)keyword type:(HPatientListType)type isMyPatient:(BOOL)isMyPatient
{
    NSMutableArray *filters = [NSMutableArray array];
    [filters addObject:[NSPredicate predicateWithFormat:@"showPatient = %@",@(TRUE)]];
    
    if (keyword.length != 0)
    {
       [filters addObject:[NSPredicate predicateWithFormat:@"memberName contains[cd] %@ || memberNameLetter contains[cd] %@ || memberNameFirstLetter contains[cd] %@",keyword, keyword, keyword]];
    }
    
    if ( type != HPatientListType_ALL )
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"h_patient_type = %d",type]];
    }
    else
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"h_patient_type = %d",HPatientListType_Recent]];
    }
    
    NSNumber* doctorID = [PersonalProfile currentProfile].employeeID;
    if ( isMyPatient && doctorID.integerValue > 0 )
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"doctor_id = %@",doctorID]];
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filters];
    
    NSArray *array = [self fetchItems:@"CDMember" sortedByKey:@"sortIndex" ascending:YES predicate:predicate];
    
    return array;
}

- (NSArray *)fetchMemberVisit:(NSString*)category keyword:(NSString*)keyword
{
    NSMutableArray *filters = [NSMutableArray array];
    if ( category.length > 0 )
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"category = %@",category]];
    }
    
    if (keyword.length != 0)
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"name contains[cd] %@ || nameLetter contains[cd] %@ || nameFirstLetter contains[cd] %@",keyword, keyword, keyword]];
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filters];
    
    NSArray *array = [self fetchItems:@"CDMemberVisit" sortedByKey:@"sortIndex" ascending:YES predicate:predicate];
    
    return array;
}

- (NSArray<CDZixunBook *> *)fetchAllZixunBook
{
    return [self fetchItems:@"CDZixunBook" sortedByKey:@"sort_index" ascending:YES];
}

- (NSArray<CDZixunBook *> *)fetchDaodianZixunBook:(NSString*)keyword
{
    NSMutableArray *filters = [NSMutableArray array];
    [filters addObject:[NSPredicate predicateWithFormat:@"advisory_state == %@", @"draft"]];

    if (keyword.length != 0)
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"name contains[cd] %@ || nameLetter contains[cd] %@ || nameFirstLetter contains[cd] %@",keyword, keyword, keyword]];
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filters];
    
    return [self fetchItems:@"CDZixunBook" sortedByKey:@"sort_index" ascending:YES predicate:predicate];
}

- (NSArray<CDZixunBook *> *)fetchDaodianZixunBook1:(NSString*)keyword
{
    NSMutableArray *filters = [NSMutableArray array];
    [filters addObject:[NSPredicate predicateWithFormat:@"state == %@", @"billed"]];
    
    if (keyword.length != 0)
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"name contains[cd] %@ || nameLetter contains[cd] %@ || nameFirstLetter contains[cd] %@",keyword, keyword, keyword]];
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filters];
    
    return [self fetchItems:@"CDZixunBook" sortedByKey:@"sort_index" ascending:YES predicate:predicate];
}

- (NSArray<CDZixunBook *> *)fetchDaodianZixunBook2:(NSString*)keyword
{
    NSMutableArray *filters = [NSMutableArray array];
    [filters addObject:[NSPredicate predicateWithFormat:@"state == %@ || state == %@", @"done", @"visit"]];
    
    if (keyword.length != 0)
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"name contains[cd] %@ || nameLetter contains[cd] %@ || nameFirstLetter contains[cd] %@",keyword, keyword, keyword]];
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filters];
    
    return [self fetchItems:@"CDZixunBook" sortedByKey:@"sort_index" ascending:YES predicate:predicate];
}

- (NSArray<CDBingFangBook *> *)fetchAllBingfangBook
{
    return [self fetchItems:@"CDBingFangBook" sortedByKey:@"sort_index" ascending:YES];
}

- (NSArray<CDBingFangBook *> *)fetchDaodianBingfangBook:(NSString*)keyword
{
    NSMutableArray *filters = [NSMutableArray array];
    [filters addObject:[NSPredicate predicateWithFormat:@"state == %@ || state == %@", @"done", @"checking"]];

    if (keyword.length != 0)
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"name contains[cd] %@ || nameLetter contains[cd] %@ || nameFirstLetter contains[cd] %@",keyword, keyword, keyword]];
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filters];
    
    return [self fetchItems:@"CDBingFangBook" sortedByKey:@"sort_index" ascending:YES predicate:predicate];
}

- (NSArray<CDBingFangBook *> *)fetchDaodianBingfangBook1:(NSString*)keyword
{
    NSMutableArray *filters = [NSMutableArray array];
    [filters addObject:[NSPredicate predicateWithFormat:@"state == %@ || state == %@", @"apply", @"checking"]];

    if (keyword.length != 0)
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"name contains[cd] %@ || nameLetter contains[cd] %@ || nameFirstLetter contains[cd] %@",keyword, keyword, keyword]];
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filters];
    
    return [self fetchItems:@"CDBingFangBook" sortedByKey:@"sort_index" ascending:YES predicate:predicate];
}

- (NSArray<CDBingFangBook *> *)fetchDaodianBingfangBook2:(NSString*)keyword
{
    NSMutableArray *filters = [NSMutableArray array];
    [filters addObject:[NSPredicate predicateWithFormat:@"state == %@", @"wait"]];
    
    if (keyword.length != 0)
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"name contains[cd] %@ || nameLetter contains[cd] %@ || nameFirstLetter contains[cd] %@",keyword, keyword, keyword]];
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filters];
    
    return [self fetchItems:@"CDBingFangBook" sortedByKey:@"sort_index" ascending:YES predicate:predicate];
}

- (NSArray<CDZixunBook *> *)fetchYuyueZixunBook:(NSString*)keyword
{
    NSMutableArray *filters = [NSMutableArray array];
    [filters addObject:[NSPredicate predicateWithFormat:@"state == %@", @"approved"]];
    
    if (keyword.length != 0)
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"name contains[cd] %@ || nameLetter contains[cd] %@ || nameFirstLetter contains[cd] %@",keyword, keyword, keyword]];
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filters];
    
    return [self fetchItems:@"CDZixunBook" sortedByKey:@"sort_index" ascending:YES predicate:predicate];
}

- (NSArray<CDBingFangBook *> *)fetchYuyueBingfangBook:(NSString *)keyword
{
    NSMutableArray *filters = [NSMutableArray array];
    [filters addObject:[NSPredicate predicateWithFormat:@"state == %@", @"approved"]];
    
    if (keyword.length != 0)
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"name contains[cd] %@ || nameLetter contains[cd] %@ || nameFirstLetter contains[cd] %@",keyword, keyword, keyword]];
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filters];
    
    return [self fetchItems:@"CDBingFangBook" sortedByKey:@"sort_index" ascending:YES predicate:predicate];
}

- (NSArray<CDZixunRoom *> *)fetchAllZixunRoom
{
    return [self fetchItems:@"CDZixunRoom" sortedByKey:@"sort_index" ascending:YES];
}

- (NSArray<CDBingfangRoom *> *)fetchAllBingfangRoom
{
    return [self fetchItems:@"CDBingfangRoom" sortedByKey:@"sort_index" ascending:YES];
}

- (NSArray *)fetchAllZixunWithType:(NSString *)type keyword:(NSString *)keyword memberID:(NSNumber*)memberID zixunID:(NSNumber*)zixunID
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDZixun" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSMutableArray *filters = [NSMutableArray array];
    
    if ( keyword.length != 0 )
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"member_name contains[cd] %@ || nameLetter contains[cd] %@ || nameFirstLetter contains[cd] %@", keyword, keyword, keyword]];
    }
    
    if ( memberID.integerValue > 0 )
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"member_id = %@ && zixun_id != %@", memberID,zixunID]];
    }
    else if ( type.length > 0 )
    {
        if ( [type isEqualToString:@"today"] )
        {
            [filters addObject:[NSPredicate predicateWithFormat:@"zixun_local_type = %@ || zixun_local_type = %@", @"today",@"waiting"]];
        }
        else
        {
            [filters addObject:[NSPredicate predicateWithFormat:@"zixun_local_type = %@", type]];
        }
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filters];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sort_index" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray<CDQuestion *> *_Nonnull)fetchAllQuestion
{
    return [self fetchItems:@"CDQuestion"];
}

- (NSArray<CDQuestionResult *> *_Nonnull)fetchAllQuestionResult
{
    return [self fetchItems:@"CDQuestionResult"];
}

- (CDQuestion*)fetchFirstQuestion
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"is_first == TRUE"];
    
    NSArray* array =  [self fetchItems:@"CDQuestion" sortedByKey:@"question_id" ascending:YES predicate:predicate];
    
    if ( array.count > 0 )
    {
        return array[0];
    }
    
    return nil;
}

- (CDQuestion*)fetchQuestionWithQuestionID:(NSNumber*)questionID
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"question_id == %@",questionID];
    
    NSArray* array =  [self fetchItems:@"CDQuestion" sortedByKey:@"question_id" ascending:YES predicate:predicate];
    
    if ( array.count > 0 )
    {
        return array[0];
    }
    
    return nil;
}

- (CDQuestionResult*)fetchQuestionResultWith:(NSNumber*)resultID
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"result_id == %@",resultID];
    
    NSArray* array =  [self fetchItems:@"CDQuestionResult" sortedByKey:@"result_id" ascending:YES predicate:predicate];
    
    if ( array.count > 0 )
    {
        return array[0];
    }
    
    return nil;

}

- (NSArray<CDQuestionResult *> *_Nonnull)fetchAllZongkongRoom
{
    return [self fetchItems:@"CDZongkongShoushuRoom" sortedByKey:@"sort_index" ascending:YES];
}

- (NSArray<CDQuestionResult *> *_Nonnull)fetchAllDoctorPerson
{
    return [self fetchItems:@"CDZongkongDoctorPerson" sortedByKey:@"sort_index" ascending:YES];
}

- (NSArray<CDQuestionResult *> *_Nonnull)fetchAllZongkongLiyuanPersons
{
    return [self fetchItems:@"CDZongkongLiyuanPerson" sortedByKey:@"sort_index" ascending:YES];
}

- (NSArray<CDPosWashHand *> *_Nonnull)fetchAllWashHandWithID:(nullable NSNumber *)workID keyword:(nullable NSString *)keyword isDone:(BOOL)isDone
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDPosWashHand" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSMutableArray *filters = [NSMutableArray array];
    
    if ( keyword.length != 0 )
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"member_name contains[cd] %@ || nameLetter contains[cd] %@ || nameFirstLetter contains[cd] %@", keyword, keyword, keyword]];
    }
    
    if ( workID.integerValue > 0 )
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"currentWorkflowID = %@", workID]];
    }
    
    if ( isDone > 0 )
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"state = %@", @"done"]];
    }
    else
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"state != %@", @"done"]];
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filters];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sort_index" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray *)fetchYimeiHistoryByKeyword:(NSString*)keyword
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDYimeiHistory" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSMutableArray *filters = [NSMutableArray array];
    
    if ( keyword.length != 0 )
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"member_name contains[cd] %@ || nameLetter contains[cd] %@ || nameFirstLetter contains[cd] %@", keyword, keyword, keyword]];
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filters];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sort_index" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray<CDHHuizhenCategory *> *_Nonnull)fetchAllHuizhenCategory
{
    return [self fetchItems:@"CDHHuizhenCategory" sortedByKey:@"sort_index" ascending:YES];
}

- (NSArray<CDHHuizhenCategory *> *_Nonnull)fetchAllTopHuizhenCategory
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"parent_id == %@",@(0)];
    
    NSArray* array =  [self fetchItems:@"CDHHuizhenCategory" sortedByKey:@"sort_index" ascending:YES predicate:predicate];
    
    return array;
}

- (NSArray<CDHGuadan *> *_Nonnull)fetchAllGuadan:(nullable NSString*)keyword
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDHGuadan" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSMutableArray *filters = [NSMutableArray array];
    
    if ( keyword.length != 0 )
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"member_name contains[cd] %@ || nameLetter contains[cd] %@ || nameFirstLetter contains[cd] %@", keyword, keyword, keyword]];
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filters];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sort_index" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray<CDH9SSAP *> *_Nonnull)fetchH9SSAP:(nullable NSString *)dateString
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDH9SSAP" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSMutableArray *filters = [NSMutableArray array];
    
    if ( dateString.length > 0 )
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"year_month = %@", dateString]];
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filters];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sort_index" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray<CDH9SSAP *> *_Nonnull)fetchH9SSAPDetail:(nullable NSString *)dateString
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDH9SSAPEvent" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSMutableArray *filters = [NSMutableArray array];
    
    if ( dateString.length > 0 )
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"year_month_day = %@", dateString]];
    }
    else
    {
        return @[];
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filters];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sort_index" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray<CDH9Notify *> *_Nonnull)fetchH9Notify:(nullable NSString *)read
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDH9Notify" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSMutableArray *filters = [NSMutableArray array];
    
    if ( read.length > 0 )
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"state = %@", read]];
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filters];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sort_index" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSArray<CDH9ShoushuTag *> *_Nonnull)fetchH9Shoushutag:(NSString*)keyword
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDH9ShoushuTag" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSMutableArray *filters = [NSMutableArray array];
    
    if ( keyword.length != 0 )
    {
        [filters addObject:[NSPredicate predicateWithFormat:@"name contains[cd] %@ || memberNameLetter contains[cd] %@ || memberNameFirstLetter contains[cd] %@", keyword, keyword, keyword]];
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filters];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"memberNameLetter" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (void)DeleteH9Shoushutag:(NSArray*)ids
{
    if ( ids.count > 0 )
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tag_id in %@",ids];
        
        [self deleteObjects:[self fetchItems:@"CDH9ShoushuTag" sortedByKey:@"sort_id" ascending:YES predicate:predicate]];
    }
}

- (NSArray<CDHFetchResult *> *_Nonnull)fetchH9SSAPSearchResult
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDHFetchResult" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSMutableArray *filters = [NSMutableArray array];
    
//    for (NSDictionary *dict in condition) {
//        
//    }
//    if ( dateString.length > 0 )
//    {
//        [filters addObject:[NSPredicate predicateWithFormat:@"year_month_day = %@", dateString]];
//    }
//    else
//    {
//        return @[];
//    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filters];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"shoushu_id" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

@end
