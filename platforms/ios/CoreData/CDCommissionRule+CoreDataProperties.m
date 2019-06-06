//
//  CDCommissionRule+CoreDataProperties.m
//  ds
//
//  Created by lining on 16/10/12.
//
//

#import "CDCommissionRule+CoreDataProperties.h"

@implementation CDCommissionRule (CoreDataProperties)

+ (NSFetchRequest<CDCommissionRule *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDCommissionRule"];
}

@dynamic rule_name;
@dynamic rule_id;
@dynamic sale_price_sel;
@dynamic shop_id;
@dynamic shop_name;
@dynamic company_id;
@dynamic company_name;
@dynamic staffs;

@end
