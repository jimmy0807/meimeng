//
//  CDMemberVisit+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/5/3.
//
//

#import "CDMemberVisit+CoreDataProperties.h"

@implementation CDMemberVisit (CoreDataProperties)

+ (NSFetchRequest<CDMemberVisit *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDMemberVisit"];
}

@dynamic advisory_id;
@dynamic advisory_name;
@dynamic category;
@dynamic create_date;
@dynamic customer_id;
@dynamic customer_name;
@dynamic day;
@dynamic lastUpdate;
@dynamic member_id;
@dynamic member_name;
@dynamic name;
@dynamic nameFirstLetter;
@dynamic nameLetter;
@dynamic note;
@dynamic operate_id;
@dynamic operate_name;
@dynamic plant_visit_date;
@dynamic plant_visit_user_id;
@dynamic plant_visit_user_name;
@dynamic sortIndex;
@dynamic state;
@dynamic visit_id;
@dynamic visit_user_id;
@dynamic visit_user_name;
@dynamic product_names;
@dynamic visit_date;
@dynamic photos;

@end
