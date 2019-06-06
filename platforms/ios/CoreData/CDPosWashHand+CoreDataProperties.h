//
//  CDPosWashHand+CoreDataProperties.h
//  meim
//
//  Created by 波恩公司 on 2018/4/27.
//
//

#import "CDPosWashHand+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDPosWashHand (CoreDataProperties)

+ (NSFetchRequest<CDPosWashHand *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *anesthetist_id;
@property (nullable, nonatomic, copy) NSString *anesthetist_name;
@property (nullable, nonatomic, copy) NSNumber *binglika_id;
@property (nullable, nonatomic, copy) NSNumber *current_activity_id;
@property (nullable, nonatomic, copy) NSNumber *current_work_index;
@property (nullable, nonatomic, copy) NSNumber *currentWorkflowID;
@property (nullable, nonatomic, copy) NSString *display_remark;
@property (nullable, nonatomic, copy) NSNumber *doctor_id;
@property (nullable, nonatomic, copy) NSString *doctor_name;
@property (nullable, nonatomic, copy) NSNumber *flow_end;
@property (nullable, nonatomic, copy) NSString *fumayao_time;
@property (nullable, nonatomic, copy) NSString *imageUrl;
@property (nullable, nonatomic, copy) NSNumber *keshi_id;
@property (nullable, nonatomic, copy) NSString *keshi_name;
@property (nullable, nonatomic, copy) NSString *medical_note;
@property (nullable, nonatomic, copy) NSString *diagnose;
@property (nullable, nonatomic, copy) NSString *treatment;
@property (nullable, nonatomic, copy) NSNumber *member_id;
@property (nullable, nonatomic, copy) NSString *member_mobile;
@property (nullable, nonatomic, copy) NSString *member_name;
@property (nullable, nonatomic, copy) NSString *member_name_detail;
@property (nullable, nonatomic, copy) NSString *memberNameFirstLetter;
@property (nullable, nonatomic, copy) NSString *memberNameLetter;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *note;
@property (nullable, nonatomic, copy) NSNumber *operate_activity_id;
@property (nullable, nonatomic, copy) NSString *operate_date;
@property (nullable, nonatomic, copy) NSString *operate_date_detail;
@property (nullable, nonatomic, copy) NSNumber *operate_id;
@property (nullable, nonatomic, copy) NSNumber *peitai_nurse_id;
@property (nullable, nonatomic, copy) NSString *peitai_nurse_name;
@property (nullable, nonatomic, copy) NSString *prescriptions;
@property (nullable, nonatomic, copy) NSString *print_url;
@property (nullable, nonatomic, copy) NSString *remark;
@property (nullable, nonatomic, copy) NSString *consumable_ids;
@property (nullable, nonatomic, copy) NSNumber *role_option;
@property (nullable, nonatomic, copy) NSString *sign_member_name;
@property (nullable, nonatomic, copy) NSNumber *sort_index;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSString *work_names;
@property (nullable, nonatomic, copy) NSNumber *xunhui_nurse_id;
@property (nullable, nonatomic, copy) NSString *xunhui_nurse_name;
@property (nullable, nonatomic, copy) NSString *yimei_guwenName;
@property (nullable, nonatomic, copy) NSString *yimei_member_type;
@property (nullable, nonatomic, copy) NSString *yimei_operate_employee_ids;
@property (nullable, nonatomic, copy) NSString *yimei_operate_employee_name;
@property (nullable, nonatomic, copy) NSString *yimei_queueID;
@property (nullable, nonatomic, copy) NSString *yimei_shejishiName;
@property (nullable, nonatomic, copy) NSString *yimei_shejizongjianName;
@property (nullable, nonatomic, copy) NSString *yimei_sign_after;
@property (nullable, nonatomic, copy) NSString *yimei_sign_before;
@property (nullable, nonatomic, copy) NSString *customer_state_name;
@property (nullable, nonatomic, copy) NSString *customer_state;
@property (nullable, nonatomic, copy) NSString *activity_state_name;
@property (nullable, nonatomic, copy) NSString *activity_state;
@property (nullable, nonatomic, retain) NSOrderedSet<CDMedicalItem *> *chufang_items;
@property (nullable, nonatomic, retain) NSOrderedSet<CDMedicalItem *> *feichufang_items;
@property (nullable, nonatomic, retain) NSOrderedSet<CDYimeiImage *> *yimei_before;

@end

@interface CDPosWashHand (CoreDataGeneratedAccessors)

- (void)insertObject:(CDMedicalItem *)value inChufang_itemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromChufang_itemsAtIndex:(NSUInteger)idx;
- (void)insertChufang_items:(NSArray<CDMedicalItem *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeChufang_itemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInChufang_itemsAtIndex:(NSUInteger)idx withObject:(CDMedicalItem *)value;
- (void)replaceChufang_itemsAtIndexes:(NSIndexSet *)indexes withChufang_items:(NSArray<CDMedicalItem *> *)values;
- (void)addChufang_itemsObject:(CDMedicalItem *)value;
- (void)removeChufang_itemsObject:(CDMedicalItem *)value;
- (void)addChufang_items:(NSOrderedSet<CDMedicalItem *> *)values;
- (void)removeChufang_items:(NSOrderedSet<CDMedicalItem *> *)values;

- (void)insertObject:(CDMedicalItem *)value inFeichufang_itemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFeichufang_itemsAtIndex:(NSUInteger)idx;
- (void)insertFeichufang_items:(NSArray<CDMedicalItem *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFeichufang_itemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFeichufang_itemsAtIndex:(NSUInteger)idx withObject:(CDMedicalItem *)value;
- (void)replaceFeichufang_itemsAtIndexes:(NSIndexSet *)indexes withFeichufang_items:(NSArray<CDMedicalItem *> *)values;
- (void)addFeichufang_itemsObject:(CDMedicalItem *)value;
- (void)removeFeichufang_itemsObject:(CDMedicalItem *)value;
- (void)addFeichufang_items:(NSOrderedSet<CDMedicalItem *> *)values;
- (void)removeFeichufang_items:(NSOrderedSet<CDMedicalItem *> *)values;

- (void)insertObject:(CDYimeiImage *)value inYimei_beforeAtIndex:(NSUInteger)idx;
- (void)removeObjectFromYimei_beforeAtIndex:(NSUInteger)idx;
- (void)insertYimei_before:(NSArray<CDYimeiImage *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeYimei_beforeAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInYimei_beforeAtIndex:(NSUInteger)idx withObject:(CDYimeiImage *)value;
- (void)replaceYimei_beforeAtIndexes:(NSIndexSet *)indexes withYimei_before:(NSArray<CDYimeiImage *> *)values;
- (void)addYimei_beforeObject:(CDYimeiImage *)value;
- (void)removeYimei_beforeObject:(CDYimeiImage *)value;
- (void)addYimei_before:(NSOrderedSet<CDYimeiImage *> *)values;
- (void)removeYimei_before:(NSOrderedSet<CDYimeiImage *> *)values;

@end

NS_ASSUME_NONNULL_END
