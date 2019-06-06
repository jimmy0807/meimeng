//
//  CDMember+CoreDataProperties.h
//  meim
//
//  Created by 波恩公司 on 2017/11/9.
//
//

#import "CDMember+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDMember (CoreDataProperties)

+ (NSFetchRequest<CDMember *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *amount;
@property (nullable, nonatomic, copy) NSString *arrearsAmount;
@property (nullable, nonatomic, copy) NSString *astro;
@property (nullable, nonatomic, copy) NSString *birthday;
@property (nullable, nonatomic, copy) NSString *blood_type;
@property (nullable, nonatomic, copy) NSNumber *companyID;
@property (nullable, nonatomic, copy) NSString *companyName;
@property (nullable, nonatomic, copy) NSString *courseArrearsAmount;
@property (nullable, nonatomic, copy) NSString *dd_partner;
@property (nullable, nonatomic, copy) NSString *director_employee;
@property (nullable, nonatomic, copy) NSNumber *director_employee_id;
@property (nullable, nonatomic, copy) NSString *dj_partner;
@property (nullable, nonatomic, copy) NSString *dl_partner;
@property (nullable, nonatomic, copy) NSNumber *doctor_id;
@property (nullable, nonatomic, copy) NSString *doctor_name;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *employee_name;
@property (nullable, nonatomic, copy) NSString *first_treat_date;
@property (nullable, nonatomic, copy) NSString *gender;
@property (nullable, nonatomic, copy) NSNumber *h_patient_type;
@property (nullable, nonatomic, copy) NSString *idCardNumber;
@property (nullable, nonatomic, copy) NSString *image_url;
@property (nullable, nonatomic, copy) NSString *imageName;
@property (nullable, nonatomic, copy) NSNumber *isAcitve;
@property (nullable, nonatomic, copy) NSNumber *isDefaultCustomer;
@property (nullable, nonatomic, copy) NSNumber *isTiyan;
@property (nullable, nonatomic, copy) NSNumber *isWevipCustom;
@property (nullable, nonatomic, copy) NSString *lastUpdate;
@property (nullable, nonatomic, copy) NSString *member_address;
@property (nullable, nonatomic, copy) NSNumber *member_feedback_count;
@property (nullable, nonatomic, copy) NSString *member_fenlei;
@property (nullable, nonatomic, copy) NSNumber *member_guwen_id;
@property (nullable, nonatomic, copy) NSString *member_guwen_name;
@property (nullable, nonatomic, copy) NSNumber *member_identity_id;
@property (nullable, nonatomic, copy) NSNumber *member_jishi_id;
@property (nullable, nonatomic, copy) NSString *member_jishi_name;
@property (nullable, nonatomic, copy) NSString *member_level;
@property (nullable, nonatomic, copy) NSString *member_qq;
@property (nullable, nonatomic, copy) NSNumber *member_qy_count;
@property (nullable, nonatomic, copy) NSNumber *member_shejishi_id;
@property (nullable, nonatomic, copy) NSString *member_shejishi_name;
@property (nullable, nonatomic, copy) NSString *member_sign_date;
@property (nullable, nonatomic, copy) NSString *member_source;
@property (nullable, nonatomic, copy) NSNumber *member_title_id;
@property (nullable, nonatomic, copy) NSString *member_title_name;
@property (nullable, nonatomic, copy) NSNumber *member_tuijian_staff_id;
@property (nullable, nonatomic, copy) NSString *member_tuijian_staff_name;
@property (nullable, nonatomic, copy) NSNumber *member_tuijian_vip_id;
@property (nullable, nonatomic, copy) NSString *member_tuijian_vip_name;
@property (nullable, nonatomic, copy) NSNumber *member_tz_count;
@property (nullable, nonatomic, copy) NSString *member_wx;
@property (nullable, nonatomic, copy) NSNumber *memberID;
@property (nullable, nonatomic, copy) NSString *memberName;
@property (nullable, nonatomic, copy) NSString *memberNameFirstLetter;
@property (nullable, nonatomic, copy) NSString *memberNameLetter;
@property (nullable, nonatomic, copy) NSString *memberNameSingleLetter;
@property (nullable, nonatomic, copy) NSString *memberNo;
@property (nullable, nonatomic, copy) NSString *mobile;
@property (nullable, nonatomic, copy) NSString *patient_tag;
@property (nullable, nonatomic, copy) NSNumber *point;
@property (nullable, nonatomic, copy) NSString *product_all_ids;
@property (nullable, nonatomic, copy) NSNumber *record_id;
@property (nullable, nonatomic, copy) NSString *record_note;
@property (nullable, nonatomic, copy) NSString *record_time;
@property (nullable, nonatomic, copy) NSNumber *showPatient;
@property (nullable, nonatomic, copy) NSNumber *sortIndex;
@property (nullable, nonatomic, copy) NSString *status;
@property (nullable, nonatomic, copy) NSNumber *storeID;
@property (nullable, nonatomic, copy) NSString *storeName;
@property (nullable, nonatomic, copy) NSString *yimei_member_type;
@property (nullable, nonatomic, copy) NSString *parent_id;
@property (nullable, nonatomic, copy) NSString *parent_name;
@property (nullable, nonatomic, retain) NSOrderedSet<CDMemberCardAmount *> *amounts;
@property (nullable, nonatomic, retain) NSOrderedSet<CDMemberCardArrears *> *arrears;
@property (nullable, nonatomic, retain) NSOrderedSet<CDMemberCard *> *card;
@property (nullable, nonatomic, retain) NSOrderedSet<CDMemberChangeShop *> *changeShops;
@property (nullable, nonatomic, retain) NSOrderedSet<CDMemberCardConsume *> *consumes;
@property (nullable, nonatomic, retain) NSOrderedSet<CDCouponCard *> *coupons;
@property (nullable, nonatomic, retain) NSOrderedSet<CDMemberFeedback *> *feedbacks;
@property (nullable, nonatomic, retain) CDStaff *guwen;
@property (nullable, nonatomic, retain) CDStaff *jishi;
@property (nullable, nonatomic, retain) CDMember *member_tuijian;
@property (nullable, nonatomic, retain) NSOrderedSet<CDMemberCardPoint *> *points;
@property (nullable, nonatomic, retain) NSOrderedSet<CDPosOperate *> *posOperate;
@property (nullable, nonatomic, retain) NSOrderedSet<CDMemberQinyou *> *qinyous;
@property (nullable, nonatomic, retain) NSOrderedSet<CDPosOperate *> *recentOperates;
@property (nullable, nonatomic, retain) CDStaff *staff_tuijian;
@property (nullable, nonatomic, retain) CDStore *store;
@property (nullable, nonatomic, retain) NSOrderedSet<CDMemberTeZheng *> *tezhengs;
@property (nullable, nonatomic, retain) CDMemberTitle *title;
@property (nullable, nonatomic, retain) NSOrderedSet<CDMember *> *tuijian_members;

@end

@interface CDMember (CoreDataGeneratedAccessors)

- (void)insertObject:(CDMemberCardAmount *)value inAmountsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromAmountsAtIndex:(NSUInteger)idx;
- (void)insertAmounts:(NSArray<CDMemberCardAmount *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeAmountsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInAmountsAtIndex:(NSUInteger)idx withObject:(CDMemberCardAmount *)value;
- (void)replaceAmountsAtIndexes:(NSIndexSet *)indexes withAmounts:(NSArray<CDMemberCardAmount *> *)values;
- (void)addAmountsObject:(CDMemberCardAmount *)value;
- (void)removeAmountsObject:(CDMemberCardAmount *)value;
- (void)addAmounts:(NSOrderedSet<CDMemberCardAmount *> *)values;
- (void)removeAmounts:(NSOrderedSet<CDMemberCardAmount *> *)values;

- (void)insertObject:(CDMemberCardArrears *)value inArrearsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromArrearsAtIndex:(NSUInteger)idx;
- (void)insertArrears:(NSArray<CDMemberCardArrears *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeArrearsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInArrearsAtIndex:(NSUInteger)idx withObject:(CDMemberCardArrears *)value;
- (void)replaceArrearsAtIndexes:(NSIndexSet *)indexes withArrears:(NSArray<CDMemberCardArrears *> *)values;
- (void)addArrearsObject:(CDMemberCardArrears *)value;
- (void)removeArrearsObject:(CDMemberCardArrears *)value;
- (void)addArrears:(NSOrderedSet<CDMemberCardArrears *> *)values;
- (void)removeArrears:(NSOrderedSet<CDMemberCardArrears *> *)values;

- (void)insertObject:(CDMemberCard *)value inCardAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCardAtIndex:(NSUInteger)idx;
- (void)insertCard:(NSArray<CDMemberCard *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCardAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCardAtIndex:(NSUInteger)idx withObject:(CDMemberCard *)value;
- (void)replaceCardAtIndexes:(NSIndexSet *)indexes withCard:(NSArray<CDMemberCard *> *)values;
- (void)addCardObject:(CDMemberCard *)value;
- (void)removeCardObject:(CDMemberCard *)value;
- (void)addCard:(NSOrderedSet<CDMemberCard *> *)values;
- (void)removeCard:(NSOrderedSet<CDMemberCard *> *)values;

- (void)insertObject:(CDMemberChangeShop *)value inChangeShopsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromChangeShopsAtIndex:(NSUInteger)idx;
- (void)insertChangeShops:(NSArray<CDMemberChangeShop *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeChangeShopsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInChangeShopsAtIndex:(NSUInteger)idx withObject:(CDMemberChangeShop *)value;
- (void)replaceChangeShopsAtIndexes:(NSIndexSet *)indexes withChangeShops:(NSArray<CDMemberChangeShop *> *)values;
- (void)addChangeShopsObject:(CDMemberChangeShop *)value;
- (void)removeChangeShopsObject:(CDMemberChangeShop *)value;
- (void)addChangeShops:(NSOrderedSet<CDMemberChangeShop *> *)values;
- (void)removeChangeShops:(NSOrderedSet<CDMemberChangeShop *> *)values;

- (void)insertObject:(CDMemberCardConsume *)value inConsumesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromConsumesAtIndex:(NSUInteger)idx;
- (void)insertConsumes:(NSArray<CDMemberCardConsume *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeConsumesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInConsumesAtIndex:(NSUInteger)idx withObject:(CDMemberCardConsume *)value;
- (void)replaceConsumesAtIndexes:(NSIndexSet *)indexes withConsumes:(NSArray<CDMemberCardConsume *> *)values;
- (void)addConsumesObject:(CDMemberCardConsume *)value;
- (void)removeConsumesObject:(CDMemberCardConsume *)value;
- (void)addConsumes:(NSOrderedSet<CDMemberCardConsume *> *)values;
- (void)removeConsumes:(NSOrderedSet<CDMemberCardConsume *> *)values;

- (void)insertObject:(CDCouponCard *)value inCouponsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCouponsAtIndex:(NSUInteger)idx;
- (void)insertCoupons:(NSArray<CDCouponCard *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCouponsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCouponsAtIndex:(NSUInteger)idx withObject:(CDCouponCard *)value;
- (void)replaceCouponsAtIndexes:(NSIndexSet *)indexes withCoupons:(NSArray<CDCouponCard *> *)values;
- (void)addCouponsObject:(CDCouponCard *)value;
- (void)removeCouponsObject:(CDCouponCard *)value;
- (void)addCoupons:(NSOrderedSet<CDCouponCard *> *)values;
- (void)removeCoupons:(NSOrderedSet<CDCouponCard *> *)values;

- (void)insertObject:(CDMemberFeedback *)value inFeedbacksAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFeedbacksAtIndex:(NSUInteger)idx;
- (void)insertFeedbacks:(NSArray<CDMemberFeedback *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFeedbacksAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFeedbacksAtIndex:(NSUInteger)idx withObject:(CDMemberFeedback *)value;
- (void)replaceFeedbacksAtIndexes:(NSIndexSet *)indexes withFeedbacks:(NSArray<CDMemberFeedback *> *)values;
- (void)addFeedbacksObject:(CDMemberFeedback *)value;
- (void)removeFeedbacksObject:(CDMemberFeedback *)value;
- (void)addFeedbacks:(NSOrderedSet<CDMemberFeedback *> *)values;
- (void)removeFeedbacks:(NSOrderedSet<CDMemberFeedback *> *)values;

- (void)insertObject:(CDMemberCardPoint *)value inPointsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPointsAtIndex:(NSUInteger)idx;
- (void)insertPoints:(NSArray<CDMemberCardPoint *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePointsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPointsAtIndex:(NSUInteger)idx withObject:(CDMemberCardPoint *)value;
- (void)replacePointsAtIndexes:(NSIndexSet *)indexes withPoints:(NSArray<CDMemberCardPoint *> *)values;
- (void)addPointsObject:(CDMemberCardPoint *)value;
- (void)removePointsObject:(CDMemberCardPoint *)value;
- (void)addPoints:(NSOrderedSet<CDMemberCardPoint *> *)values;
- (void)removePoints:(NSOrderedSet<CDMemberCardPoint *> *)values;

- (void)insertObject:(CDPosOperate *)value inPosOperateAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPosOperateAtIndex:(NSUInteger)idx;
- (void)insertPosOperate:(NSArray<CDPosOperate *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePosOperateAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPosOperateAtIndex:(NSUInteger)idx withObject:(CDPosOperate *)value;
- (void)replacePosOperateAtIndexes:(NSIndexSet *)indexes withPosOperate:(NSArray<CDPosOperate *> *)values;
- (void)addPosOperateObject:(CDPosOperate *)value;
- (void)removePosOperateObject:(CDPosOperate *)value;
- (void)addPosOperate:(NSOrderedSet<CDPosOperate *> *)values;
- (void)removePosOperate:(NSOrderedSet<CDPosOperate *> *)values;

- (void)insertObject:(CDMemberQinyou *)value inQinyousAtIndex:(NSUInteger)idx;
- (void)removeObjectFromQinyousAtIndex:(NSUInteger)idx;
- (void)insertQinyous:(NSArray<CDMemberQinyou *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeQinyousAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInQinyousAtIndex:(NSUInteger)idx withObject:(CDMemberQinyou *)value;
- (void)replaceQinyousAtIndexes:(NSIndexSet *)indexes withQinyous:(NSArray<CDMemberQinyou *> *)values;
- (void)addQinyousObject:(CDMemberQinyou *)value;
- (void)removeQinyousObject:(CDMemberQinyou *)value;
- (void)addQinyous:(NSOrderedSet<CDMemberQinyou *> *)values;
- (void)removeQinyous:(NSOrderedSet<CDMemberQinyou *> *)values;

- (void)insertObject:(CDPosOperate *)value inRecentOperatesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRecentOperatesAtIndex:(NSUInteger)idx;
- (void)insertRecentOperates:(NSArray<CDPosOperate *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRecentOperatesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRecentOperatesAtIndex:(NSUInteger)idx withObject:(CDPosOperate *)value;
- (void)replaceRecentOperatesAtIndexes:(NSIndexSet *)indexes withRecentOperates:(NSArray<CDPosOperate *> *)values;
- (void)addRecentOperatesObject:(CDPosOperate *)value;
- (void)removeRecentOperatesObject:(CDPosOperate *)value;
- (void)addRecentOperates:(NSOrderedSet<CDPosOperate *> *)values;
- (void)removeRecentOperates:(NSOrderedSet<CDPosOperate *> *)values;

- (void)insertObject:(CDMemberTeZheng *)value inTezhengsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTezhengsAtIndex:(NSUInteger)idx;
- (void)insertTezhengs:(NSArray<CDMemberTeZheng *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTezhengsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTezhengsAtIndex:(NSUInteger)idx withObject:(CDMemberTeZheng *)value;
- (void)replaceTezhengsAtIndexes:(NSIndexSet *)indexes withTezhengs:(NSArray<CDMemberTeZheng *> *)values;
- (void)addTezhengsObject:(CDMemberTeZheng *)value;
- (void)removeTezhengsObject:(CDMemberTeZheng *)value;
- (void)addTezhengs:(NSOrderedSet<CDMemberTeZheng *> *)values;
- (void)removeTezhengs:(NSOrderedSet<CDMemberTeZheng *> *)values;

- (void)insertObject:(CDMember *)value inTuijian_membersAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTuijian_membersAtIndex:(NSUInteger)idx;
- (void)insertTuijian_members:(NSArray<CDMember *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTuijian_membersAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTuijian_membersAtIndex:(NSUInteger)idx withObject:(CDMember *)value;
- (void)replaceTuijian_membersAtIndexes:(NSIndexSet *)indexes withTuijian_members:(NSArray<CDMember *> *)values;
- (void)addTuijian_membersObject:(CDMember *)value;
- (void)removeTuijian_membersObject:(CDMember *)value;
- (void)addTuijian_members:(NSOrderedSet<CDMember *> *)values;
- (void)removeTuijian_members:(NSOrderedSet<CDMember *> *)values;

@end

NS_ASSUME_NONNULL_END
