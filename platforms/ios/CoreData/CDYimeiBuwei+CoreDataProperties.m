//
//  CDYimeiBuwei+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/6/8.
//
//

#import "CDYimeiBuwei+CoreDataProperties.h"

@implementation CDYimeiBuwei (CoreDataProperties)

+ (NSFetchRequest<CDYimeiBuwei *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDYimeiBuwei"];
}

@dynamic buwei_id;
@dynamic count;
@dynamic name;
@dynamic type;
@dynamic projectItem;
@dynamic userItem;
@dynamic zixun;

@end
