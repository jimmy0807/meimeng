//
//  CDWorkFlowActivity+CoreDataProperties.h
//  ds
//
//  Created by jimmy on 16/10/28.
//
//

#import "CDWorkFlowActivity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDWorkFlowActivity (CoreDataProperties)

+ (NSFetchRequest<CDWorkFlowActivity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *parentID;
@property (nullable, nonatomic, copy) NSNumber *isStart;
@property (nullable, nonatomic, copy) NSNumber *isEnd;
@property (nullable, nonatomic, copy) NSNumber *role;
@property (nullable, nonatomic, copy) NSNumber *workID;

@end

NS_ASSUME_NONNULL_END
