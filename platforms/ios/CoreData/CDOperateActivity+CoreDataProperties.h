//
//  CDOperateActivity+CoreDataProperties.h
//  ds
//
//  Created by jimmy on 16/11/10.
//
//

#import "CDOperateActivity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDOperateActivity (CoreDataProperties)

+ (NSFetchRequest<CDOperateActivity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *activityID;
@property (nullable, nonatomic, copy) NSNumber *lineID;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *role;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSString *time;
@property (nullable, nonatomic, copy) NSString *userName;
@property (nullable, nonatomic, retain) CDPosOperate *operate;

@end

NS_ASSUME_NONNULL_END
