//
//  CDHFetchResult+CoreDataProperties.h
//  meim
//
//  Created by 波恩公司 on 2017/9/25.
//
//

#import "CDHFetchResult+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDHFetchResult (CoreDataProperties)

+ (NSFetchRequest<CDHFetchResult *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *doctor_name;
@property (nullable, nonatomic, copy) NSString *note;
@property (nullable, nonatomic, copy) NSString *operate_date;
@property (nullable, nonatomic, copy) NSString *operate_name;
@property (nullable, nonatomic, copy) NSNumber *shoushu_id;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSString *state_name;

@end

NS_ASSUME_NONNULL_END
