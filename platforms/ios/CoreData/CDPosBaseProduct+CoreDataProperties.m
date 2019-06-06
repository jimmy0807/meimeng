//
//  CDPosBaseProduct+CoreDataProperties.m
//  meim
//
//  Created by 波恩公司 on 2017/11/13.
//
//

#import "CDPosBaseProduct+CoreDataProperties.h"

@implementation CDPosBaseProduct (CoreDataProperties)

+ (NSFetchRequest<CDPosBaseProduct *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDPosBaseProduct"];
}

@dynamic buy_price;
@dynamic company_id;
@dynamic company_name;
@dynamic lastUpdate;
@dynamic line_id;
@dynamic money_total;
@dynamic operate_id;
@dynamic operate_name;
@dynamic part_display_name;
@dynamic pay_id;
@dynamic pay_type;
@dynamic product_discount;
@dynamic product_id;
@dynamic product_name;
@dynamic product_price;
@dynamic product_qty;
@dynamic qty;
@dynamic shop_id;
@dynamic shop_name;
@dynamic state;
@dynamic coupon_deduction;
@dynamic coupon_id;
@dynamic point_deduction;
@dynamic operate;
@dynamic product;
@dynamic yimei_buwei;

@end
