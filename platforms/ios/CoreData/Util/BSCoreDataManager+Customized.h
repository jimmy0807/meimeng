//
//  BSCoreDataManager+Customized.h
//  Boss
//
//  Created by jimmy on 15/5/11.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSCoreDataManager.h"
#import "CDImageCache.h"
#import "CDStore.h"
#import "CDUser.h"
#import "CDMetric.h"
#import "CDProvider.h"  
#import "CDStorage.h"
#import "CDPermission.h"
#import "CDPermissionModel.h"
#import "CDStaff+CoreDataClass.h"
#import "CDPurchaseOrder.h"
#import "CDProjectUomCategory.h"
#import "CDProjectUom.h"

#import "CDBornCategory+CoreDataClass.h"
#import "CDProjectTemplate+CoreDataClass.h"
#import "CDProjectItem+CoreDataClass.h"

#import "CDProjectCategory+CoreDataClass.h"
#import "CDProjectRelated.h"
#import "CDProjectConsumable+CoreDataClass.h"
#import "CDProjectCheck+CoreDataClass.h"
#import "CDProjectAttribute.h"
#import "CDProjectAttributeValue.h"
#import "CDProjectAttributePrice.h"
#import "CDProjectAttributeLine.h"
#import "CDAdvertisement.h"
#import "CDAdvertisementItem.h"
#import "CDStaffDepartment.h"
#import "CDStaffJob.h"
#import "CDPosConfig.h"
#import "CDPurchaseOrderLine.h"
#import "CDPurchaseOrderTax.h"
#import "CDPurchaseOrderMove.h"
#import "CDPurchaseOrderMoveDetail.h"
#import "CDPurchaseOrderMoveItem.h"
#import "CDMember+CoreDataClass.h"
#import "CDMemberCard.h"
#import "CDMemberPriceList.h"
#import "CDMyTodayInComeItem.h"
#import "CDTodayIncomeMain.h"
#import "CDTodayIncomeItem.h"
#import "CDPassengerFlow.h"
#import "CDPanDian.h"
#import "CDPanDianItem.h"
#import "CDWarehouse.h"
#import "CDPOSPayMode+CoreDataClass.h"
#import "CDMemberCardArrears.h"
#import "CDMemberCardProject.h"
#import "CDStaffRole.h"
#import "CDMessage.h"
#import "CDPosOperate+CoreDataClass.h"
#import "CDPosOperatePayInfo.h"
#import "CDPosProduct+CoreDataClass.h"
#import "CDPosMonthIncome.h"
#import "CDPosConsumeProduct.h"
#import "CDCouponCard.h"
#import "CDCouponCardProduct+CoreDataClass.h"
#import "CDPosCommission.h"
#import "CDCurrentUseItem+CoreDataClass.h"
#import "CDPosCouponProduct.h"
#import "CDPosCoupon.h"
#import "CDBook+CoreDataClass.h"
#import "CDRestaurantFloor.h"
#import "CDRestaurantTable.h"
#import "CDMemberQinyou.h"
#import "CDMemberTezheng.h"
#import "CDCardTemplate.h"
#import "CDCardTemplateProduct.h"
#import "CDMemberTitle.h"
#import "CDMemberCardAmount.h"
#import "CDMemberCardPoint.h"
#import "CDMemberCardConsume.h"
#import "CDWePosTran.h"
#import "CDComment.h"
#import "CDCommentType.h"
#import "CDExtend.h"
#import "CDMemberChangeShop.h"
#import "CDMemberCallRecord.h"
#import "CDMemberFollow.h"
#import "CDMemberFollowProduct.h"
#import "CDWXCardTemplate.h"
#import "CDMemberFollowContent.h"
#import "CDMemberFollowPeroid.h"
#import "CDMessageTemplate.h"
#import "CDRestaurantTableUse.h"
#import "CDMemberFeedback.h"
#import "CDCommissionRule+CoreDataClass.h"
#import "CDMemberSource+CoreDataClass.h"
#import "CDPartner+CoreDataClass.h"
#import "CDStaff+CoreDataProperties.h"
#import "CDKeShi+CoreDataProperties.h"
#import "CDKeshiRemarks+CoreDataProperties.h"
#import "CDWorkFlowActivity+CoreDataProperties.h"
#import "CDYimeiImage+CoreDataProperties.h"
#import "CDOperateActivity+CoreDataProperties.h"
#import "CDMessageRecord+CoreDataClass.h"
#import "CDStaffLocalName+CoreDataProperties.h"
#import "CDYimeiBuwei+CoreDataClass.h"

#import "CDHCustomer+CoreDataClass.h"
#import "CDHZixun+CoreDataProperties.h"
#import "CDHFenzhen+CoreDataProperties.h"
#import "CDHJiaoHao+CoreDataProperties.h"
#import "CDMemberVisit+CoreDataProperties.h"
#import "CDHBinglika+CoreDataProperties.h"
#import "CDHHuizhen+CoreDataProperties.h"
#import "CDHShoushu+CoreDataProperties.h"
#import "CDHShoushuLine+CoreDataClass.h"
#import "CDZixunRoom+CoreDataClass.h"
#import "CDZixunBook+CoreDataClass.h"
#import "CDZixunRoomPerson+CoreDataClass.h"
#import "CDZixun+CoreDataClass.h"
#import "CDZongkongShoushuRoom+CoreDataProperties.h"
#import "CDZongkongShoushuCustomer+CoreDataProperties.h"
#import "CDQuestion+CoreDataProperties.h"
#import "CDQuestionResult+CoreDataProperties.h"
#import "CDQuestionResultItem+CoreDataProperties.h"
#import "CDZongkongDoctorPerson+CoreDataProperties.h"
#import "CDZongkongDoctorCustomer+CoreDataProperties.h"
#import "CDZongkongLiyuanPerson+CoreDataProperties.h"
#import "CDZongkongLiyuanItem+CoreDataProperties.h"
#import "CDPosWashHand+CoreDataProperties.h"
#import "CDYimeiHistory+CoreDataProperties.h"
#import "CDYimeiHistoryBuyItem+CoreDataProperties.h"
#import "CDYimeiHistoryConsumeItem+CoreDataProperties.h"
#import "CDHJiaoHaoWorkflow+CoreDataProperties.h"
#import "CDMedicalItem+CoreDataProperties.h"
#import "CDHHuizhenCategory+CoreDataProperties.h"
#import "CDHGuadan+CoreDataProperties.h"
#import "CDHGuadanProduct+CoreDataProperties.h"
#import "CDH9SSAP+CoreDataProperties.h"
#import "CDH9SSAPEvent+CoreDataProperties.h"
#import "CDH9Notify+CoreDataProperties.h"
#import "CDH9ShoushuTag+CoreDataProperties.h"
#import "CDTeam+CoreDataProperties.h"
#import "CDHFetchResult+CoreDataProperties.h"

#import "CDBingfangRoom+CoreDataProperties.h"
#import "CDBingfangRoomPerson+CoreDataProperties.h"
#import "CDBingFangBook+CoreDataProperties.h"

typedef enum HPatientListType
{
    HPatientListType_Today,
    HPatientListType_Recent,
    HPatientListType_Wait,
    HPatientListType_ALL
}HPatientListType;

typedef enum YimeiWorkFlow
{
    YimeiWorkFlow_CraateOrder = 1,  //财务开单员
    YimeiWorkFlow_WashFace,         //洗脸操作员
    YimeiWorkFlow_TakePhoto,        //拍照操作员
    YimeiWorkFlow_Medical,          //敷麻药操作员
    YimeiWorkFlow_Dispatch,         //诊室分派员
    YimeiWorkFlow_Operate,          //诊室操作员
    YimeiWorkFlow_Fuzhujiancha,     //辅助检查
    YimeiWorkFlow_XiuxiFubing,      //休息敷冰
    YimeiWorkFlow_Peiyao,           //配药医生
}YimeiWorkFlow;

//0:新增 1:修改 2:删除
typedef enum kBSDataEditType
{
    kBSDataNone     = -1,
    kBSDataAdded    = 0,
    kBSDataUpdate   = 1,
    kBSDataDelete   = 2,
    kBSDataDeleteN  = 3,
    kBSDataLinked   = 4,
    kBSDataExist    = 6
}kBSDataEditType;

typedef enum kPadBornCategoryType
{
    kPadBornCategoryAll         = 0,
    kPadBornCategoryProduct     = 1,    // 产品
    kPadBornCategoryProject     = 2,    // 项目
    kPadBornCategoryCourses     = 3,    // 疗程
    kPadBornCategoryPackage     = 4,    // 套餐
    kPadBornFreeCombination     = 5,    // 定制组合
    kPadBornCategoryPackageKit  = 6,    // 套盒
    kPadBornCategoryCustomPrice = 999,   // 定制价格
    kPadBornCategoryCardItem     = 9999  // 卡内项目
}kPadBornCategoryType;

typedef enum kProjectItemType
{
    kProjectItemDefault,        // 产品项目
    kProjectItemConsumable,     // 项目消耗
    kProjectItemSubItem,        // 组合清单
    kProjectItemSameItem,       // 可替换项目
    kProjectItemPurchase,       // 可采购项目
    kProjectItemCardItem,       // 卡内项目
    kProjectItemCardBuyItem,    // 可购买项目
    kProjectItemPanDianItem,     // 盘点
    kProjectItemInput,        // 冲项目
    kProjectItemCailiao,        // 材料
}kProjectItemType;


typedef enum kPadMemberCardOperateType
{
    kPadMemberCardOperateCreate,        //开卡
    kPadMemberCardOperateRecharge,      //充值
    kPadMemberCardOperateInputItem,     //冲项目
    kPadMemberCardOperateRepayment,     //还款
    kPadMemberCardOperateExchange,      //退项目
    kPadMemberCardOperateRefund,        //退款(卡)
    kPadMemberCardOperateReplacement,   //换卡
    kPadMemberCardOperateBind,        //并卡
    kPadMemberCardOperateMerger,        //并卡
    kPadMemberCardOperateActive,        //激活
    kPadMemberCardOperateLost,          //挂失
    kPadMemberCardOperateUpgrade,       //卡升级
    kPadMemberCardOperateTurnStore,     //转店
    kPadMemberCardOperateRedeem,        //积分兑换
    kPadMemberCardOperateCashier,       //收银
    kPadMemberCardOperateBuy,            //购买
    kPadMemberCardOperateGuadanPay
}kPadMemberCardOperateType;

typedef enum kPadPayModeType
{
    kPadPayModeTypeCard,            // 会员卡
    kPadPayModeTypeCash,            // 现金支付
    kPadPayModeTypeBankCard,        // 银行卡支付
    kPadPayModeTypeWeChat,          // 微信支付
    kPadPayModeTypeAlipay,          // 支付宝
    kPadPayModeTypeCoupon,          // 微卡优惠券
    kPadPayModeTypeWeiXinCoupon,    // 微信优惠券
    kPadPayModeTypeOtherCoupon,     // 第三方卡券
    kPadPayModeTypePoint,           // 积分支付
    kPadPayModeTypeArrears,         // 欠款支付
}kPadPayModeType;




typedef enum kPadCardType
{
    kPadCardTypeMemberCard,         // 会员卡
    kPadCardTypeGiftCoupon,         // 礼品券
    kPadCardTypeGiftCard            // 礼品卡
}kPadCardType;

typedef enum kPadMemberCardStateType
{
    kPadMemberCardStateDraft,       // 草稿-draft
    kPadMemberCardStateActive,      // 已激活-active
    kPadMemberCardStateLost,        // 已挂失-lost
    kPadMemberCardStateReplacement, // 已换卡-replacement
    kPadMemberCardStateMerger,      // 已并卡-merger
    kPadMemberCardStateUnlink       // 已取消-unlink
}kPadMemberCardStateType;

typedef enum kPadCouponCardStateType
{
    kPadCouponCardStateDraft,       // 草稿-draft
    kPadCouponCardStatePublished,   // 已发布-published
    kPadCouponCardStateActive,      // 已激活-active
    kPadCouponCardStateUsed,        // 已核销-used
    kPadCouponCardStateInvalid,     // 无效-invalid
    kPadCouponCardStateUnlink       // 已删除-unlink
}kPadCouponCardStateType;

typedef enum kPadOrderType
{
    kPadOrderFromPos,
    kPadOrderFromPad
}kPadOrderType;

typedef enum kPadOrderState
{
    kPadOrderDraft,     // draft
    kPadOrderSubmit,    // submit
    kPadOrderConfirm,   // confirm
    kPadOrderCheckout   // checkout
}kPadOrderState;

typedef enum kPadUseItemType
{
    kPadUseItemPurchasing,
    kPadUseItemCurrentPurchase,
    kPadUseItemMemberCardProject,
    kPadUseItemCouponCardProject
}kPadUseItemType;

typedef enum kPadRestaurantTableState
{
    kPadRestaurantTableStateIdle,       // 空闲
    kPadRestaurantTableStateUsing,      // 使用中
    kPadRestaurantTableStateBook,       // 被预定
    kPadRestaurantTableStateDisable     // 不可用
}kPadRestaurantTableState;

@interface BSCoreDataManager (Customized)

- (NSString *)fetchLastUpdateTimeWithEntityName:(NSString *)entityName;
- (NSString *)fetchPermissionLastUpdateTime;
- (NSString *)fetchPermissionModelLastUpdateTime;
- (CDTodayIncomeMain*)fetchTodayIncomeDetail;
- (NSArray*)fetchHomePassengerFlowDetail;
- (NSArray*)fetchHomeMyTodayIncomeDetail;

- (NSArray *)fetchAllStoreList;
- (NSArray *)fetchStoreListWithShopID:(NSArray *)shopId;
- (NSArray *)fetchAllUser;
- (NSArray *)fetchAllUserWithStartDate:(NSString *)startDate endDate:(NSString *)endDate;
- (NSArray *)fetchChangedUsersWithCurrentUserID:(NSNumber *)userId;

- (NSArray *)fetchAllPermissionModels;
- (NSArray *)fetchAllPermissions;

#pragma mark - Staff 员工
- (NSArray<CDStaff *> *_Nonnull)fetchAllStaffs;
- (NSArray<CDStaff *> *_Nonnull)fetchStaffsWithShopID:(NSNumber *)shopID;
- (NSArray<CDStaff *> *_Nonnull)fetchGuwenStaffsWithShopID:(NSNumber *)shopID;
- (NSArray<CDStaff *> *_Nonnull)fetchShejizongjianStaffsWithShopID:(NSNumber *)shopID;
- (NSArray<CDStaff *> *_Nonnull)fetchStaffsWithShopID:(NSNumber *)shopID need_role_id:(bool)need_role_id;
- (NSArray *)fetchAllStaffJobs;
- (NSArray *)fetchAllStaffDepartments;
- (NSArray *)fetchAllStaffRoles;


#pragma mark -
#pragma mark PosConfig Methods

- (NSArray *)fetchAllPosConfig;


#pragma mark -
#pragma mark Restaurant Methods

- (NSArray *)fetchAllRestaurantFloor;
- (NSArray *)fetchAllRestaurantTable;
- (NSArray *)fetchRestaurantTableWithFloor:(CDRestaurantFloor*)floor;
- (NSArray *)fetchRestaurantTableUseWithBookIds:(NSArray *)bookIds;

#pragma mark -
#pragma mark Project Methods

- (NSArray *)fetchAllBornCategory;
- (NSArray *)fetchAllProjectCategory;
- (NSArray *)fetchAllTopProjectCategory;
- (NSArray *)fetchTopProjectCategory;
- (NSArray *)fetchAllProjectUomCategory;
- (NSArray *)fetchAllProjectUom;
- (NSArray *)fetchAllProjectRelated;
- (NSArray *)fetchAllProjectConsumable;
- (NSArray *)fetchAllProjectCheck;
- (NSArray *)fetchAllProjectAttribute;
- (NSArray *)fetchAllProjectAttributeValue;
- (NSArray *)fetchAllProjectAttributePrice;
- (NSArray *)fetchAllProjectAttributeLine;
- (NSArray *)fetchConsumeProduct;
//根据templateId获取消耗品
-(NSArray*)fetchConsumeProductWithTemplateId:(NSInteger*)templateId;
//获取
- (NSArray*)fetchConsumableRelatedProject;
#pragma mark -
#pragma mark ProjectTemplate && ProjectItem
- (NSArray *)fetchAllProjectTemplate;
- (NSArray *)fetchAllLastUpdateProjectTemplate:(NSString *)lastUpdate;
/**
 *
 *  @param bornCategorys 产品分类
 *  @param categoryIds   分类子标题
 *  @param keyword       搜索关键字
 *  @param ascending     价格排序
 */
- (NSArray *)fetchProjectTemplatesWithBornCategorys:(NSArray *)bornCategorys categoryIds:(NSArray *)categoryIds keyword:(NSString *)keyword priceAscending:(BOOL)ascending;

- (NSArray *)fetchAllProjectItem;
- (NSArray *)fetchAllLastUpdateProjectItem:(NSString *)lastUpdate;
- (NSArray *)fetchProjectItemsWithType:(kProjectItemType)type bornCategorys:(NSArray *)bornCategorys categoryIds:(NSArray *)categoryIds existItemIds:(NSArray *)itemIds keyword:(NSString *)keyword priceAscending:(BOOL)ascending;
- (NSArray *)fetchPrescriptionsItems;
- (NSArray *)fetchProjectItemsWithGroup:(NSString*)group;

#pragma mark -
#pragma mark Member

- (NSArray *)fetchAllMemberCard;
- (NSArray *)fetchMemberCardWithIDs:(NSArray*)ids;
- (NSArray *)fetchMemberCardWithMemberID:(NSNumber *)memberId;
- (NSArray *)fetchAllMemberCardProject;

//会员卡内项目
- (NSArray *)fetchCardProjectsWithMemberCardID:(NSNumber *)cardID;

- (NSArray *)fetchCardProjectsWithProjectIds:(NSArray *)projectIds;
//购买项目
- (NSArray *)fetchbuyProjectsWithMemberCardID:(NSNumber *)cardID;

//会员项目
- (NSArray *)fetchMemberProductsWithMemberID:(NSNumber *)memberID;
- (NSFetchedResultsController *)fetchMemberProductCategoryWithMemberID:(NSNumber *)memberID;
- (NSFetchedResultsController *)fetchMemberProductDateWithMemberID:(NSNumber *)memberID;

- (NSArray *)fetchAllMemberCardExchange;
- (NSArray *)fetchAllCouponCard;
- (NSArray *)fetchCouponCardWithIds:(NSArray *)ids;
- (NSArray *)fetchCouponCardWithMemberId:(NSNumber *)memberId;
- (NSArray *)fetchAllCouponCardProduct;
- (NSArray *)fetchAllCouponCardProductsWithCouponId:(NSNumber *)couponId;
- (NSArray *)fetchCouponCardProductsWithProductIds:(NSArray *)productIds;
- (NSArray *)fetchAllMemberCardArrears;

- (NSArray *)fetchAllMember;
- (NSArray *)fetchAllMemberWithStoreID:(NSNumber *)storeID;
- (NSArray *)fetchAllMemberWithStoreID:(NSNumber *)storeID keyword:(NSString *)keyword;

- (NSArray *)fetchAllMemberWithStoreID:(NSNumber *)storeID guwenID:(NSNumber *)guwenID;
- (NSArray *)fetchAllMemberWithStoreID:(NSNumber *)storeID keyword:(NSString *)keyword guwenID:(NSNumber *)guwenID;

- (NSArray *)fetchAllMemberWithStoreID:(NSNumber *)storeID isTiYan:(BOOL)isTiYan guwenID:(NSNumber *)guwenID;
- (NSArray *)fetchWevipMembersWithStoreID:(NSNumber *)storeID;

- (NSArray *)fetchMemberTezhengWithMember:(CDMember *)member;
- (NSArray *)fetchMemberSource;
- (NSArray *)fetchPartner;
- (NSArray *)fetchPartnerWithKeyWord:(NSString*)keyword;
- (NSArray *)fetchPartner:(NSString*)partner_category;
- (NSArray *)fetchMemberFeedbackWithMember:(CDMember *)member;
- (NSArray *)fetchMemberQinyouWithMember:(CDMember *)member;

- (NSArray *)fetchMemberRecordsWithStoreID:(NSNumber *)storeID;


- (NSArray *)fetchMemberFollowsWithMember:(CDMember *)member;
- (NSArray *)fetchMemberFollowProductsWithFollow:(CDMemberFollow *)follow;
- (NSArray *)fetchMemberFollowContentsWithFollow:(CDMemberFollow *)follow;
- (NSArray *)fetchMemberFollowPeriodsWithMonth:(NSInteger)month;

- (NSArray *)fetchExtends;

- (NSArray *)fetchMemberMessagesWithType:(NSString *)type;
- (NSArray *)fetchMemberMessageRecords;

/* 评论 */
-(NSArray *)fetchCommentsWithMember:(CDMember *)memebr;
-(NSArray *)fetchCommentType;

/* 积分 */
- (NSArray *)fetchCardPointsWithCardID:(NSNumber *)cardID;
- (NSArray *)fetchCardPointsWithMemberID:(NSNumber *)memberID;

/* 操作 */
- (NSArray *)fetchCardOperatesWithCardID:(NSNumber *)cardID;
- (NSArray *)fetchCardOperatesWithMemberID:(NSNumber *)memberID;

/* 消费 */
- (NSArray *)fetchCardConsumesWithCardID:(NSNumber *)cardID;
- (NSArray *)fetchCardConsumesWithMemberID:(NSNumber *)memberID;

/* 金额变动 */
- (NSArray *)fetchCardAmountsWithCardID:(NSNumber *)cardID;
- (NSArray *)fetchCardAmountsWithMemberID:(NSNumber *)memberID;

/* 欠款还款 */
- (NSArray *)fetchCardArrearsWithCardID:(NSNumber *)cardID;
- (NSArray *)fetchCardArrearsWithMemberID:(NSNumber *)memberID;


/* 转店履历 */
- (NSArray *)fetchChangeShopRecordsWithMember:(CDMember *)member;


- (NSString *)operateType:(NSString *)type;

#pragma mark - PurchaseOrder 采购订单
//PurchaseOrder 采购订单

- (NSArray *)fetchAllProviders;
- (NSArray *)fetchAllStoreages;
- (NSArray *)fetchAllWarehouses;

- (NSArray *)fetchPurchaseOrdersWithState:(NSString *)state;
- (NSArray *)fetchPurchaseMoveOrdersWithOrigin:(NSString *)origin;
- (NSArray *)fetchPurchaseMoveOrderItemsWithItemIds:(NSArray *)item_ids;
- (NSArray *)fetchPurchaseOrderTaxs;

#pragma mark - PurchaseOrder 仓库
//Stock 仓库
- (NSArray *)fetchPanDiansWithState:(NSString *)state;
- (NSArray *)fetchPanDianItemsWithIds:(NSArray *)item_ids;

#pragma mark -
#pragma mark POS
- (NSArray *)fetchAllPriceList;
- (NSArray*)fetchCanUsePriceList;
- (NSArray *)fetchPOSPayMode;
- (NSArray *)fetchPOSPayModeSortByMode;
- (NSString*)calculateMemberCardBuyPrice:(CDMemberCardProject*)project;


#pragma mark - 
#pragma mark - PadPosCardOperate PadPos操作单据

- (NSArray *)fetchAllPadOrder;
- (NSArray *)fetchPosOperates;
- (NSArray *)fetchLocalPosOperates:(NSString*)sortKey;
- (NSArray *)fetchTakeoutPosOperates:(NSString *)sortKey;
- (NSArray *)fetchHistoryPosOperatesByType:(NSString*)type storeID:(NSNumber*)storeID;
- (NSArray *)fetchHistoryPosOperatesByKeyword:(NSString*)keyword;
- (NSFetchedResultsController *)fetchHistoryPosOprerateResultControllerByType:(NSString *)type storeID:(NSNumber *)storeID;
- (NSArray *)fetchHistoryPosMonthIncome;
- (NSFetchedResultsController *)fetchHistoryPosMonthIncomeResultsController;

- (NSArray *)fetchPosCommissionWithOperateID:(NSNumber *)operateID productID:(NSNumber *)productID;

- (NSArray *)fetchCommissionRules; //提成方案

//pos产品
- (NSArray *)fetchPosProductsWithOperate:(CDPosOperate *)operate;
- (NSArray *)fetchPosProductsWithOperateIds:(NSArray *)operateIds;
//pos消费项目
- (NSArray *)fetchConsumeProductsWithOperate:(CDPosOperate *)operate;
//pos消费项目中的卡扣项目
- (NSArray *)fetchConsumeProductsInCardWithOperate:(CDPosOperate *)operate;
//优惠券项目
- (NSArray *)fetchPosCouponProductsWithOPerate:(CDPosOperate *)operate;
//会员卡项目
- (NSArray *)fetchPosMemberCardProductWithOperate:(CDPosOperate *)operate;

#pragma mark - pad 预约
- (NSArray *)fetchAllBooks;
- (NSArray *)fetchTodayBooks;
- (NSArray *)fetchHomeTodayBooks;
- (NSArray *)fetchBooksWithLastUpdateTime:(NSString *)updateTime;
- (NSArray *)fetchBooksWithDay:(NSString *)day;

//技师
- (NSArray *)fetchBooksWithTechnician:(CDStaff *)staff;
- (NSArray *)fetchBooksWithTechnician:(CDStaff *)staff day:(NSString *)day;
- (NSArray *)fetchLatestBooksWithTechnician:(CDStaff *)staff;

//楼层
- (NSArray *)fetchBooksWithTable:(CDRestaurantTable *)table;
- (NSArray *)fetchBooksWithTable:(CDRestaurantTable *)table day:(NSString *)day;
- (NSArray *)fetchLatestBooksWithTable:(CDRestaurantTable *)table;

//判断这个时段是否有重合的预约
- (NSArray *)fetchIntersectBooksWithBook:(CDBook *)book;
- (NSArray *)fetchIntersectRoomBooksWithBook:(CDBook *)book;
- (NSArray *)fetchIntersectTechBooksWithBook:(CDBook *)book;

- (NSArray *)fetchBookStaffs;


#pragma mark - pad 送卡券
- (NSFetchedResultsController *)fetchCardTemplates;
- (NSArray *)fetchCardTemplatesWithType:(NSInteger)type;
- (NSArray *)fetchCardTemplateProducts:(CDCardTemplate *)cardTemplate;

#pragma mark - pad 微信卡券
- (NSArray *)fetchWXCardTemplatesList;

#pragma mark -
#pragma mark Message
- (NSArray*)fetchAllMessage;
- (NSArray*)fetchUnReadMessage;
- (NSArray*)fetchUnSendMessage;
- (NSString *)fetchMessageLastCreateTime;

- (NSArray*)fetchWePosTranWithMonth:(NSString*)yearmonth phoneNumber:(NSString*)phoneNumber;

//医美
- (NSArray *)fetchALLKeshi;
- (NSArray *)fetchKeshiRemark;
- (NSArray *)fetchTopKeshi;
- (NSArray *)fetchChildKeshi:(CDKeShi*)parent;

- (NSArray *)fetchALLWorkFlowActivity;
- (NSArray *)fetchSortedWorkFlowActivity;
- (NSArray *)fetchYimeiPosOperates:(NSNumber*)workID;
- (NSInteger)fetchYimeiRoleOptionWithWorkID:(NSNumber*)workID;
- (NSArray<CDStaff *> *_Nonnull)fetchShejishiStaffsWithShopID:(NSNumber *)shopID;
- (NSArray<CDStaff *> *_Nonnull)fetchDoctorStaffsWithShopID:(NSNumber *)shopID;
- (NSArray<CDStaff *> *_Nonnull)fetchOperateStaffsWithShopID:(NSNumber *)shopID;

- (NSArray<CDTeam *> *)fetchAllShoushuTeam;

//医院
- (NSArray *)fetchAllCustomer;
- (NSArray *)fetchAllCustomerWithStoreID:(NSNumber *)storeID;
- (NSArray *)fetchAllCustomerWithStoreID:(NSNumber *)storeID keyword:(NSString *)keyword;

- (NSArray *)fetchAllHZixun:(NSString*)categoryName;
- (NSArray *)fetchAllHZixunWithStoreID:(NSNumber *)storeID categoryName:(NSString*)categoryName;
- (NSArray *)fetchAllHZixunWithStoreID:(NSNumber *)storeID keyword:(NSString *)keyword categoryName:(NSString*)categoryName;
- (NSArray *)fetchAllFenzhen;
- (NSArray *)fetchAllFenzhenWithStoreID:(NSNumber *)storeID;
- (NSArray *)fetchAllFenzhenWithStoreID:(NSNumber *)storeID keyword:(NSString *)keyword;

- (NSArray *)fetchAllJiaoHao:(NSString*)keyword isDepart:(BOOL)isDepart isFinish:(BOOL)isFinish isPrint:(BOOL)isPrint;
- (NSArray *)fetchAllPatientWithKeyword:(NSString*)keyword type:(HPatientListType)type isMyPatient:(BOOL)isMyPatient;
- (NSArray<NSDictionary *> *)fetchMemberVisit:(NSString*)category keyword:(NSString*)keyword;


//咨询
- (NSArray<CDZixunBook *> *_Nonnull)fetchAllZixunBook;
- (NSArray<CDZixunBook *> *_Nonnull)fetchDaodianZixunBook:(nullable NSString*)keyword;
- (NSArray<CDZixunBook *> *_Nonnull)fetchDaodianZixunBook1:(nullable NSString*)keyword;
- (NSArray<CDZixunBook *> *_Nonnull)fetchDaodianZixunBook2:(nullable NSString*)keyword;
- (NSArray<CDBingFangBook *> *_Nonnull)fetchAllBingfangBook;
- (NSArray<CDBingFangBook *> *_Nonnull)fetchDaodianBingfangBook:(nullable NSString*)keyword;
- (NSArray<CDBingFangBook *> *_Nonnull)fetchDaodianBingfangBook1:(nullable NSString*)keyword;
- (NSArray<CDBingFangBook *> *_Nonnull)fetchDaodianBingfangBook2:(nullable NSString*)keyword;

- (NSArray<CDZixunBook *> *_Nonnull)fetchYuyueZixunBook:(nullable NSString*)keyword;
- (NSArray<CDBingFangBook *> *_Nonnull)fetchYuyueBingfangBook:(nullable NSString*)keyword;

- (NSArray<CDZixunRoom *> *_Nonnull)fetchAllZixunRoom;
- (NSArray<CDBingfangRoom *> *_Nonnull)fetchAllBingfangRoom;
- (NSArray<CDZixun *> *_Nonnull)fetchAllZixunWithType:(nullable NSString *)type keyword:(nullable NSString *)keyword memberID:(nullable NSNumber*)memberID zixunID:(nullable NSNumber*)zixunID;
- (NSArray<CDQuestion *> *_Nonnull)fetchAllQuestion;
- (CDQuestion*)fetchFirstQuestion;
- (CDQuestion*)fetchQuestionWithQuestionID:(NSNumber*)questionID;
- (NSArray<CDQuestionResult *> *_Nonnull)fetchAllQuestionResult;
- (CDQuestionResult*)fetchQuestionResultWith:(NSNumber*)resultID;
- (NSArray<CDZongkongShoushuRoom *> *_Nonnull)fetchAllZongkongRoom;
- (NSArray<CDZongkongLiyuanPerson *> *_Nonnull)fetchAllZongkongLiyuanPersons;
- (NSArray<CDZongkongDoctorPerson *> *_Nonnull)fetchAllDoctorPerson;

- (NSArray<CDPosWashHand *> *_Nonnull)fetchAllWashHandWithID:(nullable NSNumber *)workID keyword:(nullable NSString *)keyword isDone:(BOOL)isDone;

- (NSArray<CDYimeiHistory *> *_Nonnull)fetchYimeiHistoryByKeyword:(nullable NSString*)keyword;

- (NSArray<CDHHuizhenCategory *> *_Nonnull)fetchAllHuizhenCategory;
- (NSArray<CDHHuizhenCategory *> *_Nonnull)fetchAllTopHuizhenCategory;
- (NSArray<CDHGuadan *> *_Nonnull)fetchAllGuadan:(nullable NSString*)keyword;

- (NSArray<CDH9SSAP *> *_Nonnull)fetchH9SSAP:(nullable NSString *)dateString;
- (NSArray<CDH9SSAPEvent *> *_Nonnull)fetchH9SSAPDetail:(nullable NSString *)dateString;
- (NSArray<CDHFetchResult *> *_Nonnull)fetchH9SSAPSearchResult;

- (NSArray<CDH9Notify *> *_Nonnull)fetchH9Notify:(nullable NSString *)read;//read unread nil

- (NSArray<CDH9ShoushuTag *> *_Nonnull)fetchH9Shoushutag:(NSString*)keyword;
- (void)DeleteH9Shoushutag:(nullable NSArray*)ids;

@end
