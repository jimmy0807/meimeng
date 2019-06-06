//
//  CDMemberSource+CoreDataProperties.h
//  ds
//
//  Created by jimmy on 16/10/13.
//
//

#import "CDMemberSource+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDMemberSource (CoreDataProperties)

+ (NSFetchRequest<CDMemberSource *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *source_id;

@end

NS_ASSUME_NONNULL_END
