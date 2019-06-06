//
//  CDPosOperate+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2017/6/17.
//
//

#import "CDPosOperate+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDPosOperate (CoreDataProperties)

+ (NSFetchRequest<CDPosOperate *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *amount;
@property (nullable, nonatomic, copy) NSString *anesthetic_consuming;
@property (nullable, nonatomic, copy) NSString *arrear_ids;
@property (nullable, nonatomic, copy) NSNumber *binglika_id;
@property (nullable, nonatomic, copy) NSString *born_uuid;
@property (nullable, nonatomic, copy) NSNumber *card_id;
@property (nullable, nonatomic, copy) NSString *card_name;
@property (nullable, nonatomic, copy) NSNumber *card_shop_id;
@property (nullable, nonatomic, copy) NSString *card_shop_name;
@property (nullable, nonatomic, copy) NSString *commission_ids;
@property (nullable, nonatomic, copy) NSString *consume_line_ids;
@property (nullable, nonatomic, copy) NSString *consume_product_names;
@property (nullable, nonatomic, copy) NSNumber *current_workflow_activity_id;
@property (nullable, nonatomic, copy) NSNumber *currentWorkflowID;
@property (nullable, nonatomic, copy) NSNumber *day;
@property (nullable, nonatomic, copy) NSString *display_remark;
@property (nullable, nonatomic, copy) NSNumber *doctor_id;
@property (nullable, nonatomic, copy) NSString *doctor_name;
@property (nullable, nonatomic, copy) NSString *handno;
@property (nullable, nonatomic, copy) NSNumber *index;
@property (nullable, nonatomic, copy) NSNumber *isLocal;
@property (nullable, nonatomic, copy) NSNumber *isTakeout;
@property (nullable, nonatomic, copy) NSNumber *keshi_id;
@property (nullable, nonatomic, copy) NSString *keshi_name;
@property (nullable, nonatomic, copy) NSString *line_display_name;
@property (nullable, nonatomic, copy) NSString *localUpdateDate;
@property (nullable, nonatomic, copy) NSNumber *member_id;
@property (nullable, nonatomic, copy) NSString *member_mobile;
@property (nullable, nonatomic, copy) NSString *member_name;
@property (nullable, nonatomic, copy) NSString *memberNameFirstLetter;
@property (nullable, nonatomic, copy) NSString *memberNameLetter;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *note;
@property (nullable, nonatomic, copy) NSString *now_arrears_amount;
@property (nullable, nonatomic, copy) NSNumber *now_card_amount;
@property (nullable, nonatomic, copy) NSNumber *nowAmount;
@property (nullable, nonatomic, copy) NSNumber *occupy_restaurant_id;
@property (nullable, nonatomic, copy) NSNumber *old_operate_id;
@property (nullable, nonatomic, copy) NSString *operate_date;
@property (nullable, nonatomic, copy) NSNumber *operate_id;
@property (nullable, nonatomic, copy) NSNumber *operate_shop_id;
@property (nullable, nonatomic, copy) NSString *operate_shop_name;
@property (nullable, nonatomic, copy) NSNumber *operate_user_id;
@property (nullable, nonatomic, copy) NSString *operate_user_name;
@property (nullable, nonatomic, copy) NSNumber *operateType;
@property (nullable, nonatomic, copy) NSNumber *orderCreateStaffID;
@property (nullable, nonatomic, copy) NSString *orderCreateStaffName;
@property (nullable, nonatomic, copy) NSNumber *orderID;
@property (nullable, nonatomic, copy) NSString *orderNumber;
@property (nullable, nonatomic, copy) NSNumber *orderState;
@property (nullable, nonatomic, copy) NSNumber *period_id;
@property (nullable, nonatomic, copy) NSString *period_name;
@property (nullable, nonatomic, copy) NSNumber *pricelist_id;
@property (nullable, nonatomic, copy) NSString *pricelist_name;
@property (nullable, nonatomic, copy) NSString *product_line_ids;
@property (nullable, nonatomic, copy) NSString *progre_status;
@property (nullable, nonatomic, copy) NSString *remark;
@property (nullable, nonatomic, copy) NSNumber *restaurant_person_count;
@property (nullable, nonatomic, copy) NSNumber *role_option;
@property (nullable, nonatomic, copy) NSString *serial;
@property (nullable, nonatomic, copy) NSNumber *session_id;
@property (nullable, nonatomic, copy) NSString *session_name;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSString *statement_ids;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSNumber *wevip_member_id;
@property (nullable, nonatomic, copy) NSString *wevip_member_name;
@property (nullable, nonatomic, copy) NSNumber *workflow_id;
@property (nullable, nonatomic, copy) NSString *year_month;
@property (nullable, nonatomic, copy) NSString *year_month_day;
@property (nullable, nonatomic, copy) NSNumber *yimei_guwenID;
@property (nullable, nonatomic, copy) NSString *yimei_guwenName;
@property (nullable, nonatomic, copy) NSString *yimei_member_type;
@property (nullable, nonatomic, copy) NSNumber *yimei_operate_employee_id;
@property (nullable, nonatomic, copy) NSString *yimei_operate_employee_ids;
@property (nullable, nonatomic, copy) NSString *yimei_operate_employee_name;
@property (nullable, nonatomic, copy) NSNumber *yimei_orderIndex;
@property (nullable, nonatomic, copy) NSNumber *yimei_provision_id;
@property (nullable, nonatomic, copy) NSString *yimei_queueID;
@property (nullable, nonatomic, copy) NSNumber *yimei_shejishiID;
@property (nullable, nonatomic, copy) NSString *yimei_shejishiName;
@property (nullable, nonatomic, copy) NSNumber *yimei_shejizongjianID;
@property (nullable, nonatomic, copy) NSString *yimei_shejizongjianName;
@property (nullable, nonatomic, copy) NSString *yimei_sign_after;
@property (nullable, nonatomic, copy) NSString *yimei_sign_before;
@property (nullable, nonatomic, copy) NSString *doctorids;
@property (nullable, nonatomic, copy) NSString *departmentids;
@property (nullable, nonatomic, copy) NSString *productids;
@property (nullable, nonatomic, retain) CDBook *book;
@property (nullable, nonatomic, retain) CDMemberCard *cardForOperateList;
@property (nullable, nonatomic, retain) NSOrderedSet<CDPosCommission *> *commissions;
@property (nullable, nonatomic, retain) NSOrderedSet<CDPosCoupon *> *consumCoupons;
@property (nullable, nonatomic, retain) CDCouponCard *couponCard;
@property (nullable, nonatomic, retain) CDKeShi *firstKeshi;
@property (nullable, nonatomic, retain) CDMember *member;
@property (nullable, nonatomic, retain) CDMemberCard *memberCard;
@property (nullable, nonatomic, retain) NSOrderedSet<CDPosOperatePayInfo *> *payInfos;
@property (nullable, nonatomic, retain) NSOrderedSet<CDPosBaseProduct *> *products;
@property (nullable, nonatomic, retain) CDMember *recentMember;
@property (nullable, nonatomic, retain) CDRestaurantTable *restaurant_table;
@property (nullable, nonatomic, retain) CDStore *shop;
@property (nullable, nonatomic, retain) NSOrderedSet<CDCurrentUseItem *> *useItems;
@property (nullable, nonatomic, retain) NSOrderedSet<CDOperateActivity *> *yimei_activity;
@property (nullable, nonatomic, retain) NSOrderedSet<CDYimeiImage *> *yimei_before;

@end

@interface CDPosOperate (CoreDataGeneratedAccessors)

- (void)insertObject:(CDPosCommission *)value inCommissionsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCommissionsAtIndex:(NSUInteger)idx;
- (void)insertCommissions:(NSArray<CDPosCommission *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCommissionsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCommissionsAtIndex:(NSUInteger)idx withObject:(CDPosCommission *)value;
- (void)replaceCommissionsAtIndexes:(NSIndexSet *)indexes withCommissions:(NSArray<CDPosCommission *> *)values;
- (void)addCommissionsObject:(CDPosCommission *)value;
- (void)removeCommissionsObject:(CDPosCommission *)value;
- (void)addCommissions:(NSOrderedSet<CDPosCommission *> *)values;
- (void)removeCommissions:(NSOrderedSet<CDPosCommission *> *)values;

- (void)insertObject:(CDPosCoupon *)value inConsumCouponsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromConsumCouponsAtIndex:(NSUInteger)idx;
- (void)insertConsumCoupons:(NSArray<CDPosCoupon *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeConsumCouponsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInConsumCouponsAtIndex:(NSUInteger)idx withObject:(CDPosCoupon *)value;
- (void)replaceConsumCouponsAtIndexes:(NSIndexSet *)indexes withConsumCoupons:(NSArray<CDPosCoupon *> *)values;
- (void)addConsumCouponsObject:(CDPosCoupon *)value;
- (void)removeConsumCouponsObject:(CDPosCoupon *)value;
- (void)addConsumCoupons:(NSOrderedSet<CDPosCoupon *> *)values;
- (void)removeConsumCoupons:(NSOrderedSet<CDPosCoupon *> *)values;

- (void)insertObject:(CDPosOperatePayInfo *)value inPayInfosAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPayInfosAtIndex:(NSUInteger)idx;
- (void)insertPayInfos:(NSArray<CDPosOperatePayInfo *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePayInfosAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPayInfosAtIndex:(NSUInteger)idx withObject:(CDPosOperatePayInfo *)value;
- (void)replacePayInfosAtIndexes:(NSIndexSet *)indexes withPayInfos:(NSArray<CDPosOperatePayInfo *> *)values;
- (void)addPayInfosObject:(CDPosOperatePayInfo *)value;
- (void)removePayInfosObject:(CDPosOperatePayInfo *)value;
- (void)addPayInfos:(NSOrderedSet<CDPosOperatePayInfo *> *)values;
- (void)removePayInfos:(NSOrderedSet<CDPosOperatePayInfo *> *)values;

- (void)insertObject:(CDPosBaseProduct *)value inProductsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromProductsAtIndex:(NSUInteger)idx;
- (void)insertProducts:(NSArray<CDPosBaseProduct *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeProductsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInProductsAtIndex:(NSUInteger)idx withObject:(CDPosBaseProduct *)value;
- (void)replaceProductsAtIndexes:(NSIndexSet *)indexes withProducts:(NSArray<CDPosBaseProduct *> *)values;
- (void)addProductsObject:(CDPosBaseProduct *)value;
- (void)removeProductsObject:(CDPosBaseProduct *)value;
- (void)addProducts:(NSOrderedSet<CDPosBaseProduct *> *)values;
- (void)removeProducts:(NSOrderedSet<CDPosBaseProduct *> *)values;

- (void)insertObject:(CDCurrentUseItem *)value inUseItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromUseItemsAtIndex:(NSUInteger)idx;
- (void)insertUseItems:(NSArray<CDCurrentUseItem *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeUseItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInUseItemsAtIndex:(NSUInteger)idx withObject:(CDCurrentUseItem *)value;
- (void)replaceUseItemsAtIndexes:(NSIndexSet *)indexes withUseItems:(NSArray<CDCurrentUseItem *> *)values;
- (void)addUseItemsObject:(CDCurrentUseItem *)value;
- (void)removeUseItemsObject:(CDCurrentUseItem *)value;
- (void)addUseItems:(NSOrderedSet<CDCurrentUseItem *> *)values;
- (void)removeUseItems:(NSOrderedSet<CDCurrentUseItem *> *)values;

- (void)insertObject:(CDOperateActivity *)value inYimei_activityAtIndex:(NSUInteger)idx;
- (void)removeObjectFromYimei_activityAtIndex:(NSUInteger)idx;
- (void)insertYimei_activity:(NSArray<CDOperateActivity *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeYimei_activityAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInYimei_activityAtIndex:(NSUInteger)idx withObject:(CDOperateActivity *)value;
- (void)replaceYimei_activityAtIndexes:(NSIndexSet *)indexes withYimei_activity:(NSArray<CDOperateActivity *> *)values;
- (void)addYimei_activityObject:(CDOperateActivity *)value;
- (void)removeYimei_activityObject:(CDOperateActivity *)value;
- (void)addYimei_activity:(NSOrderedSet<CDOperateActivity *> *)values;
- (void)removeYimei_activity:(NSOrderedSet<CDOperateActivity *> *)values;

- (void)insertObject:(CDYimeiImage *)value inYimei_beforeAtIndex:(NSUInteger)idx;
- (void)removeObjectFromYimei_beforeAtIndex:(NSUInteger)idx;
- (void)insertYimei_before:(NSArray<CDYimeiImage *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeYimei_beforeAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInYimei_beforeAtIndex:(NSUInteger)idx withObject:(CDYimeiImage *)value;
- (void)replaceYimei_beforeAtIndexes:(NSIndexSet *)indexes withYimei_before:(NSArray<CDYimeiImage *> *)values;
- (void)addYimei_beforeObject:(CDYimeiImage *)value;
- (void)removeYimei_beforeObject:(CDYimeiImage *)value;
- (void)addYimei_before:(NSOrderedSet<CDYimeiImage *> *)values;
- (void)removeYimei_before:(NSOrderedSet<CDYimeiImage *> *)values;

@end

NS_ASSUME_NONNULL_END
