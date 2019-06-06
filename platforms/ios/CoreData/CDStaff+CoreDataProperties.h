//
//  CDStaff+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2017/5/26.
//
//

#import "CDStaff+CoreDataClass.h"
@class CDKeShi;

NS_ASSUME_NONNULL_BEGIN

@interface CDStaff (CoreDataProperties)

+ (NSFetchRequest<CDStaff *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *address_id;
@property (nullable, nonatomic, copy) NSString *address_name;
@property (nullable, nonatomic, copy) NSString *birthday;
@property (nullable, nonatomic, copy) NSNumber *departmemt_id;
@property (nullable, nonatomic, copy) NSString *departmemt_name;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *gender;
@property (nullable, nonatomic, copy) NSString *hr_category;
@property (nullable, nonatomic, copy) NSString *imgName;
@property (nullable, nonatomic, copy) NSNumber *is_book;
@property (nullable, nonatomic, copy) NSNumber *is_login;
@property (nullable, nonatomic, copy) NSNumber *job_id;
@property (nullable, nonatomic, copy) NSString *job_name;
@property (nullable, nonatomic, copy) NSString *last_time;
@property (nullable, nonatomic, copy) NSString *latestBookTime;
@property (nullable, nonatomic, copy) NSString *local_nickName;
@property (nullable, nonatomic, copy) NSString *mobile_phone;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *nameLetter;
@property (nullable, nonatomic, copy) NSString *password;
@property (nullable, nonatomic, copy) NSNumber *rule_id;
@property (nullable, nonatomic, copy) NSString *rule_name;
@property (nullable, nonatomic, copy) NSNumber *staffID;
@property (nullable, nonatomic, copy) NSString *staffNo;
@property (nullable, nonatomic, copy) NSNumber *template_id;
@property (nullable, nonatomic, copy) NSNumber *user_id;
@property (nullable, nonatomic, copy) NSString *work_location;
@property (nullable, nonatomic, copy) NSNumber *book_time;
@property (nullable, nonatomic, retain) CDCommissionRule *commissionRule;
@property (nullable, nonatomic, retain) CDStaffDepartment *department;
@property (nullable, nonatomic, retain) NSOrderedSet<CDMember *> *guwen_members;
@property (nullable, nonatomic, retain) NSOrderedSet<CDMember *> *jishi_members;
@property (nullable, nonatomic, retain) CDStaffJob *job;
@property (nullable, nonatomic, retain) NSSet<CDKeShi *> *keshi;
@property (nullable, nonatomic, retain) NSSet<CDKeShi *> *keshi_operate;
@property (nullable, nonatomic, retain) NSSet<CDStaffDepartment *> *managerDepartments;
@property (nullable, nonatomic, retain) CDPosConfig *pos;
@property (nullable, nonatomic, retain) CDStaffRole *role;
@property (nullable, nonatomic, retain) CDStore *store;
@property (nullable, nonatomic, retain) NSOrderedSet<CDMember *> *tuijians;
@property (nullable, nonatomic, retain) CDUser *user;

@end

@interface CDStaff (CoreDataGeneratedAccessors)

- (void)insertObject:(CDMember *)value inGuwen_membersAtIndex:(NSUInteger)idx;
- (void)removeObjectFromGuwen_membersAtIndex:(NSUInteger)idx;
- (void)insertGuwen_members:(NSArray<CDMember *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeGuwen_membersAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInGuwen_membersAtIndex:(NSUInteger)idx withObject:(CDMember *)value;
- (void)replaceGuwen_membersAtIndexes:(NSIndexSet *)indexes withGuwen_members:(NSArray<CDMember *> *)values;
- (void)addGuwen_membersObject:(CDMember *)value;
- (void)removeGuwen_membersObject:(CDMember *)value;
- (void)addGuwen_members:(NSOrderedSet<CDMember *> *)values;
- (void)removeGuwen_members:(NSOrderedSet<CDMember *> *)values;

- (void)insertObject:(CDMember *)value inJishi_membersAtIndex:(NSUInteger)idx;
- (void)removeObjectFromJishi_membersAtIndex:(NSUInteger)idx;
- (void)insertJishi_members:(NSArray<CDMember *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeJishi_membersAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInJishi_membersAtIndex:(NSUInteger)idx withObject:(CDMember *)value;
- (void)replaceJishi_membersAtIndexes:(NSIndexSet *)indexes withJishi_members:(NSArray<CDMember *> *)values;
- (void)addJishi_membersObject:(CDMember *)value;
- (void)removeJishi_membersObject:(CDMember *)value;
- (void)addJishi_members:(NSOrderedSet<CDMember *> *)values;
- (void)removeJishi_members:(NSOrderedSet<CDMember *> *)values;

- (void)addKeshiObject:(CDKeShi *)value;
- (void)removeKeshiObject:(CDKeShi *)value;
- (void)addKeshi:(NSSet<CDKeShi *> *)values;
- (void)removeKeshi:(NSSet<CDKeShi *> *)values;

- (void)addKeshi_operateObject:(CDKeShi *)value;
- (void)removeKeshi_operateObject:(CDKeShi *)value;
- (void)addKeshi_operate:(NSSet<CDKeShi *> *)values;
- (void)removeKeshi_operate:(NSSet<CDKeShi *> *)values;

- (void)addManagerDepartmentsObject:(CDStaffDepartment *)value;
- (void)removeManagerDepartmentsObject:(CDStaffDepartment *)value;
- (void)addManagerDepartments:(NSSet<CDStaffDepartment *> *)values;
- (void)removeManagerDepartments:(NSSet<CDStaffDepartment *> *)values;

- (void)insertObject:(CDMember *)value inTuijiansAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTuijiansAtIndex:(NSUInteger)idx;
- (void)insertTuijians:(NSArray<CDMember *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTuijiansAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTuijiansAtIndex:(NSUInteger)idx withObject:(CDMember *)value;
- (void)replaceTuijiansAtIndexes:(NSIndexSet *)indexes withTuijians:(NSArray<CDMember *> *)values;
- (void)addTuijiansObject:(CDMember *)value;
- (void)removeTuijiansObject:(CDMember *)value;
- (void)addTuijians:(NSOrderedSet<CDMember *> *)values;
- (void)removeTuijians:(NSOrderedSet<CDMember *> *)values;

@end

NS_ASSUME_NONNULL_END
