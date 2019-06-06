//
//  CDMessageRecord+CoreDataProperties.h
//  meim
//
//  Created by lining on 2016/11/30.
//
//

#import "CDMessageRecord+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDMessageRecord (CoreDataProperties)

+ (NSFetchRequest<CDMessageRecord *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *send_no;
@property (nullable, nonatomic, copy) NSString *phones;
@property (nullable, nonatomic, copy) NSString *send_date;
@property (nullable, nonatomic, copy) NSString *template_content;
@property (nullable, nonatomic, copy) NSString *born_uuid;
@property (nullable, nonatomic, copy) NSString *shop_uuid;
@property (nullable, nonatomic, copy) NSString *company_uuid;

@end

NS_ASSUME_NONNULL_END
