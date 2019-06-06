//
//  CDHZixun+CoreDataProperties.m
//  meim
//
//  Created by bonn on 2017/4/27.
//
//

#import "CDHZixun+CoreDataProperties.h"

@implementation CDHZixun (CoreDataProperties)

+ (NSFetchRequest<CDHZixun *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDHZixun"];
}

@dynamic advice;
@dynamic advisory_product_names;
@dynamic cagegory_id;
@dynamic category_name;
@dynamic condition;
@dynamic customer_id;
@dynamic customer_name;
@dynamic designers_id;
@dynamic designers_name;
@dynamic doctor_id;
@dynamic doctor_name;
@dynamic employee_id;
@dynamic employee_name;
@dynamic lastUpdate;
@dynamic name;
@dynamic nameFirstLetter;
@dynamic nameLetter;
@dynamic nameSingleLetter;
@dynamic storeID;
@dynamic time;
@dynamic zixun_id;
@dynamic mobile;
@dynamic gender;

@end
