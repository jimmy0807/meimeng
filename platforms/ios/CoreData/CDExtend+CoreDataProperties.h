//
//  CDExtend+CoreDataProperties.h
//  Boss
//
//  Created by lining on 16/4/26.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDExtend.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDExtend (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *extend_description;
@property (nullable, nonatomic, retain) NSNumber *extend_id;
@property (nullable, nonatomic, retain) NSString *extend_name;
@property (nullable, nonatomic, retain) NSOrderedSet<CDMemberTeZheng *> *tezhengs;

@end

@interface CDExtend (CoreDataGeneratedAccessors)

- (void)insertObject:(CDMemberTeZheng *)value inTezhengsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTezhengsAtIndex:(NSUInteger)idx;
- (void)insertTezhengs:(NSArray<CDMemberTeZheng *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTezhengsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTezhengsAtIndex:(NSUInteger)idx withObject:(CDMemberTeZheng *)value;
- (void)replaceTezhengsAtIndexes:(NSIndexSet *)indexes withTezhengs:(NSArray<CDMemberTeZheng *> *)values;
- (void)addTezhengsObject:(CDMemberTeZheng *)value;
- (void)removeTezhengsObject:(CDMemberTeZheng *)value;
- (void)addTezhengs:(NSOrderedSet<CDMemberTeZheng *> *)values;
- (void)removeTezhengs:(NSOrderedSet<CDMemberTeZheng *> *)values;

@end

NS_ASSUME_NONNULL_END
