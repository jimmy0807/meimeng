//
//  CDHGuadanProduct+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/7/26.
//
//

#import "CDHGuadanProduct+CoreDataProperties.h"

@implementation CDHGuadanProduct (CoreDataProperties)

+ (NSFetchRequest<CDHGuadanProduct *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDHGuadanProduct"];
}

@dynamic itemID;
@dynamic line_id;
@dynamic pad_order_id;
@dynamic product_id;
@dynamic qty;
@dynamic card_item;
@dynamic item;

@end
