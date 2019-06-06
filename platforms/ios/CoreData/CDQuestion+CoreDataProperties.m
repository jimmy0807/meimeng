//
//  CDQuestion+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/6/23.
//
//

#import "CDQuestion+CoreDataProperties.h"

@implementation CDQuestion (CoreDataProperties)

+ (NSFetchRequest<CDQuestion *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDQuestion"];
}

@dynamic is_first;
@dynamic no_question_id;
@dynamic no_result_id;
@dynamic question;
@dynamic question_id;
@dynamic question_no;
@dynamic yes_question_id;
@dynamic yes_result_id;
@dynamic result;

@end
