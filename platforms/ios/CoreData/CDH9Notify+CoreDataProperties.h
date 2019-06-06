//
//  CDH9Notify+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2017/8/4.
//
//

#import "CDH9Notify+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDH9Notify (CoreDataProperties)

+ (NSFetchRequest<CDH9Notify *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *sort_index;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *user_id;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSString *state_name;
@property (nullable, nonatomic, copy) NSString *planning_time;
@property (nullable, nonatomic, copy) NSNumber *member_id;
@property (nullable, nonatomic, copy) NSNumber *doctor_id;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSNumber *notify_id;

@end

NS_ASSUME_NONNULL_END
