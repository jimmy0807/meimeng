//
//  CDPartner+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/5/4.
//
//

#import "CDPartner+CoreDataProperties.h"

@implementation CDPartner (CoreDataProperties)

+ (NSFetchRequest<CDPartner *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDPartner"];
}

@dynamic business_employee_id;
@dynamic business_employee_name;
@dynamic designer_employee_id;
@dynamic designer_employee_name;
@dynamic lastUpdate;
@dynamic name;
@dynamic nameFirstLetter;
@dynamic nameLetter;
@dynamic nameSingleLetter;
@dynamic partner_category;
@dynamic partner_id;
@dynamic street;
@dynamic sign_date;
@dynamic mobile;
@dynamic identification;
@dynamic photos;

@end
