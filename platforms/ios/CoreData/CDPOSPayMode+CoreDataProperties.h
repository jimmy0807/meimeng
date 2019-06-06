//
//  CDPOSPayMode+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 16/12/19.
//
//

#import "CDPOSPayMode+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDPOSPayMode (CoreDataProperties)

+ (NSFetchRequest<CDPOSPayMode *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *incomeAmount;
@property (nullable, nonatomic, copy) NSNumber *mode;
@property (nullable, nonatomic, copy) NSNumber *payID;
@property (nullable, nonatomic, copy) NSString *payName;
@property (nullable, nonatomic, copy) NSString *payType;
@property (nullable, nonatomic, copy) NSNumber *statementID;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSNumber *payment_acquirer_id;
@property (nullable, nonatomic, retain) NSOrderedSet<CDPosOperatePayInfo *> *payInfos;

@end

@interface CDPOSPayMode (CoreDataGeneratedAccessors)

- (void)insertObject:(CDPosOperatePayInfo *)value inPayInfosAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPayInfosAtIndex:(NSUInteger)idx;
- (void)insertPayInfos:(NSArray<CDPosOperatePayInfo *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePayInfosAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPayInfosAtIndex:(NSUInteger)idx withObject:(CDPosOperatePayInfo *)value;
- (void)replacePayInfosAtIndexes:(NSIndexSet *)indexes withPayInfos:(NSArray<CDPosOperatePayInfo *> *)values;
- (void)addPayInfosObject:(CDPosOperatePayInfo *)value;
- (void)removePayInfosObject:(CDPosOperatePayInfo *)value;
- (void)addPayInfos:(NSOrderedSet<CDPosOperatePayInfo *> *)values;
- (void)removePayInfos:(NSOrderedSet<CDPosOperatePayInfo *> *)values;

@end

NS_ASSUME_NONNULL_END
