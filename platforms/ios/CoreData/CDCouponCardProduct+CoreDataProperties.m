//
//  CDCouponCardProduct+CoreDataProperties.m
//  ds
//
//  Created by lining on 2016/11/18.
//
//

#import "CDCouponCardProduct+CoreDataProperties.h"

@implementation CDCouponCardProduct (CoreDataProperties)

+ (NSFetchRequest<CDCouponCardProduct *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDCouponCardProduct"];
}

@dynamic couponName;
@dynamic defaultCode;
@dynamic discount;
@dynamic lastUpdate;
@dynamic localCount;
@dynamic productID;
@dynamic productLineID;
@dynamic productName;
@dynamic purchaseQty;
@dynamic remainQty;
@dynamic unitPrice;
@dynamic uomID;
@dynamic uomName;
@dynamic coupon;
@dynamic item;
@dynamic useItem;

@end
