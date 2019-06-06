//
//  CDComment+CoreDataProperties.h
//  Boss
//
//  Created by lining on 16/5/6.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDComment.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDComment (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *comment_id;
@property (nullable, nonatomic, retain) NSString *comment_mark;
@property (nullable, nonatomic, retain) NSString *comment_type;
@property (nullable, nonatomic, retain) NSString *date;
@property (nullable, nonatomic, retain) NSNumber *member_id;
@property (nullable, nonatomic, retain) NSString *member_name;
@property (nullable, nonatomic, retain) NSNumber *operate_id;
@property (nullable, nonatomic, retain) NSString *operate_name;
@property (nullable, nonatomic, retain) NSNumber *score;
@property (nullable, nonatomic, retain) NSNumber *shop_id;
@property (nullable, nonatomic, retain) NSString *shop_name;
@property (nullable, nonatomic, retain) NSString *operate_type;
@property (nullable, nonatomic, retain) NSOrderedSet<CDCommentType *> *commentTypes;

@end

@interface CDComment (CoreDataGeneratedAccessors)

- (void)insertObject:(CDCommentType *)value inCommentTypesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCommentTypesAtIndex:(NSUInteger)idx;
- (void)insertCommentTypes:(NSArray<CDCommentType *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCommentTypesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCommentTypesAtIndex:(NSUInteger)idx withObject:(CDCommentType *)value;
- (void)replaceCommentTypesAtIndexes:(NSIndexSet *)indexes withCommentTypes:(NSArray<CDCommentType *> *)values;
- (void)addCommentTypesObject:(CDCommentType *)value;
- (void)removeCommentTypesObject:(CDCommentType *)value;
- (void)addCommentTypes:(NSOrderedSet<CDCommentType *> *)values;
- (void)removeCommentTypes:(NSOrderedSet<CDCommentType *> *)values;

@end

NS_ASSUME_NONNULL_END
