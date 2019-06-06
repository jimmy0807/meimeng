//
//  CDHCustomer+CoreDataProperties.h
//  meim
//
//  Created by bonn on 2017/4/26.
//
//

#import "CDHCustomer+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDHCustomer (CoreDataProperties)

+ (NSFetchRequest<CDHCustomer *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *birthday;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *gender;
@property (nullable, nonatomic, copy) NSString *imageName;
@property (nullable, nonatomic, copy) NSNumber *isAcitve;
@property (nullable, nonatomic, copy) NSString *lastUpdate;
@property (nullable, nonatomic, copy) NSString *member_address;
@property (nullable, nonatomic, copy) NSString *member_qq;
@property (nullable, nonatomic, copy) NSString *member_sign_date;
@property (nullable, nonatomic, copy) NSString *member_source;
@property (nullable, nonatomic, copy) NSNumber *member_title_id;
@property (nullable, nonatomic, copy) NSString *member_title_name;
@property (nullable, nonatomic, copy) NSString *member_wx;
@property (nullable, nonatomic, copy) NSNumber *memberID;
@property (nullable, nonatomic, copy) NSString *memberName;
@property (nullable, nonatomic, copy) NSString *memberNameFirstLetter;
@property (nullable, nonatomic, copy) NSString *memberNameLetter;
@property (nullable, nonatomic, copy) NSString *memberNameSingleLetter;
@property (nullable, nonatomic, copy) NSString *mobile;
@property (nullable, nonatomic, copy) NSString *partner_name;
@property (nullable, nonatomic, copy) NSNumber *partner_name_id;
@property (nullable, nonatomic, copy) NSString *remark;
@property (nullable, nonatomic, copy) NSNumber *storeID;
@property (nullable, nonatomic, copy) NSString *storeName;
@property (nullable, nonatomic, copy) NSNumber *tuijian_kehu_id;
@property (nullable, nonatomic, copy) NSString *tuijian_kehu_name;
@property (nullable, nonatomic, copy) NSNumber *tuijian_member_id;
@property (nullable, nonatomic, copy) NSString *tuijian_member_name;
@property (nullable, nonatomic, copy) NSString *create_date;
@property (nullable, nonatomic, copy) NSNumber *is_operate;

@end

NS_ASSUME_NONNULL_END
