//
//  CDCurrentUseItem+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 17/3/14.
//
//

#import "CDCurrentUseItem+CoreDataProperties.h"

@implementation CDCurrentUseItem (CoreDataProperties)

+ (NSFetchRequest<CDCurrentUseItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDCurrentUseItem"];
}

@dynamic defaultCode;
@dynamic itemID;
@dynamic itemName;
@dynamic totalCount;
@dynamic type;
@dynamic uomName;
@dynamic useCount;
@dynamic parent_id;
@dynamic book;
@dynamic cardProject;
@dynamic couponProject;
@dynamic posOperate;
@dynamic projectItem;
@dynamic yimei_buwei;

@end
