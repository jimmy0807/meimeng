//
//  CDZongkongLiyuanItem+CoreDataProperties.h
//  meim
//
//  Created by 宋海斌 on 2017/6/22.
//
//

#import "CDZongkongLiyuanItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDZongkongLiyuanItem (CoreDataProperties)

+ (NSFetchRequest<CDZongkongLiyuanItem *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSString *time;
@property (nullable, nonatomic, retain) CDZongkongLiyuanPerson *person;

@end

NS_ASSUME_NONNULL_END
