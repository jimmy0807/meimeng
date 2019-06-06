//
//  CDStaffLocalName+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 17/2/15.
//
//

#import "CDStaffLocalName+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDStaffLocalName (CoreDataProperties)

+ (NSFetchRequest<CDStaffLocalName *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *staffID;
@property (nullable, nonatomic, copy) NSString *time;
@property (nullable, nonatomic, copy) NSString *lastUpdate;

@end

NS_ASSUME_NONNULL_END
