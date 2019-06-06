//
//  CDPosProduct+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2017/8/21.
//
//

#import "CDPosProduct+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDPosProduct (CoreDataProperties)

+ (NSFetchRequest<CDPosProduct *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *category_id;
@property (nullable, nonatomic, copy) NSString *category_name;
@property (nullable, nonatomic, copy) NSString *consume_product_names;
@property (nullable, nonatomic, copy) NSString *defaultCode;
@property (nullable, nonatomic, copy) NSString *imageName;
@property (nullable, nonatomic, copy) NSString *imageSmallUrl;
@property (nullable, nonatomic, copy) NSString *imageUrl;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *payment_ids;
@property (nullable, nonatomic, copy) NSNumber *type_id;
@property (nullable, nonatomic, copy) NSString *type_name;
@property (nullable, nonatomic, copy) NSNumber *change_qty;
@property (nullable, nonatomic, retain) CDBook *book;

@end

NS_ASSUME_NONNULL_END
