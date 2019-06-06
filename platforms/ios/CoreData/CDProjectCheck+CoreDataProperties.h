//
//  CDProjectCheck+CoreDataProperties.h
//  meim
//
//  Created by 波恩公司 on 2018/4/24.
//
//

#import "CDProjectCheck+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDProjectCheck (CoreDataProperties)

+ (NSFetchRequest<CDProjectCheck *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *checkID;
@property (nullable, nonatomic, copy) NSNumber *productID;
@property (nullable, nonatomic, copy) NSNumber *qty;

@end

NS_ASSUME_NONNULL_END
