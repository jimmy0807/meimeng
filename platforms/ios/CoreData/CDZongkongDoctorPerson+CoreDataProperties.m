//
//  CDZongkongDoctorPerson+CoreDataProperties.m
//  meim
//
//  Created by 波恩公司 on 2017/10/10.
//
//

#import "CDZongkongDoctorPerson+CoreDataProperties.h"

@implementation CDZongkongDoctorPerson (CoreDataProperties)

+ (NSFetchRequest<CDZongkongDoctorPerson *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDZongkongDoctorPerson"];
}

@dynamic designer_name;
@dynamic doctor_id;
@dynamic doing_cnt;
@dynamic done_cnt;
@dynamic image_url;
@dynamic member_name;
@dynamic name;
@dynamic sort_index;
@dynamic start_date;
@dynamic state_name;
@dynamic waiting_cnt;
@dynamic waiting_name;
@dynamic current_customers;
@dynamic paidui_customers;

@end
