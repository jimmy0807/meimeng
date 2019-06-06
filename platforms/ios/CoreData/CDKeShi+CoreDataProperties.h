//
//  CDKeShi+CoreDataProperties.h
//  meim
//
//  Created by 波恩公司 on 2018/2/5.
//
//

#import "CDKeShi+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDKeShi (CoreDataProperties)

+ (NSFetchRequest<CDKeShi *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *doctor_id;
@property (nullable, nonatomic, copy) NSString *doctor_name;
@property (nullable, nonatomic, copy) NSNumber *is_display_adviser;
@property (nullable, nonatomic, copy) NSNumber *is_display_designer;
@property (nullable, nonatomic, copy) NSNumber *keshi_id;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *parentID;
@property (nullable, nonatomic, copy) NSString *remark_ids;
@property (nullable, nonatomic, retain) NSOrderedSet<CDStaff *> *operate_machine;
@property (nullable, nonatomic, retain) CDPosOperate *operate1;
@property (nullable, nonatomic, retain) NSOrderedSet<CDStaff *> *staff;

@end

@interface CDKeShi (CoreDataGeneratedAccessors)

- (void)insertObject:(CDStaff *)value inOperate_machineAtIndex:(NSUInteger)idx;
- (void)removeObjectFromOperate_machineAtIndex:(NSUInteger)idx;
- (void)insertOperate_machine:(NSArray<CDStaff *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeOperate_machineAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInOperate_machineAtIndex:(NSUInteger)idx withObject:(CDStaff *)value;
- (void)replaceOperate_machineAtIndexes:(NSIndexSet *)indexes withOperate_machine:(NSArray<CDStaff *> *)values;
- (void)addOperate_machineObject:(CDStaff *)value;
- (void)removeOperate_machineObject:(CDStaff *)value;
- (void)addOperate_machine:(NSOrderedSet<CDStaff *> *)values;
- (void)removeOperate_machine:(NSOrderedSet<CDStaff *> *)values;

- (void)insertObject:(CDStaff *)value inStaffAtIndex:(NSUInteger)idx;
- (void)removeObjectFromStaffAtIndex:(NSUInteger)idx;
- (void)insertStaff:(NSArray<CDStaff *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeStaffAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInStaffAtIndex:(NSUInteger)idx withObject:(CDStaff *)value;
- (void)replaceStaffAtIndexes:(NSIndexSet *)indexes withStaff:(NSArray<CDStaff *> *)values;
- (void)addStaffObject:(CDStaff *)value;
- (void)removeStaffObject:(CDStaff *)value;
- (void)addStaff:(NSOrderedSet<CDStaff *> *)values;
- (void)removeStaff:(NSOrderedSet<CDStaff *> *)values;

@end

NS_ASSUME_NONNULL_END
