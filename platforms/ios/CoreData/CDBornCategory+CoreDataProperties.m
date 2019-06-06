//
//  CDBornCategory+CoreDataProperties.m
//  ds
//
//  Created by lining on 2016/10/21.
//
//

#import "CDBornCategory+CoreDataProperties.h"

@implementation CDBornCategory (CoreDataProperties)

+ (NSFetchRequest<CDBornCategory *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDBornCategory"];
}

@dynamic bornCategoryID;
@dynamic bornCategoryName;
@dynamic code;
@dynamic isActive;
@dynamic lastUpdate;
@dynamic note;
@dynamic otherCount;
@dynamic sequence;
@dynamic totalCount;
@dynamic type;
@dynamic total_product_qty;

@end
