//
//  CDYimeiHistoryBuyItem+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/6/29.
//
//

#import "CDYimeiHistoryBuyItem+CoreDataProperties.h"

@implementation CDYimeiHistoryBuyItem (CoreDataProperties)

+ (NSFetchRequest<CDYimeiHistoryBuyItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDYimeiHistoryBuyItem"];
}

@dynamic name_template;
@dynamic itemID;
@dynamic price_unit;
@dynamic qty;
@dynamic history;

@end
