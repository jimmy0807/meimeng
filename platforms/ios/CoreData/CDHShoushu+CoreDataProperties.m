//
//  CDHShoushu+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/5/10.
//
//

#import "CDHShoushu+CoreDataProperties.h"

@implementation CDHShoushu (CoreDataProperties)

+ (NSFetchRequest<CDHShoushu *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDHShoushu"];
}

@dynamic create_date;
@dynamic doctor_id;
@dynamic doctor_name;
@dynamic expander_in_date;
@dynamic expander_review_1;
@dynamic expander_review_2;
@dynamic expander_review_3;
@dynamic expander_review_days_1;
@dynamic expander_review_days_2;
@dynamic expander_review_days_3;
@dynamic first_treat_date;
@dynamic lastUpdate;
@dynamic member_id;
@dynamic member_name;
@dynamic name;
@dynamic note;
@dynamic shoushu_id;
@dynamic binglika;
@dynamic items;

@end
