//
//  CDHCustomer+CoreDataProperties.m
//  meim
//
//  Created by bonn on 2017/4/26.
//
//

#import "CDHCustomer+CoreDataProperties.h"

@implementation CDHCustomer (CoreDataProperties)

+ (NSFetchRequest<CDHCustomer *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDHCustomer"];
}

@dynamic birthday;
@dynamic email;
@dynamic gender;
@dynamic imageName;
@dynamic isAcitve;
@dynamic lastUpdate;
@dynamic member_address;
@dynamic member_qq;
@dynamic member_sign_date;
@dynamic member_source;
@dynamic member_title_id;
@dynamic member_title_name;
@dynamic member_wx;
@dynamic memberID;
@dynamic memberName;
@dynamic memberNameFirstLetter;
@dynamic memberNameLetter;
@dynamic memberNameSingleLetter;
@dynamic mobile;
@dynamic partner_name;
@dynamic partner_name_id;
@dynamic remark;
@dynamic storeID;
@dynamic storeName;
@dynamic tuijian_kehu_id;
@dynamic tuijian_kehu_name;
@dynamic tuijian_member_id;
@dynamic tuijian_member_name;
@dynamic create_date;
@dynamic is_operate;

@end
