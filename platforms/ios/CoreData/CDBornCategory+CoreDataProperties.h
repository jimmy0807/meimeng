//
//  CDBornCategory+CoreDataProperties.h
//  ds
//
//  Created by lining on 2016/10/21.
//
//

#import "CDBornCategory+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDBornCategory (CoreDataProperties)

+ (NSFetchRequest<CDBornCategory *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *bornCategoryID;
@property (nullable, nonatomic, copy) NSString *bornCategoryName;
@property (nullable, nonatomic, copy) NSNumber *code;
@property (nullable, nonatomic, copy) NSNumber *isActive;
@property (nullable, nonatomic, copy) NSString *lastUpdate;
@property (nullable, nonatomic, copy) NSString *note;
@property (nullable, nonatomic, copy) NSNumber *otherCount;
@property (nullable, nonatomic, copy) NSNumber *sequence;
@property (nullable, nonatomic, copy) NSNumber *totalCount;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSNumber *total_product_qty;

@end

NS_ASSUME_NONNULL_END
