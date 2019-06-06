//
//  CDHBinglika+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/5/9.
//
//

#import "CDHBinglika+CoreDataProperties.h"

@implementation CDHBinglika (CoreDataProperties)

+ (NSFetchRequest<CDHBinglika *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDHBinglika"];
}

@dynamic binglika_id;
@dynamic create_date;
@dynamic first_treat_date;
@dynamic lastUpdate;
@dynamic member_id;
@dynamic member_name;
@dynamic mobile;
@dynamic name;
@dynamic doctor_name;
@dynamic doctor_id;
@dynamic huizhen;
@dynamic shoushu;

@end
