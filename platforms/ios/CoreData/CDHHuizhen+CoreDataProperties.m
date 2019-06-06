//
//  CDHHuizhen+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/7/25.
//
//

#import "CDHHuizhen+CoreDataProperties.h"

@implementation CDHHuizhen (CoreDataProperties)

+ (NSFetchRequest<CDHHuizhen *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDHHuizhen"];
}

@dynamic create_date;
@dynamic doctor_url;
@dynamic doctors_id;
@dynamic doctors_name;
@dynamic doctors_note;
@dynamic first_category_id;
@dynamic first_category_name;
@dynamic huizhen_id;
@dynamic lastUpdate;
@dynamic name;
@dynamic reason;
@dynamic second_category_ids;
@dynamic second_category_name;
@dynamic title_detail;
@dynamic picUrls;
@dynamic description_str;
@dynamic source;
@dynamic binglika;
@dynamic photos;

@end
