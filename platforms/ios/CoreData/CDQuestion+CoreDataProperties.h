//
//  CDQuestion+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2017/6/23.
//
//

#import "CDQuestion+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDQuestion (CoreDataProperties)

+ (NSFetchRequest<CDQuestion *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *is_first;
@property (nullable, nonatomic, copy) NSNumber *no_question_id;
@property (nullable, nonatomic, copy) NSNumber *no_result_id;
@property (nullable, nonatomic, copy) NSString *question;
@property (nullable, nonatomic, copy) NSNumber *question_id;
@property (nullable, nonatomic, copy) NSString *question_no;
@property (nullable, nonatomic, copy) NSNumber *yes_question_id;
@property (nullable, nonatomic, copy) NSNumber *yes_result_id;
@property (nullable, nonatomic, copy) NSNumber *result;

@end

NS_ASSUME_NONNULL_END
