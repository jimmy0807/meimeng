//
//  CDPOSPayMode+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 16/12/19.
//
//

#import "CDPOSPayMode+CoreDataProperties.h"

@implementation CDPOSPayMode (CoreDataProperties)

+ (NSFetchRequest<CDPOSPayMode *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDPOSPayMode"];
}

@dynamic incomeAmount;
@dynamic mode;
@dynamic payID;
@dynamic payName;
@dynamic payType;
@dynamic statementID;
@dynamic type;
@dynamic payment_acquirer_id;
@dynamic payInfos;

@end
