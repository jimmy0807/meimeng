//
//  CDH9ShoushuTag+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2017/8/22.
//
//

#import "CDH9ShoushuTag+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDH9ShoushuTag (CoreDataProperties)

+ (NSFetchRequest<CDH9ShoushuTag *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *sort_index;
@property (nullable, nonatomic, copy) NSNumber *tag_id;
@property (nullable, nonatomic, copy) NSString *memberNameLetter;
@property (nullable, nonatomic, copy) NSString *memberNameFirstLetter;

@end

NS_ASSUME_NONNULL_END
