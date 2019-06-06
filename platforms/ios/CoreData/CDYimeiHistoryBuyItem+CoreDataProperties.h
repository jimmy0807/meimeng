//
//  CDYimeiHistoryBuyItem+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2017/6/29.
//
//

#import "CDYimeiHistoryBuyItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDYimeiHistoryBuyItem (CoreDataProperties)

+ (NSFetchRequest<CDYimeiHistoryBuyItem *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name_template;
@property (nullable, nonatomic, copy) NSNumber *itemID;
@property (nullable, nonatomic, copy) NSString *price_unit;
@property (nullable, nonatomic, copy) NSNumber *qty;
@property (nullable, nonatomic, retain) CDYimeiHistory *history;

@end

NS_ASSUME_NONNULL_END
