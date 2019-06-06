//
//  CDMedicalItem+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/7/17.
//
//

#import "CDMedicalItem+CoreDataProperties.h"

@implementation CDMedicalItem (CoreDataProperties)

+ (NSFetchRequest<CDMedicalItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDMedicalItem"];
}

@dynamic count;
@dynamic is_prescription;
@dynamic itemID;
@dynamic name;
@dynamic uomName;
@dynamic uomID;
@dynamic chufang;
@dynamic feichufang;

@end
