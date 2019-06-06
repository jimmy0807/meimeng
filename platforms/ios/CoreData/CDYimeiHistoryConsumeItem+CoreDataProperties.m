//
//  CDYimeiHistoryConsumeItem+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/6/29.
//
//

#import "CDYimeiHistoryConsumeItem+CoreDataProperties.h"

@implementation CDYimeiHistoryConsumeItem (CoreDataProperties)

+ (NSFetchRequest<CDYimeiHistoryConsumeItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDYimeiHistoryConsumeItem"];
}

@dynamic qty;
@dynamic itemID;
@dynamic name_template;
@dynamic history;

@end
