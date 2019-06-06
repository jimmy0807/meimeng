//
//  CDBook+CoreDataProperties.h
//  meim
//
//  Created by 波恩公司 on 2017/12/28.
//
//

#import "CDBook+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDBook (CoreDataProperties)

+ (NSFetchRequest<CDBook *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *address;
@property (nullable, nonatomic, copy) NSString *approve_date;
@property (nullable, nonatomic, copy) NSNumber *approve_id;
@property (nullable, nonatomic, copy) NSString *approve_mark;
@property (nullable, nonatomic, copy) NSString *approve_name;
@property (nullable, nonatomic, copy) NSNumber *aside_time;
@property (nullable, nonatomic, copy) NSNumber *book_id;
@property (nullable, nonatomic, copy) NSString *booker_name;
@property (nullable, nonatomic, copy) NSNumber *columnIdx;
@property (nullable, nonatomic, copy) NSNumber *company_id;
@property (nullable, nonatomic, copy) NSString *company_name;
@property (nullable, nonatomic, copy) NSString *consume_date;
@property (nullable, nonatomic, copy) NSNumber *create_uid;
@property (nullable, nonatomic, copy) NSNumber *designers_id;
@property (nullable, nonatomic, copy) NSString *designers_name;
@property (nullable, nonatomic, copy) NSNumber *designers_service_id;
@property (nullable, nonatomic, copy) NSString *designers_service_name;
@property (nullable, nonatomic, copy) NSNumber *director_employee_id;
@property (nullable, nonatomic, copy) NSString *director_employee_name;
@property (nullable, nonatomic, copy) NSNumber *doctor_id;
@property (nullable, nonatomic, copy) NSString *doctor_name;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSNumber *employee_id;
@property (nullable, nonatomic, copy) NSString *employee_name;
@property (nullable, nonatomic, copy) NSString *end_date;
@property (nullable, nonatomic, copy) NSString *gender;
@property (nullable, nonatomic, copy) NSNumber *is_active;
@property (nullable, nonatomic, copy) NSNumber *is_anesthetic;
@property (nullable, nonatomic, copy) NSNumber *is_checked;
@property (nullable, nonatomic, copy) NSNumber *is_partner;
@property (nullable, nonatomic, copy) NSNumber *is_reservation_bill;
@property (nullable, nonatomic, copy) NSNumber *is_visit;
@property (nullable, nonatomic, copy) NSNumber *isUsed;
@property (nullable, nonatomic, copy) NSString *lastUpdate;
@property (nullable, nonatomic, copy) NSString *mark;
@property (nullable, nonatomic, copy) NSNumber *member_id;
@property (nullable, nonatomic, copy) NSString *member_name;
@property (nullable, nonatomic, copy) NSString *member_type;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *operate_id;
@property (nullable, nonatomic, copy) NSString *operate_name;
@property (nullable, nonatomic, copy) NSNumber *orginColumnIdx;
@property (nullable, nonatomic, copy) NSNumber *people_num;
@property (nullable, nonatomic, copy) NSString *product_ids;
@property (nullable, nonatomic, copy) NSString *product_name;
@property (nullable, nonatomic, copy) NSString *recommend_member_phone;
@property (nullable, nonatomic, copy) NSNumber *room_id;
@property (nullable, nonatomic, copy) NSString *room_name;
@property (nullable, nonatomic, copy) NSNumber *shop_id;
@property (nullable, nonatomic, copy) NSString *shop_name;
@property (nullable, nonatomic, copy) NSString *source;
@property (nullable, nonatomic, copy) NSString *start_date;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSNumber *table_id;
@property (nullable, nonatomic, copy) NSString *table_name;
@property (nullable, nonatomic, copy) NSNumber *technician_id;
@property (nullable, nonatomic, copy) NSString *technician_name;
@property (nullable, nonatomic, copy) NSString *telephone;
@property (nullable, nonatomic, copy) NSNumber *is_consult_finished;
@property (nullable, nonatomic, retain) CDPosOperate *posOperate;
@property (nullable, nonatomic, retain) CDPosProduct *posProduct;
@property (nullable, nonatomic, retain) CDRestaurantTableUse *tableUse;
@property (nullable, nonatomic, retain) CDCurrentUseItem *useItem;

@end

NS_ASSUME_NONNULL_END
