//
//  CDHJiaoHao+CoreDataProperties.h
//  meim
//
//  Created by 波恩公司 on 2018/5/3.
//
//

#import "CDHJiaoHao+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDHJiaoHao (CoreDataProperties)

+ (NSFetchRequest<CDHJiaoHao *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *advisory_product_names;
@property (nullable, nonatomic, copy) NSNumber *create_uid;
@property (nullable, nonatomic, copy) NSNumber *current_workflow_activity_id;
@property (nullable, nonatomic, copy) NSNumber *customer_id;
@property (nullable, nonatomic, copy) NSString *customer_name;
@property (nullable, nonatomic, copy) NSNumber *departments_id;
@property (nullable, nonatomic, copy) NSNumber *doctor_id;
@property (nullable, nonatomic, copy) NSString *doctor_name;
@property (nullable, nonatomic, copy) NSNumber *is_print;
@property (nullable, nonatomic, copy) NSNumber *is_update;
@property (nullable, nonatomic, copy) NSNumber *jiaohao_id;
@property (nullable, nonatomic, copy) NSString *jump_name;
@property (nullable, nonatomic, copy) NSNumber *keshi_id;
@property (nullable, nonatomic, copy) NSString *keshi_name;
@property (nullable, nonatomic, copy) NSString *member_type;
@property (nullable, nonatomic, copy) NSString *memberNameFirstLetter;
@property (nullable, nonatomic, copy) NSString *memberNameLetter;
@property (nullable, nonatomic, copy) NSString *operate_employee_ids;
@property (nullable, nonatomic, copy) NSString *print_url;
@property (nullable, nonatomic, copy) NSString *progre_status;
@property (nullable, nonatomic, copy) NSString *queue;
@property (nullable, nonatomic, copy) NSString *queue_no;
@property (nullable, nonatomic, copy) NSNumber *sort_index;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSNumber *willCancel;
@property (nullable, nonatomic, copy) NSNumber *peitai_nurse_id;
@property (nullable, nonatomic, copy) NSString *peitai_nurse_name;
@property (nullable, nonatomic, copy) NSNumber *xunhui_nurse_id;
@property (nullable, nonatomic, copy) NSString *xunhui_nurse_name;
@property (nullable, nonatomic, copy) NSNumber *anesthetist_id;
@property (nullable, nonatomic, copy) NSString *anesthetist_name;
@property (nullable, nonatomic, retain) NSOrderedSet<CDHJiaoHaoWorkflow *> *flow;

@end

@interface CDHJiaoHao (CoreDataGeneratedAccessors)

- (void)insertObject:(CDHJiaoHaoWorkflow *)value inFlowAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFlowAtIndex:(NSUInteger)idx;
- (void)insertFlow:(NSArray<CDHJiaoHaoWorkflow *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFlowAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFlowAtIndex:(NSUInteger)idx withObject:(CDHJiaoHaoWorkflow *)value;
- (void)replaceFlowAtIndexes:(NSIndexSet *)indexes withFlow:(NSArray<CDHJiaoHaoWorkflow *> *)values;
- (void)addFlowObject:(CDHJiaoHaoWorkflow *)value;
- (void)removeFlowObject:(CDHJiaoHaoWorkflow *)value;
- (void)addFlow:(NSOrderedSet<CDHJiaoHaoWorkflow *> *)values;
- (void)removeFlow:(NSOrderedSet<CDHJiaoHaoWorkflow *> *)values;

@end

NS_ASSUME_NONNULL_END
