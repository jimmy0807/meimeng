//
//  BSFetchMemberDetailReqeustN.m
//  meim
//
//  Created by jimmy on 2017/7/5.
//
//

#import "BSFetchMemberDetailReqeustN.h"
#import "ChineseToPinyin.h"

@interface BSFetchMemberDetailRequestN ()
@property (nonatomic, strong)NSNumber *memberID;
@end

@implementation BSFetchMemberDetailRequestN

- (id)initWithMemberID:(NSNumber *)memberID
{
    self = [super init];
    if (self)
    {
        self.memberID = memberID;
    }
    
    return self;
}

- (BOOL)willStart
{
    PersonalProfile *profile = [PersonalProfile currentProfile];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = profile.userID;
    if ( self.memberID )
    {
        params[@"member_id"] = self.memberID;
    }
    
    if ( [self.memberID integerValue] == 0 )
    {
        return FALSE;
    }
    
    [self sendRpcXmlCommand:@"/xmlrpc/2/ds_api" method:@"member_detail" params:@[params]];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSDictionary *resultList = [BNXmlRpc dictionaryWithXmlRpc:resultStr];
    NSDictionary* dict = [self generateDsApiResponse:resultList];
    
    if (resultStr.length != 0 && resultList != nil && [resultList isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *resuntDitc = (NSDictionary *)resultList;
        NSDictionary *params = [resuntDitc objectForKey:@"data"];
        
        if ([params isKindOfClass:[NSDictionary class]])
        {
            NSNumber *memberID = [params objectForKey:@"id"];
            CDMember *member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:memberID forKey:@"memberID"];
            if( member == nil )
            {
                member = [[BSCoreDataManager currentManager] insertEntity:@"CDMember"];
                member.memberID = memberID;
            }
        
            //, coupon_product_ids, operate_ids, product_ids
            member.birthday = [params stringValueForKey:@"birth_date"];
            member.member_shejishi_id = [params numberValueForKey:@"designers_id"];
            member.member_shejishi_name = [params stringValueForKey:@"designers_name"];
            member.director_employee_id = [params numberValueForKey:@"director_employee_id"];
            member.director_employee = [params stringValueForKey:@"director_employee_name"];
            member.email = [params stringValueForKey:@"email"];
            member.member_guwen_id = [params numberValueForKey:@"employee_id"];
            member.employee_name = [params stringValueForKey:@"employee_name"];
            member.member_guwen_name = [params stringValueForKey:@"employee_name"];
            member.gender = [params stringValueForKey:@"gender"];
            member.idCardNumber = [params stringValueForKey:@"id_card_no"];
            member.parent_id = [params stringValueForKey:@"parent_name"];
            member.image_url = [params stringValueForKey:@"image_url"];
            member.isDefaultCustomer = [params numberValueForKey:@"is_default_customer"];
            member.yimei_member_type = [params stringValueForKey:@"member_type"];
            member.mobile = [params stringValueForKey:@"mobile"];
            member.memberName = [params stringValueForKey:@"name"];
            member.memberNameLetter = [ChineseToPinyin pinyinFromChiniseString:member.memberName];
            member.memberNameFirstLetter = [[ChineseToPinyin pinyinFirstLetterString:member.memberName] uppercaseString];
            member.arrearsAmount = [params stringValueForKey:@"course_arrears_amount"];
            member.courseArrearsAmount = [params stringValueForKey:@"arrears_amount"];
            //NSLog(@"会员详细推荐人号码N=%@",[params stringValueForKey:@"parent_name"]);
            if ([[params stringValueForKey:@"state"] isEqualToString:@"done"])
            {
                member.isAcitve = @(TRUE);
            }
            else
            {
                member.isAcitve = @(FALSE);
            }
            
            //亲友
            [[BSCoreDataManager currentManager] deleteObjects:member.qinyous.array];
            NSArray *qy = [params arrayValueForKey:@"relatives_ids"];
            NSMutableOrderedSet *qinyous = [NSMutableOrderedSet orderedSet];
            for ( NSDictionary* params in qy )
            {
                NSNumber* qy_id = [params numberValueForKey:@"id"];
                CDMemberQinyou *qinyou = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDMemberQinyou" withValue:qy_id forKey:@"qy_id"];
                qinyou.birthday = [params stringValueForKey:@"birth_date"];
                qinyou.card_id = [params numberValueForKey:@"card_id"];
                qinyou.card_no = [params stringValueForKey:@"card_no"];
                qinyou.gender = [params stringValueForKey:@"gender"];
                qinyou.telephone = [params stringValueForKey:@"mobile"];
                qinyou.partner_id = [params numberValueForKey:@"partner_id"];
                qinyou.relative_card_no = [params stringValueForKey:@"relatives_card_no"];
                [qinyous addObject:qinyou];
            }
            member.qinyous = qinyous;
            
            //卡
            //[[BSCoreDataManager currentManager] deleteObjects:member.card.array];
            NSArray *cards = [params arrayValueForKey:@"member_ids"];
            NSMutableOrderedSet *memberCardSet = [NSMutableOrderedSet orderedSet];
            for ( NSDictionary* params in cards )
            {
                NSNumber *cardId = [params numberValueForKey:@"id"];
                CDMemberCard *memberCard = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCard" withValue:cardId forKey:@"cardID"];
                if (memberCard == nil)
                {
                    memberCard = [[BSCoreDataManager currentManager] insertEntity:@"CDMemberCard"];
                    memberCard.cardID = cardId;
                }
                
                memberCard.amount = [params stringValueForKey:@"amount"];
                memberCard.arrearsAmount = [params stringValueForKey:@"arrears_amount"];
                memberCard.courseArrearsAmount = [params stringValueForKey:@"course_arrears_amount"];
                memberCard.giveAmount = [params stringValueForKey:@"give_amount"];
                memberCard.invalidDate = [params stringValueForKey:@"invalid_date"];
                memberCard.cardName = [params stringValueForKey:@"name"];
                memberCard.cardNo = [params stringValueForKey:@"no"];
                memberCard.cardNumber = [params stringValueForKey:@"no"];
                memberCard.balance = [params stringValueForKey:@"amount"];
                memberCard.points = [params stringValueForKey:@"points"];
                memberCard.is_share = [params numberValueForKey:@"share"];
                memberCard.default_code = [params stringValueForKey:@"default_code"];
                
                CDMemberPriceList* list = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDMemberPriceList" withValue:[params numberValueForKey:@"pricelist_id"] forKey:@"priceID"];
                list.name = [params stringValueForKey:@"pricelist_name"];
                memberCard.priceList = list;
                
                NSString *state = [params stringValueForKey:@"state"];
                memberCard.isActive = [NSNumber numberWithBool:NO];
                if ([state isEqualToString:@"active"])
                {
                    memberCard.isActive = [NSNumber numberWithBool:YES];
                    memberCard.state = [NSNumber numberWithInteger:kPadMemberCardStateActive];
                }
                else if ([state isEqualToString:@"draft"])
                {
                    memberCard.state = [NSNumber numberWithInteger:kPadMemberCardStateDraft];
                }
                else if ([state isEqualToString:@"lost"])
                {
                    memberCard.state = [NSNumber numberWithInteger:kPadMemberCardStateLost];
                }
                else if ([state isEqualToString:@"replacement"])
                {
                    memberCard.state = [NSNumber numberWithInteger:kPadMemberCardStateReplacement];
                }
                else if ([state isEqualToString:@"merger"])
                {
                    memberCard.state = [NSNumber numberWithInteger:kPadMemberCardStateMerger];
                }
                else if ([state isEqualToString:@"unlink"])
                {
                    memberCard.state = [NSNumber numberWithInteger:kPadMemberCardStateUnlink];
                }
                
                NSNumber *storeID = [params numberValueForKey:@"shop_id"];
                CDStore *store = [[BSCoreDataManager currentManager] findEntity:@"CDStore" withValue:storeID forKey:@"storeID"];
                if (store == nil)
                {
                    store = [[BSCoreDataManager currentManager] insertEntity:@"CDStore"];
                    store.storeID = storeID;
                }
                store.storeName = [params stringValueForKey:@"shop_name"];
                memberCard.store = store;
                memberCard.storeID = storeID;
                memberCard.storeName = [params stringValueForKey:@"shop_name"];
                
                [memberCardSet addObject:memberCard];
                
                //[[BSCoreDataManager currentManager] deleteObjects:memberCard.projects.array];
                memberCard.projects = [NSMutableOrderedSet orderedSet];
                memberCard.member = member;
            }
            member.card = memberCardSet;
            
            //优惠券
            member.coupons = [NSMutableOrderedSet orderedSet];
            //[[BSCoreDataManager currentManager] deleteObjects:member.coupons.array];
            NSArray *coupons = [params arrayValueForKey:@"coupon_ids"];
            NSMutableOrderedSet *couponCardSet = [NSMutableOrderedSet orderedSet];
            for ( NSDictionary* params in coupons )
            {
                NSNumber *cardId = [params numberValueForKey:@"id"];
                CDCouponCard *couponCard = [[BSCoreDataManager currentManager] findEntity:@"CDCouponCard" withValue:cardId forKey:@"cardID"];
                if ( couponCard == nil )
                {
                    couponCard = [[BSCoreDataManager currentManager] insertEntity:@"CDCouponCard"];
                    couponCard.cardID = cardId;
                }
                
                couponCard.cardName = [params stringValueForKey:@"name"];
                couponCard.cardNumber = [params stringValueForKey:@"no"];
                NSString *state = [params stringValueForKey:@"state"];
                if ([state isEqualToString:@"draft"])
                {
                    couponCard.state = [NSNumber numberWithInteger:kPadCouponCardStateDraft];
                }
                else if ([state isEqualToString:@"published"])
                {
                    couponCard.state = [NSNumber numberWithInteger:kPadCouponCardStatePublished];
                }
                else if ([state isEqualToString:@"active"])
                {
                    couponCard.state = [NSNumber numberWithInteger:kPadCouponCardStateActive];
                }
                else if ([state isEqualToString:@"used"])
                {
                    couponCard.state = [NSNumber numberWithInteger:kPadCouponCardStateUsed];
                }
                else if ([state isEqualToString:@"invalid"])
                {
                    couponCard.state = [NSNumber numberWithInteger:kPadCouponCardStateInvalid];
                }
                else if ([state isEqualToString:@"unlink"])
                {
                    couponCard.state = [NSNumber numberWithInteger:kPadCouponCardStateUnlink];
                }
                couponCard.remainAmount = [params numberValueForKey:@"remain_amount"];
                couponCard.amount = [params numberValueForKey:@"remain_amount"];
                NSString *remarkstr = [[[NSAttributedString alloc] initWithData:[[params stringValueForKey:@"remark"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil] string];
                remarkstr = [remarkstr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                couponCard.remark = remarkstr;
                couponCard.discount = [NSNumber numberWithDouble:[[params objectForKey:@"discount"] doubleValue]];
                
                [couponCardSet addObject:couponCard];
                
                couponCard.products = [NSMutableOrderedSet orderedSet];
                couponCard.invalidDate = [params stringValueForKey:@"invalid_date"];
                //[[BSCoreDataManager currentManager] deleteObjects:couponCard.products.array];
            }
            
            member.coupons = couponCardSet;
            
            //coupon_product_ids
            NSArray *products = [params arrayValueForKey:@"coupon_product_ids"];
            for ( NSDictionary* params in products )
            {
                NSNumber *productLineID = [params numberValueForKey:@"id"];
                CDCouponCardProduct *product = [[BSCoreDataManager currentManager] findEntity:@"CDCouponCardProduct" withValue:productLineID forKey:@"productLineID"];
                if (product == nil)
                {
                    product = [[BSCoreDataManager currentManager] insertEntity:@"CDCouponCardProduct"];
                    product.productLineID = productLineID;
                }
                
                product.couponName = [params stringValueForKey:@"name_template"];
                product.productID = [params numberValueForKey:@"product_id"];
                
                CDProjectItem *item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:product.productID forKey:@"itemID"];
                if (item == nil)
                {
                    item = [[BSCoreDataManager currentManager] insertEntity:@"CDProjectItem"];
                    item.itemID = product.productID;
                    product.uomName = @"";
                    product.defaultCode = @"";
                }
                else
                {
                    product.uomID = item.uomID;
                    product.uomName = item.uomName;
                    product.defaultCode = item.defaultCode;
                }
                product.item = item;
                
                product.productName = item.itemName;
                product.remainQty = [params numberValueForKey:@"course_remain_qty"];
                product.unitPrice = [params numberValueForKey:@"price_unit"];
                product.lastUpdate = [params stringValueForKey:@"create_date"];
                
                CDCouponCard *couponCard = [[BSCoreDataManager currentManager] findEntity:@"CDCouponCard" withValue:[params numberValueForKey:@"coupon_id"] forKey:@"cardID"];
                product.coupon = couponCard;
            }
            
            //product_ids
            products = [params arrayValueForKey:@"product_ids"];
            for ( NSDictionary* params in products )
            {
                NSNumber *productLineID = [params numberValueForKey:@"id"];
                CDMemberCardProject *product = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCardProject" withValue:productLineID forKey:@"productLineID"];
                if (product == nil)
                {
                    product = [[BSCoreDataManager currentManager] insertEntity:@"CDMemberCardProject"];
                    product.productLineID = productLineID;
                }
                
                product.projectName = [params stringValueForKey:@"name"];
                product.projectID = [params numberValueForKey:@"product_id"];
                
                CDProjectItem *item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:product.projectID forKey:@"itemID"];
                if (item == nil)
                {
                    item = [[BSCoreDataManager currentManager] insertEntity:@"CDProjectItem"];
                    item.itemID = product.projectID;
                    item.itemName = product.projectName;
                    product.uomName = @"";
                    product.defaultCode = @"";
                }
                else
                {
                    product.uomID = item.uomID;
                    product.uomName = item.uomName;
                    product.defaultCode = item.defaultCode;
                }
                product.item = item;
                
                product.remainQty = [params numberValueForKey:@"remain_qty"];
                product.projectCount = [params numberValueForKey:@"remain_qty"];
                product.projectPriceUnit = [params numberValueForKey:@"price_unit"];
                product.born_category = [params numberValueForKey:@"born_category"];
                product.limitedDate = [params stringValueForKey:@"limited_date"];
                product.isLimited = [params numberValueForKey:@"limited_qty"];
                product.create_date = [params stringValueForKey:@"create_date"];
                
                CDMemberCard *card = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCard" withValue:[params numberValueForKey:@"card_id"] forKey:@"cardID"];
                product.card = card;
            }
            
            //operate_ids
            [[BSCoreDataManager currentManager] deleteObjects:member.recentOperates.array];
            NSArray *operates = [params arrayValueForKey:@"operate_ids"];

            for ( NSDictionary* params in operates )
            {
                NSNumber *operateID = [params numberValueForKey:@"id"];
                CDPosOperate *operate = [[BSCoreDataManager currentManager] findEntity:@"CDPosOperate" withValue:operateID forKey:@"operate_id"];
                if (operate == nil)
                {
                    operate = [[BSCoreDataManager currentManager] insertEntity:@"CDPosOperate"];
                    operate.operate_id = operateID;
                }
                
                operate.isLocal = @(FALSE);
                operate.name = [params stringValueForKey:@"name"];
                operate.display_remark = [params stringValueForKey:@"display_remark"];
                if ( operate.display_remark.length == 0 || [operate.display_remark isEqualToString:@"0"] )
                {
                    operate.display_remark = @"无备注";
                }
                
                [[BSCoreDataManager currentManager] deleteObjects:operate.yimei_before.array];
                
                operate.yimei_before = [NSMutableOrderedSet orderedSet];
                if ( [params stringValueForKey:@"image_ids"].length > 0 )
                {
                    NSArray* image_ids = [[params stringValueForKey:@"image_ids"] componentsSeparatedByString:@","];
                    for ( NSString* url in image_ids )
                    {
                        NSArray* image_info = [url componentsSeparatedByString:@"@"];
                        if (image_info.count <= 1) {
                            break;
                        }
                        CDYimeiImage* a = [[BSCoreDataManager currentManager] insertEntity:@"CDYimeiImage"];
                        a.before = operate;
                        a.url = image_info[0];
                        a.take_time = image_info[1];
                        a.type = @"server";
                        a.status = @"success";
                    }
                }
                
                operate.recentMember = member;
            }
        }
    }
    
    if ( self.finished )
    {
        self.finished(dict);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchMemberCardDetailResponse object:nil userInfo:dict];
}

@end
