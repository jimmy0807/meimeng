//
//  CDHGuadanProduct+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2017/7/26.
//
//

#import "CDHGuadanProduct+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDHGuadanProduct (CoreDataProperties)

+ (NSFetchRequest<CDHGuadanProduct *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *itemID;
@property (nullable, nonatomic, copy) NSNumber *line_id;
@property (nullable, nonatomic, copy) NSNumber *pad_order_id;
@property (nullable, nonatomic, copy) NSNumber *product_id;
@property (nullable, nonatomic, copy) NSNumber *qty;
@property (nullable, nonatomic, retain) CDHGuadan *card_item;
@property (nullable, nonatomic, retain) CDHGuadan *item;

@end

NS_ASSUME_NONNULL_END
