//
//  BSCoreDataManager.m
//  Boss
//
//  Created by XiaXianBing on 15/3/27.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSCoreDataManager.h"

#define coreDataKey  @"BSCoreDataManager"

static NSString* currentUserName = nil;
static dispatch_queue_t writeDispatch_queue;

@interface BSCoreDataManager ()
@property(nonatomic, strong) NSString* currentUser;
@end

@implementation BSCoreDataManager

@synthesize managedObjectContext = managedObjectContext_;
@synthesize managedObjectModel = managedObjectModel_;
@synthesize persistentStoreCoordinator = persistentStoreCoordinator_;

-(id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self.managedObjectContext];
    [managedObjectContext_ release];
    [managedObjectModel_ release];
    [persistentStoreCoordinator_ release];
    [super dealloc];
}

+ (void)setCurrentUserName:(NSString*)userName
{
    if ( currentUserName )
    {
        [currentUserName release];
    }
    
    currentUserName = [userName retain];
    [BSCoreDataManager currentManager];
}

+(BSCoreDataManager*)createForOtherThread
{
    BSCoreDataManager* cdMgr = [[[BSCoreDataManager alloc]init] autorelease];
    BSCoreDataManager* mainThreadcdMgr = [[[NSThread mainThread] threadDictionary] objectForKey:coreDataKey];
    cdMgr.managedObjectModel  = mainThreadcdMgr.managedObjectModel;
    cdMgr.persistentStoreCoordinator = mainThreadcdMgr.persistentStoreCoordinator ;
    cdMgr.managedObjectContext = [[[NSManagedObjectContext alloc] init] autorelease];
    cdMgr.currentUser = mainThreadcdMgr.currentUser;
    [cdMgr.managedObjectContext setPersistentStoreCoordinator:cdMgr.persistentStoreCoordinator];
    return cdMgr;
}

+(BSCoreDataManager*)currentManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        writeDispatch_queue = dispatch_queue_create("cd_write", NULL);
    });
    
    NSMutableDictionary* threadDict = [[NSThread currentThread] threadDictionary];
    BSCoreDataManager* cdm = [threadDict objectForKey: coreDataKey];
    if ( currentUserName == nil )
    {
        currentUserName = @"Boss";
    }
    
    if ( cdm && ![cdm.currentUser isEqualToString:currentUserName] )
    {
        cdm  = nil;
        [threadDict removeObjectForKey: coreDataKey];
    }
    
    if (cdm == nil)
    {
        if ([[NSThread currentThread] isMainThread])
        {
            cdm = [[BSCoreDataManager alloc]init];
            [[NSNotificationCenter defaultCenter] addObserver: cdm.managedObjectContext selector: @selector(mergeChangesFromContextDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object: nil];
            [cdm.managedObjectContext setMergePolicy: NSMergeByPropertyObjectTrumpMergePolicy];
        }
        else
        {
            cdm = [[BSCoreDataManager createForOtherThread] retain];
        }
        cdm.currentUser = currentUserName;
        [threadDict setObject: cdm forKey: coreDataKey];
        [cdm release];
    }
    return cdm;
}
    
- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"Boss" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel_;
}

- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    
    NSString* storeFile = [NSString stringWithFormat: @"%@.sqlite", currentUserName];
    NSURL *storeURL = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent:storeFile]];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        // persistentStore maybe old version, so we have to delete it first
        [[NSFileManager defaultManager] removeItemAtURL: storeURL error: nil];
        if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    return persistentStoreCoordinator_;
}

- (BOOL)save:(NSError **)error
{
    return [self.managedObjectContext save: error];
}

- (BOOL)save
{
    return [self.managedObjectContext save: nil];
}

- (void)rollback
{
    return [self.managedObjectContext rollback];
}

-(void)deleteObject:(NSManagedObject *)object
{
    if ( object )
    {
        [self.managedObjectContext deleteObject: object];
    }
}

-(void)deleteObjects:(NSArray*)objects
{
    for (NSManagedObject* object in objects)
    {
        [self deleteObject: object];
    }
}

-(id)insertEntity:(NSString *)name
{
    id entity = [NSEntityDescription insertNewObjectForEntityForName: name inManagedObjectContext:self.managedObjectContext];
    return entity;
}

-(id)findEntity:(NSString *)name withValue:(id)value forKey:(NSString *)key
{
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    request.entity = [NSEntityDescription entityForName: name inManagedObjectContext: self.managedObjectContext];
    request.predicate = [NSPredicate predicateWithFormat:[key stringByAppendingString:@" == %@"], value];
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:nil];
    return [result lastObject];
}

-(id)findEntity:(NSString *)name withPredicateString2:(NSString*)predicateString
{
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    request.entity = [NSEntityDescription entityForName: name inManagedObjectContext: self.managedObjectContext];
    
    request.predicate = [NSPredicate predicateWithFormat:predicateString];
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    return result;
}

-(id)findEntity:(NSString *)name withPredicateString:(NSString*)predicateString
{
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    request.entity = [NSEntityDescription entityForName: name inManagedObjectContext: self.managedObjectContext];
    
    request.predicate = [NSPredicate predicateWithFormat:predicateString];
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    return [result lastObject];
}

-(id)uniqueEntityForName:(NSString *)name withValue:(id)value forKey:(NSString *)key
{
    id entity = [self findEntity: name withValue: value forKey: key];
    
    if (entity == nil)
    {
        entity = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext: self.managedObjectContext];
        [entity setValue:value forKey:key];
    }
    
    return entity;
}

- (NSArray*)fetchItems:(NSString*)entityName
{
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName: entityName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return array;
}

- (NSArray*)fetchItems:(NSString*)entityName sortedByKey:(NSString*)key
{
    return [self fetchItems:entityName sortedByKey:key ascending:YES];
}

- (NSArray*)fetchItems:(NSString*)entityName sortedByKey:(NSString*)key ascending:(BOOL)ascending
{
    return [self fetchItems:entityName sortedByKey:key ascending:ascending predicate:nil];
}

- (NSArray*)fetchItems: (NSString*)entityName sortedByKey: (NSString*)key ascending:(BOOL)ascending predicate:(NSPredicate*)predicate
{
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName: entityName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending];
    [fetchRequest setSortDescriptors: @[des]];
    if ( predicate )
    {
        [fetchRequest setPredicate: predicate];
    }
    
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return array;
}

+ (void)performBlockOnWriteQueue:(void(^)())block
{
    dispatch_async(writeDispatch_queue, block);
}

@end
