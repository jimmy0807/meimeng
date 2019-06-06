//
//  CDYimeiImage+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/7/20.
//
//

#import "CDYimeiImage+CoreDataProperties.h"

@implementation CDYimeiImage (CoreDataProperties)

+ (NSFetchRequest<CDYimeiImage *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDYimeiImage"];
}

@dynamic imageID;
@dynamic small_url;
@dynamic status;
@dynamic type;
@dynamic url;
@dynamic take_time;
@dynamic before;
@dynamic huifang;
@dynamic partner;
@dynamic washhand;
@dynamic zixun;
@dynamic huizhen;

@end
