//
//  CDZongkongLiyuanItem+CoreDataProperties.m
//  meim
//
//  Created by 宋海斌 on 2017/6/22.
//
//

#import "CDZongkongLiyuanItem+CoreDataProperties.h"

@implementation CDZongkongLiyuanItem (CoreDataProperties)

+ (NSFetchRequest<CDZongkongLiyuanItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDZongkongLiyuanItem"];
}

@dynamic title;
@dynamic content;
@dynamic time;
@dynamic person;

@end
