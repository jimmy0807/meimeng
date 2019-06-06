//
//  CDMemberTitle+CoreDataProperties.h
//  Boss
//
//  Created by lining on 16/4/5.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDMemberTitle.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDMemberTitle (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title_name;
@property (nullable, nonatomic, retain) NSString *shortcut;
@property (nullable, nonatomic, retain) NSNumber *title_id;
@property (nullable, nonatomic, retain) NSOrderedSet<CDMember *> *members;

@end

@interface CDMemberTitle (CoreDataGeneratedAccessors)

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

@end

NS_ASSUME_NONNULL_END
