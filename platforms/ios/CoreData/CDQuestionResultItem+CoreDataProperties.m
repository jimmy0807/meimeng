//
//  CDQuestionResultItem+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/6/14.
//
//

#import "CDQuestionResultItem+CoreDataProperties.h"

@implementation CDQuestionResultItem (CoreDataProperties)

+ (NSFetchRequest<CDQuestionResultItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDQuestionResultItem"];
}

@dynamic name;
@dynamic itemID;
@dynamic question;

@end
