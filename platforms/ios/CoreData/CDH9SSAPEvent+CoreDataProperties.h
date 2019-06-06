//
//  CDH9SSAPEvent+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2017/8/14.
//
//

#import "CDH9SSAPEvent+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDH9SSAPEvent (CoreDataProperties)

+ (NSFetchRequest<CDH9SSAPEvent *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *member_id;
@property (nullable, nonatomic, copy) NSString *note;
@property (nullable, nonatomic, copy) NSNumber *operate_id;
@property (nullable, nonatomic, copy) NSNumber *operate_line_id;
@property (nullable, nonatomic, copy) NSString *operate_time;
@property (nullable, nonatomic, copy) NSNumber *product_id;
@property (nullable, nonatomic, copy) NSString *product_name;
@property (nullable, nonatomic, copy) NSNumber *sort_index;
@property (nullable, nonatomic, copy) NSString *year_month_day;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSString *state_name;
@property (nullable, nonatomic, retain) CDH9SSAP *ssap;

@end

NS_ASSUME_NONNULL_END
