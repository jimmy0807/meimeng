//
//  CDProjectConsumable+CoreDataProperties.m
//  meim
//
//  Created by 波恩公司 on 2018/4/23.
//
//

#import "CDProjectConsumable+CoreDataProperties.h"

@implementation CDProjectConsumable (CoreDataProperties)

+ (NSFetchRequest<CDProjectConsumable *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDProjectConsumable"];
}

@dynamic amount;
@dynamic baseProductID;
@dynamic baseProductName;
@dynamic consumableID;
@dynamic createDate;
@dynamic isStock;
@dynamic lastUpdate;
@dynamic productID;
@dynamic productName;
@dynamic qty;
@dynamic uomID;
@dynamic uomName;
@dynamic projectItems;
@dynamic projectItem;

@end
