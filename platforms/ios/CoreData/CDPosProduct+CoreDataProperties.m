//
//  CDPosProduct+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/8/21.
//
//

#import "CDPosProduct+CoreDataProperties.h"

@implementation CDPosProduct (CoreDataProperties)

+ (NSFetchRequest<CDPosProduct *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDPosProduct"];
}

@dynamic category_id;
@dynamic category_name;
@dynamic consume_product_names;
@dynamic defaultCode;
@dynamic imageName;
@dynamic imageSmallUrl;
@dynamic imageUrl;
@dynamic name;
@dynamic payment_ids;
@dynamic type_id;
@dynamic type_name;
@dynamic change_qty;
@dynamic book;

@end
