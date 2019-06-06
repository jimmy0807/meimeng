//
//  CDMessageRecord+CoreDataProperties.m
//  meim
//
//  Created by lining on 2016/11/30.
//
//

#import "CDMessageRecord+CoreDataProperties.h"

@implementation CDMessageRecord (CoreDataProperties)

+ (NSFetchRequest<CDMessageRecord *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDMessageRecord"];
}

@dynamic send_no;
@dynamic phones;
@dynamic send_date;
@dynamic template_content;
@dynamic born_uuid;
@dynamic shop_uuid;
@dynamic company_uuid;

@end
