//
//  CDHShoushuLine+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/8/23.
//
//

#import "CDHShoushuLine+CoreDataProperties.h"

@implementation CDHShoushuLine (CoreDataProperties)

+ (NSFetchRequest<CDHShoushuLine *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDHShoushuLine"];
}

@dynamic create_date;
@dynamic doctor_id;
@dynamic doctor_name;
@dynamic has_confirm;
@dynamic hospitalized_id;
@dynamic hospitalized_name;
@dynamic lastUpdate;
@dynamic line_id;
@dynamic medical_operate_id;
@dynamic medical_operate_name;
@dynamic name;
@dynamic note;
@dynamic operate_date;
@dynamic operate_tags;
@dynamic product_id;
@dynamic product_name;
@dynamic review_date;
@dynamic review_days;
@dynamic sortIndex;
@dynamic state;
@dynamic write_name;
@dynamic write_uid;
@dynamic operate_tags_names;
@dynamic shoushu;

@end
