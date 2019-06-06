//
//  BSCoreDataManager.h
//  Boss
//
//  Created by XiaXianBing on 15/3/27.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BSCoreDataManager : NSObject
{
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (void)setCurrentUserName:(NSString*)userName;
+ (void)performBlockOnWriteQueue:(void(^)())block;

+ (BSCoreDataManager *)currentManager;
- (BOOL)save:(NSError **)error;
- (BOOL)save;
- (void)rollback;
- (id)uniqueEntityForName:(NSString *)name withValue:(id)value forKey:(NSString *)key;
- (id)findEntity:(NSString *)name withValue:(id)value forKey:(NSString *)key;
-(id)findEntity:(NSString *)name withPredicateString2:(NSString*)predicateString;
- (id)findEntity:(NSString *)name withPredicateString:(NSString*)predicateString;
- (id)insertEntity:(NSString *)name;
- (void)deleteObject:(NSManagedObject *)object;
- (void)deleteObjects:(NSArray*)objects;

- (NSArray*)fetchItems:(NSString*)entityName;
- (NSArray*)fetchItems:(NSString*)entityName sortedByKey:(NSString*)key;
- (NSArray*)fetchItems:(NSString*)entityName sortedByKey:(NSString*)key ascending:(BOOL)ascending;
- (NSArray*)fetchItems: (NSString*)entityName sortedByKey: (NSString*)key ascending:(BOOL)ascending predicate:(NSPredicate*)predicate;

@end
