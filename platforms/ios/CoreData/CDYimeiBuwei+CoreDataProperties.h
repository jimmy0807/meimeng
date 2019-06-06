//
//  CDYimeiBuwei+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2017/6/8.
//
//

#import "CDYimeiBuwei+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDYimeiBuwei (CoreDataProperties)

+ (NSFetchRequest<CDYimeiBuwei *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *buwei_id;
@property (nullable, nonatomic, copy) NSNumber *count;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, retain) CDPosBaseProduct *projectItem;
@property (nullable, nonatomic, retain) CDCurrentUseItem *userItem;
@property (nullable, nonatomic, retain) CDZixun *zixun;

@end

NS_ASSUME_NONNULL_END
