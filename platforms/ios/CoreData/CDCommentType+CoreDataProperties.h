//
//  CDCommentType+CoreDataProperties.h
//  Boss
//
//  Created by lining on 16/4/22.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDCommentType.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDCommentType (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *type_id;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSOrderedSet<CDComment *> *comments;

@end

@interface CDCommentType (CoreDataGeneratedAccessors)

- (void)insertObject:(CDComment *)value inCommentsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCommentsAtIndex:(NSUInteger)idx;
- (void)insertComments:(NSArray<CDComment *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCommentsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCommentsAtIndex:(NSUInteger)idx withObject:(CDComment *)value;
- (void)replaceCommentsAtIndexes:(NSIndexSet *)indexes withComments:(NSArray<CDComment *> *)values;
- (void)addCommentsObject:(CDComment *)value;
- (void)removeCommentsObject:(CDComment *)value;
- (void)addComments:(NSOrderedSet<CDComment *> *)values;
- (void)removeComments:(NSOrderedSet<CDComment *> *)values;

@end

NS_ASSUME_NONNULL_END
