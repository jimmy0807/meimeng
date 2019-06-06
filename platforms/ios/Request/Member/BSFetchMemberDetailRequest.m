//
//  BSFetchMemberDetailRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/11/13.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSFetchMemberDetailRequest.h"
#import "ChineseToPinyin.h"
#import "BSFetchMemberCardRequest.h"
#import "BSFetchCouponCardRequest.h"
#import "BSFetchMemberQinyouRequest.h"
#import "BSFetchMemberTezhengRequest.h"
#import "BSFetchOperateRequest.h"

@interface BSFetchMemberDetailRequest ()

@property (nonatomic, strong) CDMember *member;

@end

@implementation BSFetchMemberDetailRequest

- (id)initWithMember:(CDMember *)member
{
    self = [super init];
    if (self)
    {
        self.member = member;
    }
    
    return self;
}

- (BOOL)willStart
{
    //self.needCompany = true;
    self.tableName = @"born.member";
    self.filter = @[@[@"id", @"=", self.member.memberID]];
    self.field = @[@"id", @"name", @"no", @"state", @"mobile", @"gender", @"birth_date", @"email", @"write_date", @"is_vip_customer", @"is_default_customer", @"company_id", @"shop_id", @"member_ids", @"coupon_ids", @"title", @"qq", @"wx", @"id_card_no", @"state_id", @"area_id", @"subdivide_id", @"street", @"operate_ids",@"extended_ids",@"relatives_ids",@"amount",@"course_arrears_amount",@"arrears_amount",@"product_all_ids",@"technician_id",@"category",@"recommend_type",@"referee_name",@"employee_id",@"sign_date",@"feedback_ids",@"designers_id",@"member_type",@"director_employee_id"];
    NSArray *params = [NSArray array];
    [self sendShopAssistantXmlSearchReadCommand:params];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    PersonalProfile* profile = [PersonalProfile currentProfile];
    
    if ([resultList isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *params in resultList)
        {
            NSNumber *memberID = [params objectForKey:@"id"];
            CDMember *member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:memberID forKey:@"memberID"];
            if(member == nil)
            {
                member = [[BSCoreDataManager currentManager] insertEntity:@"CDMember"];
                member.memberID = memberID;
            }
            member.memberNo = [params onlyStringValueForKey:@"no"];
            member.memberName = [params stringValueForKey:@"name"];
            member.isWevipCustom = [params numberValueForKey:@"is_vip_customer"];
            member.isDefaultCustomer = [params numberValueForKey:@"is_default_customer"];
            member.memberNameLetter = [ChineseToPinyin pinyinFromChiniseString:member.memberName];
            member.memberNameFirstLetter = [[ChineseToPinyin pinyinFirstLetterString:member.memberName] uppercaseString];
            member.yimei_member_type = [params stringValueForKey:@"member_type"];
            
            if (member.isDefaultCustomer.boolValue)
            {
                member.memberNameSingleLetter = @"0";
            }
            else
            {
                if (member.memberNameFirstLetter.length != 0)
                {
                    NSString *singleLetter = [member.memberNameFirstLetter substringToIndex:1];
                    if ([ChineseToPinyin isFirstLetterValidate:singleLetter])
                    {
                        member.memberNameSingleLetter = singleLetter;
                    }
                    else
                    {
                        member.memberNameSingleLetter = @"a";
                    }
                }
                else
                {
                    member.memberNameSingleLetter = @"a";
                }
            }
            member.imageName = [NSString stringWithFormat:@"%@_%@",memberID, member.memberName];
            member.mobile = [params onlyStringValueForKey:@"mobile"];
            member.email = [params onlyStringValueForKey:@"email"];
            member.gender = [params onlyStringValueForKey:@"gender"];
            member.birthday = [params onlyStringValueForKey:@"birth_date"];
            member.lastUpdate = [params stringValueForKey:@"write_date"];
            member.member_qq = [params onlyStringValueForKey:@"qq"];
            member.member_wx = [params onlyStringValueForKey:@"wx"];
            member.idCardNumber = [params onlyStringValueForKey:@"id_card_no"];
            member.member_sign_date = [params stringValueForKey:@"sign_date"];
            member.amount = [params numberValueForKey:@"amount"];
            member.arrearsAmount = [params stringValueForKey:@"course_arrears_amount"];
            member.courseArrearsAmount = [params stringValueForKey:@"arrears_amount"];
            
            NSArray *product_all_ids = [params arrayValueForKey:@"product_all_ids"];
            if (product_all_ids.count > 0) {
                member.product_all_ids = [product_all_ids componentsJoinedByString:@","];
            }
           
            
            if ([[params arrayNameValueForKey:@"state_id"] isEqualToString:[params arrayNameValueForKey:@"area_id"]])
            {
                member.member_address = [NSString stringWithFormat:@"%@%@%@", [params arrayNameValueForKey:@"area_id"], [params arrayNameValueForKey:@"subdivide_id"], [params onlyStringValueForKey:@"street"]];
            }
            else
            {
                member.member_address = [NSString stringWithFormat:@"%@%@%@%@", [params arrayNameValueForKey:@"state_id"], [params arrayNameValueForKey:@"area_id"], [params arrayNameValueForKey:@"subdivide_id"], [params stringValueForKey:@"street"]];
            }
            
            NSArray *operateIds = [params arrayValueForKey:@"operate_ids"];
            NSMutableArray *mutableArray = [NSMutableArray array];
            if ([operateIds isKindOfClass:[NSArray class]] && operateIds.count != 0)
            {
                for (int i = 0; i < operateIds.count; i++)
                {
                    if ( ![profile.isYiMei boolValue] )
                    {
                        if (i < 5)
                        {
                            [mutableArray addObject:[operateIds objectAtIndex:i]];
                        }
                        else
                        {
                            break;
                        }
                    }
                    else
                    {
                        [mutableArray addObject:[operateIds objectAtIndex:i]];
                    }
                }
            }
            
            if (mutableArray.count != 0 && DEVICE_IS_IPAD && !self.onlyMemberInfo )
            {
                BSFetchOperateRequest *request = [[BSFetchOperateRequest alloc] initWithMember:self.member recentOperateIds:mutableArray];
                [request execute];
            }
           
            NSString *feilei = [params stringValueForKey:@"category"];
            if ([feilei isEqualToString:@"personal"]) {
                feilei = @"个人";
            }
            else if ([feilei isEqualToString:@"team"])
            {
                feilei = @"团队";
            }
            else if ([feilei isEqualToString:@"company"])
            {
                feilei = @"公司";
            }
            member.member_fenlei = feilei;

            if ([[params stringValueForKey:@"state"] isEqualToString:@"done"])
            {
                member.isAcitve = @(TRUE);
            }
            else
            {
                member.isAcitve = @(FALSE);
            }
            
            //会员特征
            NSArray *tz = [params arrayValueForKey:@"extended_ids"];
            NSMutableOrderedSet *tezhengs = [NSMutableOrderedSet orderedSet];
            for (NSNumber *tz_id in tz) {
                CDMemberTeZheng *tengZheng = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDMemberTeZheng" withValue:tz_id forKey:@"tz_id"];
                [tezhengs addObject:tengZheng];
            }
            member.tezhengs = tezhengs;
            member.member_tz_count = @(tz.count);
            
            
            //护理反馈
            NSArray *feedback_ids = [params arrayValueForKey:@"feedback_ids"];
            NSMutableOrderedSet *feedbacks = [NSMutableOrderedSet orderedSet];
            
            for (NSNumber *feedback_id in feedback_ids) {
                CDMemberFeedback *feedback = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDMemberFeedback" withValue:feedback_id forKey:@"feedback_id"];
                [feedbacks addObject:feedback];
            }
            self.member.feedbacks = feedbacks;
            
            
            //亲友
            NSArray *qy = [params arrayValueForKey:@"relatives_ids"];
            NSMutableOrderedSet *qinyous = [NSMutableOrderedSet orderedSet];
            for (NSNumber *qy_id in qy) {
                CDMemberQinyou *qinyou = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDMemberQinyou" withValue:qy_id forKey:@"qy_id"];
                [qinyous addObject:qinyou];
            }
            member.qinyous = qinyous;
            member.member_qy_count = @(qy.count);
            
            
            //职位
            member.member_title_id = [params arrayIDValueForKey:@"title"];
            member.member_title_name = [params arrayNameValueForKey:@"title"];
            if ([member.member_title_id integerValue] > 0) {
                CDMemberTitle *title = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDMemberTitle" withValue:member.member_title_id forKey:@"title_id"];
                title.title_id = member.member_title_id;
                title.title_name = member.member_title_name;
            }
            
            
            //推荐人(会员)
            member.member_tuijian_vip_id = [params arrayIDValueForKey:@"recommend_type"];
            member.member_tuijian_vip_name = [params arrayNameValueForKey:@"recommend_type"];
            if ([member.member_tuijian_vip_id integerValue] > 0) {
                CDMember *tuijianer = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDMember" withValue:member.member_tuijian_vip_id forKey:@"memberID"];
                tuijianer.memberName = member.member_tuijian_vip_name;
                
                member.member_tuijian = tuijianer;
            }

            //推荐人(员工)
            member.member_tuijian_staff_id = [params arrayIDValueForKey:@"referee_name"];
            member.member_tuijian_staff_name = [params arrayNameValueForKey:@"referee_name"];
            if ([member.member_tuijian_staff_id integerValue] > 0) {
                CDStaff *tuijian_staff = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDStaff" withValue:member.member_tuijian_vip_id forKey:@"staffID"];
                tuijian_staff.name = member.member_tuijian_staff_name;
                member.staff_tuijian = tuijian_staff;
            }
            
            //顾问
            member.member_guwen_id = [params arrayIDValueForKey:@"employee_id"];
            member.member_guwen_name = [params arrayNameValueForKey:@"employee_id"];
            
            member.member_shejishi_id = [params arrayIDValueForKey:@"designers_id"];
            member.member_shejishi_name = [params arrayNameValueForKey:@"designers_id"];
            
            member.director_employee = [params arrayNameValueForKey:@"director_employee_id"];
            member.director_employee_id = [params arrayIDValueForKey:@"director_employee_id"];
            
            if ([member.member_guwen_id integerValue] > 0) {
                CDStaff *guwen = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDStaff" withValue:member.member_tuijian_vip_id forKey:@"staffID"];
                guwen.name = member.member_guwen_name;
                member.guwen = guwen;
            }
            
            //技师
            member.member_jishi_id = [params arrayIDValueForKey:@"technician_id"];
            member.member_jishi_name = [params arrayNameValueForKey:@"technician_id"];
            if ([member.member_jishi_id integerValue] > 0) {
                CDStaff *jishi = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDStaff" withValue:member.member_jishi_id forKey:@"staffID"];
                jishi.name = member.member_jishi_name;
                member.jishi = jishi;
            }
            
            
            //公司
            NSArray *company = [params objectForKey:@"company_id"];
            if ([company isKindOfClass:[NSArray class]] && company.count > 1)
            {
                member.companyID = [NSNumber numberWithInteger:[[company objectAtIndex:0] integerValue]];
                member.companyName = [company objectAtIndex:1];
            }
            
            //门店
            NSArray *shop = [params objectForKey:@"shop_id"];
            if ([shop isKindOfClass:[NSArray class]] && shop.count > 1)
            {
                NSNumber *storeID = [NSNumber numberWithInteger:[[shop objectAtIndex:0] integerValue]];
                member.storeID = storeID;
                member.storeName = [shop objectAtIndex:1];
                CDStore *store = [[BSCoreDataManager currentManager] findEntity:@"CDStore" withValue:storeID forKey:@"storeID"];
                if(!store)
                {
                    store = [[BSCoreDataManager currentManager] insertEntity:@"CDStore"];
                    store.storeID = member.storeID;
                    store.storeName = member.storeName;
                }
                member.store = store;
            }
            
            // 会员卡 / 券
            member.card = [NSOrderedSet orderedSet];
            member.coupons = [NSOrderedSet orderedSet];
            if (!member.isDefaultCustomer.boolValue)
            {
                NSArray *cardIds = [params objectForKey:@"member_ids"];
                NSMutableOrderedSet *memberCardSet = [NSMutableOrderedSet orderedSet];
                for (NSInteger i = 0; i < cardIds.count; i++)
                {
                    NSNumber *cardId = [NSNumber numberWithInteger:[[cardIds objectAtIndex:i] integerValue]];
                    CDMemberCard *memberCard = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCard" withValue:cardId forKey:@"cardID"];
                    if (memberCard == nil)
                    {
                        memberCard = [[BSCoreDataManager currentManager] insertEntity:@"CDMemberCard"];
                        memberCard.cardID = cardId;
                    }
                    [memberCardSet addObject:memberCard];
                }
                member.card = [NSOrderedSet orderedSetWithOrderedSet:memberCardSet];
                
                NSArray *couponIds = [params objectForKey:@"coupon_ids"];
                NSMutableOrderedSet *couponCardSet = [NSMutableOrderedSet orderedSet];
                for (NSInteger i = 0; i < couponIds.count; i++)
                {
                    NSNumber *couponId = [NSNumber numberWithInteger:[[couponIds objectAtIndex:i] integerValue]];
                    CDCouponCard *couponCard = [[BSCoreDataManager currentManager] findEntity:@"CDCouponCard" withValue:couponId forKey:@"cardID"];
                    if (couponCard == nil)
                    {
                        couponCard = [[BSCoreDataManager currentManager] insertEntity:@"CDCouponCard"];
                        couponCard.cardID = couponId;
                    }
                    [couponCardSet addObject:couponCard];
                }
                member.coupons = [NSOrderedSet orderedSetWithOrderedSet:couponCardSet];
                
                if (cardIds.count > 0 && DEVICE_IS_IPAD && !self.onlyMemberInfo )
                {
                    BSFetchMemberCardRequest *memberRequest = [[BSFetchMemberCardRequest alloc] initWithMemberCardIds:cardIds];
                    [memberRequest execute];
                }
                
                if (couponIds.count > 0 && DEVICE_IS_IPAD && !self.onlyMemberInfo)
                {
                    BSFetchCouponCardRequest *couponRequest = [[BSFetchCouponCardRequest alloc] initWithCouponCardIds:couponIds];
                    [couponRequest execute];
                }
            }
        }
        [[BSCoreDataManager currentManager] save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求数据错误"];
    }
    
    if ( self.finished )
    {
        self.finished(dict);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchMemberDetailResponse object:nil userInfo:dict];
}

@end
