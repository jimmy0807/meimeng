//
//  CDStore+CoreDataProperties.h
//  Boss
//
//  Created by XiaXianBing on 2016-3-16.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDStore.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDStore (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *companyID;
@property (nullable, nonatomic, retain) NSString *companyName;
@property (nullable, nonatomic, retain) NSString *createDate;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *lastUpdate;
@property (nullable, nonatomic, retain) NSString *logo;
@property (nullable, nonatomic, retain) NSString *mobile;
@property (nullable, nonatomic, retain) NSString *phone;
@property (nullable, nonatomic, retain) NSString *shop_uuid;
@property (nullable, nonatomic, retain) NSNumber *storeID;
@property (nullable, nonatomic, retain) NSString *storeName;
@property (nullable, nonatomic, retain) NSString *storeNameLetter;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) NSOrderedSet<CDMember *> *members;
@property (nullable, nonatomic, retain) NSSet<CDPosOperate *> *operates;
@property (nullable, nonatomic, retain) NSSet<CDPurchaseOrder *> *puchaseOrders;
@property (nullable, nonatomic, retain) NSSet<CDStaff *> *staff;
@property (nullable, nonatomic, retain) CDMemberCard *memberCard;

@end

@interface CDStore (CoreDataGeneratedAccessors)

- (void)insertObject:(CDMember *)value inMembersAtIndex:(NSUInteger)idx;
- (void)removeObjectFromMembersAtIndex:(NSUInteger)idx;
- (void)insertMembers:(NSArray<CDMember *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeMembersAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInMembersAtIndex:(NSUInteger)idx withObject:(CDMember *)value;
- (void)replaceMembersAtIndexes:(NSIndexSet *)indexes withMembers:(NSArray<CDMember *> *)values;
- (void)addMembersObject:(CDMember *)value;
- (void)removeMembersObject:(CDMember *)value;
- (void)addMembers:(NSOrderedSet<CDMember *> *)values;
- (void)removeMembers:(NSOrderedSet<CDMember *> *)values;

- (void)addOperatesObject:(CDPosOperate *)value;
- (void)removeOperatesObject:(CDPosOperate *)value;
- (void)addOperates:(NSSet<CDPosOperate *> *)values;
- (void)removeOperates:(NSSet<CDPosOperate *> *)values;

- (void)addPuchaseOrdersObject:(CDPurchaseOrder *)value;
- (void)removePuchaseOrdersObject:(CDPurchaseOrder *)value;
- (void)addPuchaseOrders:(NSSet<CDPurchaseOrder *> *)values;
- (void)removePuchaseOrders:(NSSet<CDPurchaseOrder *> *)values;

- (void)addStaffObject:(CDStaff *)value;
- (void)removeStaffObject:(CDStaff *)value;
- (void)addStaff:(NSSet<CDStaff *> *)values;
- (void)removeStaff:(NSSet<CDStaff *> *)values;

@end

NS_ASSUME_NONNULL_END
