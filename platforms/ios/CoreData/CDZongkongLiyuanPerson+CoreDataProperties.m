//
//  CDZongkongLiyuanPerson+CoreDataProperties.m
//  meim
//
//  Created by 宋海斌 on 2017/6/22.
//
//

#import "CDZongkongLiyuanPerson+CoreDataProperties.h"

@implementation CDZongkongLiyuanPerson (CoreDataProperties)

+ (NSFetchRequest<CDZongkongLiyuanPerson *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDZongkongLiyuanPerson"];
}

@dynamic sort_index;
@dynamic name;
@dynamic billed_time;
@dynamic leave_time;
@dynamic time;
@dynamic image_url;
@dynamic mobile;
@dynamic member_type;
@dynamic item;

@end
