//
//  CDQuestionResult+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/6/14.
//
//

#import "CDQuestionResult+CoreDataProperties.h"

@implementation CDQuestionResult (CoreDataProperties)

+ (NSFetchRequest<CDQuestionResult *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDQuestionResult"];
}

@dynamic company_id;
@dynamic name;
@dynamic recommend;
@dynamic result_id;
@dynamic items;

@end
